namespace com.ltim.vendor.buyer;

using {
    User,
    Country,
    managed,
    cuid
} from '@sap/cds/common';

using {com.ltim.vendor.buyer as vb} from '../db/vendorBuyer-model';
using {com.ltim.vendor.buyer as cn} from '../db/candy-model';
using {com.ltim.vendor.buyer as qt} from '../db/questionnaire-model';
using {com.ltim.vendor.buyer as ct} from '../db/approverTable-model';


type SupplierInfo {
    email           : String(241);
    supplierID      : String(12);
    designation     : String(75);
    fullname        : String(75);
    supplierCode    : String(12);
    countryCode     : String(3);
    countryCodeName : String(45);
    bu              : String(4);
    buName          : String(45);
    companyName     : String(150);
    fName           : String(16);
    lName           : String(16);
}

entity headerRFQ : cuid, managed {
    EDIT                     : String(1);
    company                  : String(10);
    package                  : String(10);
    rfqId                    : String(10); // RFHS Number Range
    project                  : String(20); // Project No
    projectName              : String(150); // Project Name
    companyName              : String(150);
    buyerGroup               : String(10); // Buyer Group
    buyerGroupName           : String(150); // Buyer Group Name
    subConSDate              : String(10); // Sub Contract Start Date
    subConEDate              : String(10); // Sub Contract Completed Date
    requestNo                : String(20); // Request Number
    requestDate              : String(10); // Request Date
    requestor                : vb.contactType:emailId; // Requested Email ID
    approver                 : vb.contactType:emailId; // Approver Email ID
    status                   : vb.status; // Approved = 1; Submitted = 2; Rejected = 3; Draft = 4;
    attachmentId             : rfqattachments:attachmentId; // Attachment ID 
    initiator                : String(50); // Initiator
    initiatorName            : String(120);
    rfhsInitiatorEmail       : vb.contactType:emailId;
    // Initiator Name
    instanceID               : String(36); //      WorkFlow Instance ID
    fund                     : String(10); //		Fund Code
    fundCentre               : String(16); //		Fund Centre Code
    prNumber                 : String(10); // PR Number
    rfqType                  : String(5);
    rfqDescription           : String(150);
    brand                    : String(150);
    countryofManf            : Country;
    paymentTerms             : String(10);
    paymentTermsText         : String(150);
    paymentTermsAdvIndicator : Boolean;
    Incoterms                : String(10);
    IncotermsText            : String(150);
    location                 : String(250);
    perfomanceBond           : String(10);
    Retention                : String(10);
    Warranty                 : String(10);
    maintaincePeriod         : String(10);
    insurance                : String(10);
    addInfo                  : String(500);
    quotationID              : String(36);
    supplierQuoteStatusId    : Integer;
    openRFQ                  : String(1);
    warrantyDate             : String(10);
    currencyCode             : String(5);
    exchangeRate             : Decimal(38, 6);
    contractType             : String(3);
    controlIndicator         : String(1);
    deleteFlag               : String(1);
    statusPoDoc              : String(1);
    bindingPeriod            : Date;
    otherCondReq             : String(1);
    prebidQueriesEndDate     : String(10);
    rfhsID                   : vb.headerRFHS:rfhsId;
    rfqPublishDate           : Date;
    rfhsGUID                 : String(36);
    subconPriceType          : String(5);
    subconScopeOfWork        : String(1000);
    rfhsDecsription          : String(200);
    tenderFeesAmount         : Decimal(38, 4);
    submissionDeadlineDate   : Date;
    rfqVersion               : Integer;
    emdAmount                : Decimal(38, 6);
    costCode                 : String(10);
    documentCollectionDate   : DateTime;
    siteFacilities           : String(200);
    addnotesRFQ              : String(200);
    //Subcon General Information - RFQ Details
    quotationValidity        : String(20);
    contractDuration         : String(20);
    purchGroup               : String(10);
    purchOrg                 : String(10);
    estimateAwardDate        : DateTime;
    contractDate             : DateTime;
    responseStartDate        : DateTime;
    responseEndDate          : DateTime;
    subconCommDate           : DateTime;
    subconCompletionDate     : DateTime;
    rfqTitle                 : String(200);
    rfqPreviewDate           : DateTime;
    rfqApprovedDate          : Date;
    rfqSubmittedDate         : Date;
    cbsTriggeredDate         : Date;
    //Subcon General Information - Contact Names
    cntRFQPurchGroup         : String(10);
    cntRFQName               : String(50);
    cntRFQTel                : String(30);
    cntRFQFax                : String(30);
    cntRFQCell               : String(30);
    cntRFQEmail              : String(36);
    cntTechName              : String(50);
    cntTechTel               : String(10);
    cntTechFax               : String(10);
    cntTechCell              : String(10);
    cntTechEmail             : String(36);
    //Subcontrating additional fields Instructions
    instructionToBidders     : String(1000);
    evaluationCriterion      : String(1000);
    documentationRequired    : String(1000);
    exclusions               : String(1000);
    buyersRemarks            : String(1000);
    otherComments            : String(1000);
    buyersAssumptions        : String(1000);
    awardDecision            : String(1000);
    prHeadet                 : String(1000);
    //Subcontrating additional fields Payment Terms
    advancePayment           : cn.candyEstimation:costAmount;
    advancePaymentPercent    : Integer;
    advancePaymentPercentage : Decimal(5, 2);
    totalRFQAmount           : cn.candyEstimation:costAmount;
    downPayment              : cn.candyEstimation:costAmount;
    performanceBondVal       : cn.candyEstimation:costAmount;
    performanceBondPercent   : Decimal(5, 2);
    advanceRecovery          : Decimal(5, 2);
    finalRetention           : Decimal(5, 2);
    RetentionPercent         : Integer;
    RetentionPercentage      : Decimal(5, 2);
    paymentMethod            : String(100);
    paymentMethodKey         : String(10);
    //Subcontrating additional fields PAyment Terms Liquidation Damages
    minPenalty               : Decimal(5, 2);
    maxPenalty               : Decimal(5, 2);
    penaltyPerDay            : cn.candyEstimation:costAmount;
    //Subcontrating additional fields PAyment Terms Insurance Required
    contractorAllRisk        : Boolean;
    plantMachineryEquipment  : Boolean;
    motorVehicle             : Boolean;
    professionalIndemnity    : Boolean;
    workmensCompensation     : Boolean;
    //Subcontrating additional fields Special Terms and Conditions
    genTerms                 : String(1000);
    specialTerms             : String(1000);
    disclaimer               : String(1000);
    disclaimerAcceptance     : Boolean;
    quoteStatus              : String(36);
    quotationNumber          : String(10);
    ammendIndicator          : String(1); //R=Re tender and A=Ammendment ""=others
    WFStatus                 : vb.WorkFlowStatus;
    worflowInstanceID        : String(50);
    //Additional payment and delivery terms
    paymentTermsDetails      : String(1000);
    pricingTerms             : String(1000);
    inspectionProcess        : String(1000);
    inspectionCharges        : String(1000);
    legalizationProcess      : String(1000);
    legalizationCharges      : String(1000);
    labelingRequirement      : String(1000);
    cargoPickup              : String(1000);
    productCertification     : String(1000);
    sampleApproval           : String(1000);
    //Freight details
    consigneeName            : String(100);
    shipmentMode             : String(10);
    cargoReadinessDate       : Date;
    pol                      : String(50);
    pod                      : String(50);
    containerType            : String(10);
    containerTypeDesc        : String(32);
    containerQuantity        : Integer;
    commodityName            : String(50);
    commodityCategory        : String(50);
    splApprovalCommodity     : String(50);
    splPackingCommodity      : String(50);
    cargoPackingType         : String(10);
    cargoDimL                : Integer;
    cargoDimW                : Integer;
    cargoDimH                : Integer;
    cargoDimUnit             : String(10);
    cargoPackingQuantity     : Integer;
    cargoWeight              : Decimal(10, 3);
    cargoWeightUnit          : String(5);
    cargoCollectionAddress   : String(1000);
    cargoDeliveryAddress     : String(1000);
    hsCode                   : String(1000);
    //Delivery location contact details
    delContactName           : String(100);
    delContactTel            : String(10);
    delContactCell           : String(10);
    delContactFax            : String(10);
    delContactEmail          : String(40);
    //Shipper Contact details
    shipperContactName       : String(100);
    shipperContactTel        : String(10);
    shipperContactCell       : String(10);
    shipperContactFax        : String(10);
    shipperContactEmail      : String(40);
    rfqInactive              : String(1);
    contractTypeDescription  : String(36);
    shopDrawing              : Decimal(10, 2);
    materialDelivery         : Decimal(10, 2);
    progressivePayment       : Decimal(10, 2);
    installationPercent      : Decimal(10, 2);
    testingCommissioning     : Decimal(10, 2);
    items                    : Composition of many itemRFQ
                                   on $self = items.parent; // Associating to itemRFHS [1..N]
    noterfqitems             : Composition of many notesRFQ
                                   on $self = noterfqitems.parent;
    supplierrfqitems         : Composition of many supplierRFQ
                                   on $self = supplierrfqitems.parent;
    attachmentrfqitems       : Composition of many rfqattachments
                                   on $self = attachmentrfqitems.parent;
    questionsrfqitems        : Composition of many questionsRFQ
                                   on $self = questionsrfqitems.parent;
    quotationrfqitems        : Composition of many quotationsRFQ
                                   on $self = quotationrfqitems.parent;
    techapproversrfqitems    : Composition of many techApproversRFQ
                                   on $self = techapproversrfqitems.parent;
    logsrfqitems             : Composition of many logsRFQ
                                   on $self = logsrfqitems.parent;
    convitems                : Composition of many BuyerSupplierConversationsRFQ
                                   on $self = convitems.parent;
    attachmentFieldLevel     : Composition of one fieldLevelAttachments
                                   on $self = attachmentFieldLevel.parent;

}

