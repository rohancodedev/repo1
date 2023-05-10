const axios = require('axios');
const querystring = require('querystring');
const FormData = require('form-data');

const oVCAP_SERVICES = JSON.parse(process.env.VCAP_SERVICES),
    sdmService = oVCAP_SERVICES.sdm[0].credentials,
    clientID = sdmService.uaa.clientid,
    uaaCredentials = clientID + ':' + sdmService.uaa.clientsecret,
    sdmURL = sdmService.endpoints.ecmservice.url,
    oAuthUrlString = sdmService.uaa.url + '/oauth/token',
    createRepoEndpoint = "rest/v2/repositories",
    readRepoEndpoint = "browser";

module.exports = async function (srv) {

    srv.on("createFolderInRepository", async (req) => {
        var inputData = req.data["input"];

        if (!inputData.repoName) {
            return {
                "inputData": inputData,
                "userResponse": "No Repo Name provided"
            }
        }

        if (!inputData.folderName) {
            return {
                "inputData": inputData,
                "userResponse": "No Folder Name provided"
            }
        }

        var response = await createFolderInRepository(inputData);

        return {
            "userResponse": response
        };

    });

    srv.on("getRepositories", async (req) => {
        var token = await getOAuthToken(),
            userResponse = await getRepo(token);

        return {
            "userResponse": userResponse
        };
    });

    srv.on("checkFolderInRepository", async (req) => {
        var repoName = req.data.repoName,
            folderName = req.data.folderName,
            response = await checkFolderInRepository(repoName, folderName);

        return {
            "userResponse": response
        };

    });

    srv.on("checkRepository", async (req) => {
        var repoName = req.data.repoName,
            response = await checkRepository(repoName);

        return {
            "userResponse": response
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

async function checkFolderInRepository(repoName, folderName) {
    var repoCheck = await checkRepository(repoName);
    if (!repoCheck.isRepoFound) {
        return {
            "repoName": inputData.repoName,
            "message": "Repository ( " + inputData.repoName + " ) Not Found in DMS"
        }
    }

    var urlString = sdmURL + readRepoEndpoint + "/" + repoCheck.response.repositoryId + "/root/",
        token = await getOAuthToken(),
        config = {
            "method": "GET",
            "url": urlString,
            "headers": {
                "Authorization": "Bearer " + token.access_token
            }
        };

    var response = await axios(config),
        isFolderExist = false;

    for (var ctr = 0; ctr < response.data.objects.length; ctr++) {
        var object = ((response.data.objects[ctr]).object).properties;
        for (var key in object) {
            if ((key === "cmis:name") && ((object[key]).value === folderName)) {
                isFolderExist = true;
                break;
            }
        }
    }

    return {
        "isFolderExist": isFolderExist
    }
}

async function checkRepository(repoName) {
    if (!repoName) {
        return {
            "isRepoFound": false,
            "repoName": repoName,
            "message": "Repository ( " + repoName + " ) Not Found"
        }
    }

    var token = await getOAuthToken(),
        response = await getRepo(token),
        repo = null;

    for (var key in response) {
        var oValue = response[key];
        for (var key1 in oValue) {
            if ((key1 === "repositoryName") && (oValue[key1] === repoName)) {
                repo = oValue;
                break;
            }
        }
    }

    if (repo === null) {
        return {
            "isRepoFound": false,
            "repoName": repoName,
            "message": "Repository ( " + repoName + " ) Not Found"
        }
    } else {
        return {
            "isRepoFound": true,
            "repoName": repoName,
            "response": repo
        }
    }
}

async function createRepo(inputData, token) {
    var data = JSON.stringify(inputData),
        urlString = sdmURL + createRepoEndpoint,
        config = {
            "method": "post",
            "url": urlString,
            "headers": {
                "Content-Type": "application/json",
                "Authorizat.ion": "Bearer " + token.access_token
            },
            "data": data
        };

    console.log("<========== DMS-Service createRepo config ==========>  ::   " + JSON.stringify(config));

    var response = await axios(config);
    return response.data;
}

async function createFolderInRepository(inputData) {
    var repoCheck = await checkRepository(inputData.repoName),
        urlString = sdmURL + readRepoEndpoint + "/" + repoCheck.response.repositoryId + "/root/";

    if (!repoCheck.isRepoFound) {
        return {
            "isFolderExist": false,
            "repoName": inputData.repoName,
            "message": "Repository ( " + inputData.repoName + " ) Not Found in DMS"
        }
    }

    var folderCheck = await checkFolderInRepository(inputData.repoName, inputData.folderName);
    if (folderCheck.isFolderExist) {
        return {
            "isFolderExist": folderCheck.isFolderExist,
            "repoName": inputData.repoName,
            "folderName": inputData.folderName,
            "message": "Folder ( " + inputData.folderName + " ) Already Exists in Repository ( " + inputData.repoName + " )"
        }
    }

    var token = await getOAuthToken(),
        data = new FormData();

    data.append('cmisaction', 'createFolder');
    data.append('objectId', repoCheck.response.rootFolderId);
    data.append('propertyId[0]', 'cmis:name');
    data.append('propertyValue[0]', inputData.folderName);
    data.append('propertyId[1]', 'cmis:objectTypeId');
    data.append('propertyValue[1]', 'cmis:folder');
    data.append('succinct', 'true');

    var config = {
        method: 'post',
        url: urlString,
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            "Authorization": "Bearer " + token.access_token,
            ...data.getHeaders()
        },
        data: data
    };

    var response = await axios(config);
    return response.data;
}