@protocol: 'rest'
@path    : 'dmsRestService'
service dmsService @(impl: './dms-service.js') {
    @open
    type object {};

    action   createRepository(input : object)                                                                                                                     returns object;
    action   createFolderInRepository(input : object)                                                                                                             returns object;
    function getRepositories()                                                                                                                                    returns object;
    function checkRepository(repoName : String)                                                                                                                   returns object;
    function checkFolderInRepository(repoName : String, folderName : String)                                                                                      returns object;
    function getUploadDocumentDetials(repoName : String, folderName : String)                                                                                     returns object;
    function displayDocumentDetails(dmsFileName : String, dmsObjectID : String, dmsRepositoryDescription : String, dmsRepositoryId : String, dmsRepositoryName : String) returns object;
}


/* Test Data for createFolderInRepository */
// {
//     "input" : {
//         "repoName":"Test DMS009",
//         "folderName":"abcd"
//     }
// }
/* Test Data for createFolderInRepository */

/* Test Data for checkRepository */
// https://crossindustry-capm-vendor-buyer.cfapps.eu10.hana.ondemand.com/dmsRestService/checkRepository (repoName='Test DMS009')
/* Test Data for checkRepository */


/* Test Data for createRepository */
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
/* Test Data for createRepository */