entity itemRFQ : cuid, managed {
    parent             : Association to headerRFQ;
    //key CID : String(36);
    // headerRFHS ID mapping
    //estimateId: cn.candyEstimation.estimateId;                                                                      // Estimation ID UUID Key
    estimateID         : cn.candyEstimation:estimateId;
    headerEstID        : String(36); // Parent Header ID
    projectId          : cn.candyEstimation:projectId; // Project ID
    packageCode        : String(10); // Package Code
    level              : cn.candyEstimation:level; // Level
    priceCode          : cn.candyEstimation:priceCode; // Price Code
    pageItem           : cn.candyEstimation:pageItem; // BoQ No.
    billDescription    : cn.candyEstimation:billDescription; // BoQ Description
    postingQuantity    : cn.candyEstimation:finalQuantity; // BoQ Posting Quantity
    finalQuantity      : cn.candyEstimation:finalQuantity; // BoQ Final Quantity
    consumedQuantity   : cn.candyEstimation:finalQuantity; // BOQ Consumed qunatity
    menge              : cn.candyEstimation:finalQuantity;
    resAnalysisUnit    : cn.candyEstimation:resAnalysisUnit; // BoQ UoM
    netUserUnit        : cn.candyEstimation:netUserUnit; // Actual Quantity
    netAmountUnit      : cn.candyEstimation:netAmountUnit; // BoQ Unit Price of Resource
    costAmount         : cn.candyEstimation:costAmount; // BoQ Total Price of Resource
    posted             : String(1); // 'X'value is send to S4
    newEntry           : String(1); // New Entry add by User
    rootPath           : String(500); // RootPath for the LineItem in TreeView
    rejected           : String(1); // 'X' rrjected from WorkFlow
    material           : String(40); // Material
    extrow             : String(10);
    srvpos             : String(40);
    bsart              : String(6);
    materialName       : String(150); // Material Name
    materialLongName   : String(250); // Material long Name
    // costCode: String(20);                                            // Cost Code
    uom                : String(20); // Unit of Measure
    wBSElement         : String(24); // WBS Element
    wBSElementDesc     : String(150); // WBS Element Description
    costCode           : String(24);
    costCenter         : String(10);
    costCodeDesc       : String(150); // Cost Code Description
    resourceCode       : String(24); // Resource Code
    resourceCodeDesc   : String(150);
    prsmrrfhsflag      : String(5);
    prsmrrfhsid        : String(32);
    prsmrrfhsitemid    : String(32);
    itemtext           : String(200);
    startPrice         : cn.candyEstimation:netAmountUnit;
    targetPrice        : cn.candyEstimation:netAmountUnit;
    dueDate            : Date;
    attachmentid       : rfqitemattachments:attachmentId;
    plant              : String(4); // Plant (Operating Unit)
    plantName          : String(150);
    geber              : String(10);
    fistl              : String(16);
    fipos              : String(14);
    koprctr            : String(10);
    packno             : String(10);
    banfn              : String(10);
    bnfpo              : Decimal(5, 2);
    bpumz              : Decimal(5, 2);
    bpumn              : Decimal(5, 2);
    umrez              : Decimal(5, 2);
    umren              : Decimal(5, 2);
    matkl              : String(9);
    add                : String(1);
    ParentEstimateID   : String(36);
    unit               : String(20);
    itemNo             : Integer;
    excelrownumber     : Integer;
    siteName           : String(100);
    siteAddr           : String(36);
    siteAddr2          : String(36);
    siteStreet         : String(36);
    siteCity           : String(36);
    siteCountry        : String(36);
    siteAdd3           : String(36);
    siteRegion         : String(36);
    sitePostalCode     : Integer;
    siteDistrict       : String(36);
    siteBuildingCode   : String(36);
    siteRoom           : String(36);
    siteFloor          : String(36);
    siteHouseNumber    : String(36);
    siteStreet2        : String(40);
    siteStreet3        : String(40);
    siteStreet4        : String(40);
    siteStreet5        : String(40);
    itemNotes          : String(2000);
    prType             : String(1);
    ekorg              : String(10);
    ekgrp              : String(10);
    lgort              : String(4);
    afnam              : String(12);
    bednr              : String(10);
    anlni              : String(12); //Asset Code header
    company            : String(10);
    rfqType            : String(5);
    prEdit             : Boolean;
    LeanFlag           : String(1);
    brand              : String(32);
    itemRemarks        : String(1000);
    selected           : Boolean;
    allowedBsart       : String(10);
    //For PO creation
    ablad              : String(25); // Goods unloading point
    wempf              : String(12); // Goods Recipient
    prCreationDate     : DateTime;
    startDate          : DateTime; // PR Start Date
    endDate            : DateTime; // PR End Date
    prCreatedDate      : Date;
    prStartDate        : Date; // PR Start Date
    prEndDate          : Date; // PR End Date
    attachmentitems    : Composition of many rfqitemattachments
                             on $self = attachmentitems.parent;
    subconImgsAttach   : Composition of one subconQuoteImageAttachment
                             on $self = subconImgsAttach.parent;
    subconRFQImgAttach : Composition of one subconRFQImageAttachment
                             on $self = subconRFQImgAttach.parent;
}

