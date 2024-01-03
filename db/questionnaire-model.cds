namespace com.ltim.vendor.buyer;

using {
    managed,
    cuid
} from '@sap/cds/common';

using {com.ltim.vendor.buyer as ct} from '../db/approverTable-model';
using {com.ltim.vendor.buyer as vb} from '../db/vendorBuyer-model';

type ResponseType      : String enum {
    Character;
    Numeric;
    Date;
    Currency;
    Selection
}

type WorkFlowStatusPQQ : String enum {
    Waiting   = 'X';
    Completed = 'Y';
    Rejected  = 'Z';
    Cancelled = 'V';
    Revised   = 'R';
}

type StatusQuestion           : String enum {
    Open;
    Close;
    Submitted;
    Approved;
    Rejected;
    Draft;
    Closed;
}

// entity starts from here
entity Questions : managed {
    key ID                  : UUID;
        questionNumber      : Integer;
        clasification       : String;
        qType               : String;
        question            : String;
        responseType        : ResponseType;
        response            : String;
        attachmentRequired  : Boolean;
        classifiDescription : String;
        qTypeDescription    : String;
        remarks             : Boolean;
        respNumorChar       : String;
        isNumeric           : Boolean;
        choices             : Composition of many MultipleChoices
                                  on choices.parent = $self;
}

entity Classifications {
    key sno   : Integer;
        ctype : String;
        code  : String;

}

entity QTypes {
    key sno       : Integer;
        qtype     : String;
        code      : String;
        uiElement : String;
        property1 : String;
        property2 : String;
        property3 : String;
        property4 : String;
}

entity MultipleChoices {
    key ID           : UUID;
        parent       : Association to Questions;
        questionNo   : Integer;
        choiceNo     : Integer;
        choiceOption : String;
}

entity Questionnaire : managed {
    key ID                 : UUID;
        questionnaireNo    : String(20);
        supplierRFQ        : String(1);
        questTitle         : String;
        rFQNo              : Integer;
        questNo            : Integer;
        submissionDeadline : DateTime;
        questionnaireItems : Composition of many QuestionnaireLineitems
                                 on questionnaireItems.parent = $self;


}

entity QuestionnaireLineitems {
    key ID                  : UUID;
        questionnaireLineNo : String(20);
        srno                : Integer;
        parent              : Association to Questionnaire;
        questionId          : String;
        questionnaireNo     : String(20);
        questionCode        : String;
        deletionIndicator   : String(1);
        weightage           : Integer;
        newWeightage        : Decimal(5, 2);
        scoreCard           : String;
        question            : String;
        quest               : Association to Questions;
}
// new code added by shankar 14/07/23

entity PQQuestionnaire : cuid, managed {
    parent              : Association to PQQuestionnaires;
    sno                 : Integer;
    questionType        : String(5);
    question            : String(250);
    response            : String(250);
    weightage           : String(3);
    upWeightage         : Integer;
    newWeightage        : Decimal(5, 2);
    ranking             : String(3);
    delete              : Boolean;
    attachmentRequired  : Boolean;
    remarks             : Boolean;
    isNumeric           : Boolean;
    classifiDescription : String;
    clasification       : String(5);
    qTypeDescription    : String;
    quest               : Association to Questions;
}

entity PQQuestionnaires : cuid, managed {
    version              : Integer; //Added due to Amendment
    deleted              : String(1);
    pqqNo                : String(10);
    pqqDescription       : String(150);
    itemCategory         : String(50);
    itemCategory2        : String(50);
    pQQuestionaaireNo    : String(10);
    pQQuestDesc          : String(50);
    status               : StatusQuestion;
    responseStartDateOld : String(10);
    responseEndDateOld   : String(10);
    responseStartDate    : String(10);
    responseEndDate      : String(10);
    pQQCreatedDate       : String(10);
    pQQPublishedDate     : String(10);
    companyCode          : String(20);
    companyDesc          : String(150);
    purchasingOrg        : String(50);
    purchOrgDesc         : String(250);
    purchasingGroup      : String(50);
    purchGroupDesc       : String(250);
    package              : String(10);
    project              : String(20); // Project No
    projectName          : String(150);
    wBSElement           : String(24); // WBS Element
    wBSElementDesc       : String(150);
    approvedDate         : String(10);
    publishedDate        : String(10);
    contactName          : String(150);
    telephoneNo          : String(25);
    cellNo               : String(36);
    faxNo                : String(36);
    emailID              : String(60);
    wfStatus             : WorkFlowStatusPQQ;
    worflowInstanceID    : String(50);
    suppliers            : Composition of many PQQSuppliers
                               on $self = suppliers.parent;
    questionnaires       : Composition of many PQQuestionnaire
                               on $self = questionnaires.parent;
    logspqq              : Composition of many logsPQQ
                               on $self = logspqq.parent;
    notes                : Composition of many notes
                               on $self = notes.parent;
}

