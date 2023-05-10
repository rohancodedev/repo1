const axios = require('axios');
const querystring = require('querystring');

const oVCAP_SERVICES = JSON.parse(process.env.VCAP_SERVICES),
    sdmService = oVCAP_SERVICES.sdm[0].credentials,
    clientID = sdmService.uaa.clientid,
    uaaCredentials = clientID + ':' + sdmService.uaa.clientsecret,
    sdmURL = sdmService.endpoints.ecmservice.url,
    oAuthUrlString = sdmService.uaa.url + '/oauth/token',
    createRepoEndpoint = "rest/v2/repositories",
    readRepoEndpoint = "browser";

module.exports = async function (srv) {

    srv.on("getRepositories", async (req) => {
        var token = await getOAuthToken(),
            userResponse = await getRepo(token);

        return {
            "userResponse": userResponse
        };
    });

    srv.on("createRepository", async (req) => {
        var inputData = req.data["input"],
            token = await getOAuthToken(),
            userResponse = await createRepo(inputData, token);

        return {
            "userResponse": userResponse
        };
    });
};

async function getOAuthToken() {
    var response = await axios({
        "method": "POST",
        "responseType": 'json',
        "url": oAuthUrlString,
        "data": querystring.stringify({
            "grant_type": "client_credentials",
            "client_id": clientID
        }),
        "headers": {
            "Authorization": 'Basic ' + Buffer.from(uaaCredentials).toString('base64'),
            "content-type": "application/x-www-form-urlencoded"
        }
    });

    return response.data;
}

async function getRepo(token) {
    var urlString = sdmURL + readRepoEndpoint,
        config = {
            "method": "GET",
            "url": urlString,
            "headers": {
                "Authorization": "Bearer " + token.access_token
            }
        };

    console.log("<========== DMS-Service getRepo config ==========>  ::   " + JSON.stringify(config));

    var response = await axios(config);
    return response.data;
}

async function createRepo(inputData, token) {
    var data = JSON.stringify(inputData),
        urlString = sdmURL + createRepoEndpoint,
        config = {
            "method": "post",
            "url": urlString,
            "headers": {
                "Content-Type": "application/json",
                "Authorization": "Bearer " + token.access_token
            },
            "data": data
        };

    console.log("<========== DMS-Service createRepo config ==========>  ::   " + JSON.stringify(config));

    var response = await axios(config);
    return response.data;
}