entity rfqitemattachments : cuid, managed {
    parent       : Association to itemRFQ;
    sno          : vb.attachmentsList:sno; // Serial Number for Order
    attachmentId : vb.attachmentsList:attachmentId; // Attachment ID
    fileTitle    : vb.attachmentsList:fileTitle; // Attachment File Title
    fileName     : vb.attachmentsList:fileName; // Uploaded File Name
    fileURL      : vb.attachmentsList:fileURL; // Attachment File URL
    status       : vb.attachmentsList:status default 'None'; // Delete Status: If 'None' file is not Uploaded.
    type         : vb.attachmentsList:type; // Attachment Document Type File or Link.
}

entity subconQuoteImageAttachment : cuid, managed {
    parent      : Association to itemRFQ;
    fileContent : LargeString;
}

entity subconRFQImageAttachment : cuid, managed {
    parent      : Association to itemRFQ;
    fileContent : LargeString;
}

entity notesRFQ : cuid, managed {
    parent        : Association to headerRFQ;
    rfqId         : String(10); // RFHS Number Range
    notes         : String(1000); // Notes
    level         : Integer;
    actionDetails : String(50);
    Rule          : String(20);
    Status        : vb.WorkFlowStatus;
    actionDate    : Date; //Date on Which it is Approved /Rejected/ Created
    actionTime    : Time;
    DocumentId    : String(36);
}

