@protocol: 'rest'
@path    : 'dmsRestService'
service dmsService @(impl: './dms-service.js') {
    @open
    type object {};

    action   createRepository(input : object) returns object;
    function getRepositories()                returns object;
}


/* Test Data for CreateRepository */
// {
//     "input": {
//         "repository": {
//             "displayName": "Test DMS007",
//             "description": "Test DMS007",
//             "repositoryType": "internal",
//             "isVersionEnabled": "true",
//             "isVirusScanEnabled": "false",
//             "skipVirusScanForLargeFile": "true",
//             "hashAlgorithms": "None"
//         }
//     }
// }
/* Test Data for CreateRepository */
