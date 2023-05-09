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
    const response = await axios({
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
      "method": "post",
      "url": destinationDetails.destinationConfiguration.URL + sEndpoint,
      "headers": {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": destinationDetails.authTokens[0].http_header.value
      },
      "data": inputData
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

  async startWorkflow(inputData) {
    if (inputData === undefined) {
      console.error("Please provide valid workflow context payload");
      return {
        "status": "ERROR",
        "code": 999,
        "message": "Please provide valid workflow context payload",
        "responseData": {}
      }
    }

    try {
      var token = await this.getOAuthToken(),
        accessToken = token.access_token,
        destinationDetails = await this.getDestinationDetails(accessToken, sDestinationName),
        returnValue = await this.tiggerWorkFlowInstance(inputData, destinationDetails);

      return returnValue.responseData;
    } catch (error) {
      console.error(error);
    }
  }
};