entity supplierRFQ : cuid, managed {
    parent                : Association to headerRFQ;
    rfqId                 : String(10); // RFHS Number Range
    supplierId            : String(10); // Request Date
    tenderFeesStatus      : String(1); // Associating to itemRFHS [1..N]
    prefferredFlag        : String(1);
    quotationID           : String(36);
    supplierName          : String(36);
    contactPerson         : String(36);
    contactTelephone      : String(36);
    surrogateId           : String(1);
    dateLAstSubmitted     : String(10);
    poNumber              : String(10);
    podate                : String(10);
    buName                : String(50);
    companyName           : String(50);
    supplierCode          : String(10);
    country               : String(5);
    countryName           : String(50);
    quotationNumber       : String(10);
    supplierQuoteStatus   : String(36);
    contactEmail          : vb.contactType:emailId;
    contactEmailSecondary : vb.contactType:emailId;
    supplierQuoteStatusId : Integer;
    contacts              : Composition of many supplierContracts
                                on $self = contacts.parent;
}

entity supplierContracts : cuid, managed {
    parent        : Association to supplierRFQ;
    contactPerson : String(36);
    supplierId    : String(10);
    contactEmail  : vb.contactType:emailId;
}

entity rfqattachments : cuid, managed {
    parent       : Association to headerRFQ;
    rfqId        : String(10);
    sno          : vb.attachmentsList:sno; // Serial Number for Order
    attachmentId : vb.attachmentsList:attachmentId; // Attachment ID
    fileTitle    : vb.attachmentsList:fileTitle; // Attachment File Title
    fileName     : vb.attachmentsList:fileName; // Uploaded File Name
    fileURL      : vb.attachmentsList:fileURL; // Attachment File URL
    status       : vb.attachmentsList:status default 'None'; // Delete Status: If 'None' file is not Uploaded.
    type         : vb.attachmentsList:type; // Attachment Document Type File or Link.
}

