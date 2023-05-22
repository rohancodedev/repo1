
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

        userResponse = JSON.parse(userResponse);

        return {
            "userResponse": {
                "status": userResponse.status,
                "code": userResponse.code,
                "message": userResponse.message
            }
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
    var token = destinationDetails.authTokens[0],
        data = qs.stringify(inputData),
        config = {
            "url": destinationDetails.destinationConfiguration.URL + sEndpoint,
            "method": "POST",
            "headers": {
                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": `${token.type} ${token.value}`
            },
            "validateStatus": function (status) {
                return (status < 500);
            },
            "data": data
        };

    var message = "",
        statusCode = "";

    return await axios(config)
        .then((response) => {
            message = response.data;
            statusCode = response.status;

            if (statusCode === 409) {
                message = message.substring(0, message.indexOf("[X") - 1);
            } else if (statusCode === 400) {
                message = "The user for whom you are trying to create an user is inactive";
            } else if (statusCode === 201) {
                message = "User Created Successfully";
            }

            return JSON.stringify({
                "status": "SUCCESS",
                "code": statusCode,
                "message": message
            });
        })
        .catch((error) => {
            message = error.response.data;
            statusCode = error.response.status;

            return JSON.stringify({
                "status": "ERROR",
                "code": statusCode,
                "message": message
            });
        });
}
