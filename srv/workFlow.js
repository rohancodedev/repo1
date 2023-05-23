const xsenv = require("@sap/xsenv"),
  axios = require("axios").default,
  querystring = require('querystring'),
  sDestinationName = "bpmworkflowruntime",
  sEndpoint = "/rest/v1/workflow-instances",
  oVCAP_SERVICES = JSON.parse(process.env.VCAP_SERVICES),
  uaaService = oVCAP_SERVICES.xsuaa[0].credentials,
  destService = oVCAP_SERVICES.destination[0].credentials,
  destServiceClientID = destService.clientid,
  sUaaCredentials = destServiceClientID + ':' + destService.clientsecret,
  oAuthUrlString = uaaService.url + '/oauth/token';

module.exports = class workFlow {
  constructor() { }

  async getOAuthToken() {
    var response = await axios({
      "method": "POST",
      "responseType": 'json',
      "url": oAuthUrlString,
      "data": querystring.stringify({
        "grant_type": "client_credentials",
        "client_id": destServiceClientID
      }),
      "headers": {
        "Authorization": 'Basic ' + Buffer.from(sUaaCredentials).toString('base64')
      }
    });

    return response.data;
  }

  async getDestinationDetails(accessToken, destinationName) {
    var queryString = destService.uri + "/destination-configuration/v1/destinations/" + destinationName,
      destResponse = await axios({
        "method": "GET",
        "responseType": 'json',
        "url": queryString,
        "headers": {
          "Authorization": 'Bearer ' + accessToken
        }
      });

    return destResponse.data;
  }

  async tiggerWorkFlowInstance(inputData, destinationDetails) {
    var config = {
      "method": "POST",
      "url": destinationDetails.destinationConfiguration.URL + sEndpoint,
      "headers": {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": destinationDetails.authTokens[0].http_header.value
      },
      "validateStatus": function (status) {
        return (status < 500);
      },
      "data": inputData
    };

    // var response = await axios(config);
    // return response.data;

    var message = "",
      statusCode = "";

    return axios(config)
      .then((response) => {
        message = response.data;
        statusCode = response.status;

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

  async startWorkflow(inputData) {
    if (inputData === undefined) {
      console.error("Please provide valid workflow context payload");
      return {
        "status": "ERROR",
        "code": 111,
        "message": "Please provide valid workflow context payload"
      }
    }

    var token = await this.getOAuthToken(),
      accessToken = token.access_token,
      destinationDetails = await this.getDestinationDetails(accessToken, sDestinationName),
      returnValue = await this.tiggerWorkFlowInstance(inputData, destinationDetails);

    returnValue = JSON.parse(returnValue);

    return returnValue;
  }
};