entity questionsRFQ : cuid, managed {
    parent              : Association to headerRFQ;
    rfqId               : String(10); // RFQ Number
    questionNumber      : Integer;
    clasification       : String(50);
    qType               : String(36);
    question            : String(500);
    response            : String(500);
    responseType        : qt.ResponseType;
    attachmentRequired  : Boolean;
    classifiDescription : String(100);
    qTypeDescription    : String(100);
    remarks             : Boolean;
    respNumorChar       : String(10);
    isNumeric           : Boolean;
    rating              : Integer;
    weightage           : Integer;
    rfqGUID             : String(36);
    choices             : Composition of many MultipleChoicesRFQ
                              on choices.parent = $self;
}

entity MultipleChoicesRFQ : cuid, managed {
    parent       : Association to questionsRFQ;
    questionNo   : Integer;
    choiceNo     : Integer;
    choiceOption : String;
}

entity quotationsRFQ : cuid, managed {
    parent                : Association to headerRFQ;
    rfqId                 : String(10); // RFHS Number Range
    supplierId            : String(10);
    supplierName          : String(50);
    quotationID           : String(36);
    quotationNumber       : String(10);
    supplierQuoteStatus   : String(36);
    supplierQuoteStatusId : Integer;
    quotationDate         : Date;
    prefferredFlag        : String(1);
    quotationDescription  : String(100);
    surrogateId           : String(1);
    supplierCode          : String(10);
    compliantAlternateId  : String(1);

}

