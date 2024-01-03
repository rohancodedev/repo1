using {com.ltim.vendor.buyer as question} from '../db/questionnaire-model';

@protocol: 'rest'
@path    : 'questionnaireRestService'

service questionnaireService @(impl: './questionnaire-service.js') {

    entity Questionnaire              as projection on question.Questionnaire;
    entity Classifications            as projection on question.Classifications;
    entity QTypes                     as projection on question.QTypes;
    entity MultipleChoices            as projection on question.MultipleChoices;
    entity QuestionnaireLineitems     as projection on question.QuestionnaireLineitems;
    entity PQQuestionnaire            as projection on question.PQQuestionnaire;
    entity PQQuestionnaires           as projection on question.PQQuestionnaires;
    entity notes                      as projection on question.notes;
    entity PQQSuppliers               as projection on question.PQQSuppliers;
    entity logsPQQ                    as projection on question.logsPQQ;
    entity BuyerSupplierConversations as projection on question.BuyerSupplierConversations;
    entity ConversationAttachments    as projection on question.ConversationAttachments;
    entity documentRespository        as projection on question.documentRespository;
    entity cmisMessengerFolder        as projection on question.cmisMessengerFolder;
    entity ToSuppliers                as projection on question.ToSuppliers;
    entity Responses                  as projection on question.Responses;
    entity ResponseItems              as projection on question.ResponseItems;
    entity ResponseChoices            as projection on question.ResponseChoices;
    entity cmisFolder                 as projection on question.cmisFolder;

    entity Questions as
        select from question.Questions {
            ID,
            questionNumber,
            clasification,
            qType,
            question,
            responseType,
            response,
            attachmentRequired,
            classifiDescription,
            qTypeDescription,
            remarks,
            respNumorChar,
            isNumeric,
            choices
        }
        order by 
            questionNumber asc;

    type supplierList {
        email        : String(60);
        supplierName : String;
        supplierID   : String(12);
    }

    function publish(ID : question.PQQuestionnaires:ID)                                               returns String;
    function amend(ID : question.PQQuestionnaires:ID, status : String)                                returns String;
    function updateLogs(ID : UUID, version : Integer, remarks : String, sno : Integer)                returns String;
    function Supplier_notificationPublish(ID : String)                                                returns String;
    function Supplier_notificationPublishDateReduce(ID : String)                                      returns String;
    function Supplier_notificationPublishDateExtend(ID : String)                                      returns String;
    function Supplier_notificationCancel(ID : String)                                                 returns String;
    function getLoggedInUserInfo()                                                                    returns String;
    function updateWFPQQSupplier(ID : UUID, wfstatus : String, wfinstance : String)                   returns String;
    function updateWFPQQ(ID : UUID, wfstatus : String, wfinstance : String)                           returns String;
    function approver_notificationSubmit(ID : String, email : String)                                 returns String;
    function approver_notificationSubmitAmend(ID : String, email : String, bodyText : String)         returns String;
    function generatePQQNo()                                                                          returns String;
    action   addNotes(notesType : String, version : Integer, BodyText : String, UUID : String)        returns String;
    action   supplier_notification(ID : String, bodyText : String, suppliers : array of supplierList) returns String;

    type excelUpload {
        ID                                    : String(150);
        Question_Number                       : String(150);
        //clasification: String(150);
        //qType: String(150);
        Question                              : String(150);
        responseType                          : String(150);
        response                              : String(150);
        Attach_Required                       : String(150);
        Classification                        : String(150);
        Question_Type                         : String(150);
        Add_Remarks                           : String(150);
        respNumorChar                         : String(150);
        Numeric_Only                          : String(150);
        Choices_Add_Choice_in_Comma_Seperated : String(1000);
    }

    action   uploadItemsExcelData(excelUpload : array of excelUpload)                                 returns String;
}
