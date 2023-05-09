
const axios = require('axios');
const querystring = require('querystring');
const qs = require('qs');

const sDestinationName = "IAS",
    sEndpoint = "/service/users",
    oVCAP_SERVICES = JSON.parse(process.env.VCAP_SERVICES),
    uaaService = oVCAP_SERVICES.xsuaa[0].credentials,
    destService = oVCAP_SERVICES.destination[0].credentials,
    destServiceClientID = destService.clientid,
    sUaaCredentials = destServiceClientID + ':' + destService.clientsecret,
    oAuthUrlString = uaaService.url + '/oauth/token';


module.exports = async function (srv) {

    srv.on("createIASUser", async (req) => {
        var inputData = req.data["input"],
            token = await getOAuthToken(),
            accessToken = token.access_token,
            destinationDetails = await getDestinationDetails(accessToken, sDestinationName),
            userResponse = await createUser(inputData, destinationDetails);

        return {
            "userResponse": userResponse
        };
    });
};

async function getOAuthToken() {
    const response = await axios({
        "method": "POST",
        "responseType": 'json',
        "url": oAuthUrlString,
        "data": querystring.stringify({
            "grant_type": "client_credentials",
            "client_id": destServiceClientID
        }),
        "headers": {
            "Authorization": 'Basic ' + Buffer.from(sUaaCredentials).toString('base64'),
            "content-type": "application/x-www-form-urlencoded"
        }
    });

    return response.data;
}

async function getDestinationDetails(accessToken, destinationName) {
    const queryString = destService.uri + "/destination-configuration/v1/destinations/" + destinationName;
    const destResponse = await axios({
        "method": "GET",
        "responseType": 'json',
        "url": queryString,
        "headers": {
            "Authorization": 'Bearer ' + accessToken
        }
    });

    return destResponse.data;
}

async function createUser(inputData, destinationDetails) {
    var data = qs.stringify(inputData),
        config = {
            "method": "post",
            "url": destinationDetails.destinationConfiguration.URL + sEndpoint,
            "headers": {
                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": destinationDetails.authTokens[0].http_header.value
            },
            "data": data
        };

    return axios.request(config)
        .then((response) => {
            return {
                "status": "SUCCESS",
                "code": response.status,
                "message": response.data,
                "responseData": response
            };
        })
        .catch((error) => {
            return {
                "status": "ERROR",
                "code": error.response.status,
                "message": error.response.data,
                "responseData": error
            };
        });
}