entity techApproversRFQ : cuid, managed {
    parent           : Association to headerRFQ;
    personIdExternal : String(32);
    firstName        : String(128);
    formalName       : String(128);
    lastName         : String(128);
    middleName       : String(128);
    jobCode          : String(32);
    jobTitle         : String(1000);
    email            : String(128);
    company          : String(32);
}

entity logsRFQ : cuid, managed {
    parent        : Association to headerRFQ;
    sno           : Integer;
    remarks       : String(500);
    actiondetails : String(50);
}

entity BuyerSupplierConversationsRFQ : cuid, managed {
    parent                : Association to headerRFQ;
    queryOrResponse       : String;
    conversationNo        : String(10);
    version               : Integer;
    appType               : String(20);
    icon                  : String(50);
    color                 : String(50);
    attachment            : Association to ConversationAttachmentsRFQ;
    participantFirstName  : String;
    participantLastName   : String;
    participantFullName   : String;
    participantRole       : String;
    attachmentMessengerId : String(255);
    attachmentFolder      : Composition of one cmisMessengerFolderRFQ
                                on $self = attachmentFolder.parent;
    toSuppliers           : Composition of many ToSuppliersRFQ
                                on $self = toSuppliers.parent;
}

entity ConversationAttachmentsRFQ : cuid, managed {
    parent         : Association to BuyerSupplierConversationsRFQ;
    conversationNo : String(10);
    sno            : vb.attachmentsList:sno; // Serial Number for Order
    attachmentId   : vb.attachmentsList:attachmentId; // Attachment ID
    fileTitle      : vb.attachmentsList:fileTitle; // Attachment File Title
    fileName       : vb.attachmentsList:fileName; // Uploaded File Name
    fileURL        : vb.attachmentsList:fileURL; // Attachment File URL
    status         : vb.attachmentsList:status default 'None'; // Delete Status: If 'None' file is not Uploaded.
    type           : vb.attachmentsList:type; // Attachment Document Type File or Link.
}

entity cmisMessengerFolderRFQ : cuid, managed { // LTI BU (Bukrs)
    folderName     : String(50);
    parent         : Association to BuyerSupplierConversationsRFQ; // CMIS Folder Name
    documentCenter : ct.documentRespository:documentAPIID;
    createFolder   : String(36);
}

entity ToSuppliersRFQ : cuid, managed {
    supplierCode      : String(12);
    supplierID        : String(12);
    email             : String(60);
    supplierFirstName : String;
    suppliertLastName : String;
    supplierFullName  : String;
    parent            : Association to BuyerSupplierConversationsRFQ;
}

entity fieldLevelAttachments : cuid, managed {
    parent                : Association to headerRFQ;
    instructionToBidders  : String(255);
    evaluationCriterion   : String(255);
    documentationRequired : String(255);
    exclusions            : String(255);
    prHeadet              : String(255);
    buyersRemarks         : String(255);
    awardDecision         : String(255);
    otherComments         : String(255);
    buyersAssumptions     : String(255);
    genTerms              : String(255);
    specialTerms          : String(255);
    disclaimer            : String(255);
    paymentTermsDetails   : String(255);
    pricingTerms          : String(255);
    inspectionProcess     : String(255);
    inspectionCharges     : String(255);
    legalizationProcess   : String(255);
    legalizationCharges   : String(255);
    labelingRequirement   : String(255);
    cargoPickup           : String(255);
    productCertification  : String(255);
    sampleApproval        : String(255);
    subconScopeOfWork     : String(255);
}