entity notes : cuid, managed {
    parent    : Association to PQQuestionnaires;
    notesType : String;
    version   : Integer;
    BodyText  : String;
}

entity PQQSuppliers : cuid, managed {
    parent            : Association to PQQuestionnaires;
    pqqNo             : String(10);
    supplierId        : String(10); // Request Date
    supplierName      : String(36);
    supplierCode      : String(10);
    email             : String(60);
    telephoneNo       : String(12);
    responseID        : String(10);
    responseUUID      : String;
    responseStatus    : StatusQuestion;
    supplierStatus    : StatusQuestion;
    responseSubmitted : DateTime;
    score             : Integer;
    delete            : Boolean;
    isApproved        : Boolean;
    wfStatus          : WorkFlowStatusPQQ;
    worflowInstanceID : String(50);
}

entity logsPQQ : cuid, managed {
    parent        : Association to PQQuestionnaires;
    sno           : Integer;
    remarks       : String(500);
    actiondetails : String(50);
}

entity BuyerSupplierConversations : cuid, managed {
    queryOrResponse       : String;
    conversationNo        : String(10);
    version               : Integer;
    appType               : String(20);
    icon                  : String(50);
    color                 : String(50);
    attachment            : Association to ConversationAttachments;
    participantFirstName  : String;
    participantLastName   : String;
    participantFullName   : String;
    participantRole       : String;
    attachmentMessengerId : String(255);
    attachmentFolder      : Composition of one cmisMessengerFolder
                                on $self = attachmentFolder.parent;
    toSuppliers           : Composition of many ToSuppliers
                                on $self = toSuppliers.parent;
}

entity ConversationAttachments : cuid, managed {
    parent         : Association to BuyerSupplierConversations;
    conversationNo : String(10);
    sno            : vb.attachmentsList:sno; // Serial Number for Order
    attachmentId   : vb.attachmentsList:attachmentId; // Attachment ID
    fileTitle      : vb.attachmentsList:fileTitle; // Attachment File Title
    fileName       : vb.attachmentsList:fileName; // Uploaded File Name
    fileURL        : vb.attachmentsList:fileURL; // Attachment File URL
    status         : vb.attachmentsList:status default 'None'; // Delete Status: If 'None' file is not Uploaded.
    type           : vb.attachmentsList:type; // Attachment Document Type File or Link.
}


entity cmisMessengerFolder : cuid, managed { // LTI BU (Bukrs)
    folderName     : String(50);
    parent         : Association to BuyerSupplierConversations; // CMIS Folder Name
    documentCenter : ct.documentRespository:documentAPIID;
    createFolder   : String(36);
}

entity ToSuppliers : cuid, managed {
    supplierCode      : String(12);
    supplierID        : String(12);
    email             : String(60);
    supplierFirstName : String;
    suppliertLastName : String;
    supplierFullName  : String;
    parent            : Association to BuyerSupplierConversations;
}

entity Responses : cuid, managed {
    responseNo        : String(20);
    pqQuestionnaireNo : String(20);
    pqqDescription    : String(150);
    supplierCode      : String;
    accessDate        : String(10);
    submitDate        : String(10);
    status            : StatusQuestion;
    fincalScore       : Integer;
    responseItems     : Composition of many ResponseItems
                            on responseItems.parent = $self;
    pqQuestionnaire   : Association to PQQuestionnaires;
    attachmentFolder  : Composition of one cmisFolder
                            on $self = attachmentFolder.parent;
}

entity ResponseItems : cuid, managed {
    parent                : Association to Responses;
    responseNo            : String(20);
    reponseLineNo         : String(20);
    questionnaireLineNo   : String(20);
    question              : String;
    qType                 : String;
    clasification         : String;
    response              : String;
    weightage             : Decimal(5, 2);
    upWeightage           : Integer;
    ratingOrGrading       : Decimal(5, 2);
    rating                : Integer;
    remarks               : String;
    attachmentQuestionsId : String(255);
    choices               : Composition of many ResponseChoices
                                on choices.parent = $self;

}

entity ResponseChoices : cuid, {
    parent       : Association to ResponseItems;
    questionNo   : Integer;
    choiceNo     : Integer;
    choiceOption : String;
}

entity cmisFolder : cuid, managed { // LTI BU (Bukrs)
    folderName     : String(50);
    parent         : Association to Responses; // CMIS Folder Name
    documentCenter : ct.documentRespository:documentAPIID;
    createFolder   : String(36);
}
