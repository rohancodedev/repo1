namespace com.ltim.vendor.buyer;

using {
    managed,
    cuid
} from '@sap/cds/common';
using {com.ltim.vendor.buyer as ct} from '../db/approverTable-model';
using {com.ltim.vendor.buyer as cn} from '../db/candy-model';



// added by shankar on 28/07/23 to access it in manageRFQ cds
type contactType {
    mobileNo    : String(36);
    emailId     : String(60);
    faxNo       : String(36);
    webSite     : String(120);
    officeNoExt : String(36);
    officeNo    : String(36);
}


type generic           : {
    email           : String(241);
    supplierID      : String(12);
    fName           : String(50);
    lName           : String(50);
    supplierCode    : String(12);
    countryCode     : String(3);
    countryCodeName : String(45);
    bu              : String(4);
    buName          : String(45);
    companyName     : String(150);
    telCode         : String(6);
    telNumber       : String(20);
    website         : String(500);
    yesno           : String(4);
    country         : String(80);
    pincode         : String(10);
    cityTown        : String(80);
    regionState     : String(80);
    address         : String(200);
    date            : String(12);
    attachment      : String(500);
    currency        : String(6);
    lineofBusiness  : String(150);
    version         : Integer;
    years           : String(4);
    brief           : String(500);
}

type vendorBuyerSubmit : {
    companyName              : String(150);
    commercialLicNumber      : String(20);
    country                  : String(3);
    countryName              : String(45);
    fName                    : String(50);
    lname                    : String(50);
    companyTelNoCode         : String(6);
    companyTelNoNumber       : String(20);
    email                    : String(241);
    website                  : String(500);
    productService           : String(150);
    lineBusiness             : String(150);
    lineBusiness02           : String(150);
    lineBusinessID           : String(150);
    remarks                  : String(500);
    attachments              : String(500);
    dmsRepositoryName        : String(150);
    dmsRepositoryId          : String(150);
    dmsRepositoryDescription : String(150);
    dmsObjectID              : String(150);
    dmsFileName              : String(150);
    itemCatagory             : many {
        itemCatagory01       : String(150);
        itemCatagory02       : String(150);
    };
}

type WorkFlowStatus    : String(1) enum {
    Waiting   = 'X';
    Completed = 'Y';
    Rejected  = 'Z';
    Cancelled = 'V'
}

// added by shankar on 31/07/23
type status : Integer enum {
    Approved  = 1;
    Submitted = 2;
    Rejected  = 3;
    Draft     = 4;
    Change    = 5; // Change
    Cancelled = 6; //Cancelled Rfhs
}

entity userRegistration : cuid, managed {
    email        : String(241);
    supplierID   : String(12);
    fName        : String(50);
    lname        : String(50);
    bu           : String(4);
    buName       : String(45);
    companyName  : String(150);
    ipAddress    : String(250);
    active       : String(1) default '';
    status       : String(1) default 'X';
    rStatus      : String(1) default 'X';
    fStatus      : String(1) default '';
    dStatus      : String(1) default '';
    supplierCode : String(12);
    sDate        : String(10);
    mDate        : String(10);
    eDate        : String(10);
    mStatus      : String(1) default 'X';
    wStatus      : WorkFlowStatus;
    rWFID        : String(36);
    sWFID        : String(36);
    rLevel       : String(1);
    remarks      : String(500);
    attachments  : String(500);
}


entity loginItemCatagory : cuid, managed {
    key version        : Integer default 0;
        s4Version      : Integer default 0;
        email          : generic:email;
        supplierID     : generic:supplierID;
        productService : String(36);
        itemCatagory01 : String(200);
        itemCatagory02 : String(200);
        deleteFlag     : Boolean default false;
}
// new code added by shankar starts here after call

entity SupplierWorkFlow : managed {
    wFID         : String(36);
    supplierID   : generic:supplierID;
    bu           : generic:bu;
    Level        : Integer;
    Status       : WorkFlowStatus;
    EmailID      : generic:email;
    Rule         : String(225);
    Remarks      : String(255);
    parentWFID   : String(36);
    workFlowType : String(36);
}

entity generalDetails : cuid, managed {
    key email                : generic:email;
        supplierID           : generic:supplierID;
        bu                   : generic:bu;
        floor                : String(50);
        companyName          : String(150);
        buildingNumber       : String(20);
        buildingName         : String(150);
        streetNo             : String(50);
        streetName           : String(200);
        nearestLandMark      : String(200);
        officeNo             : String(50);
        poBoxNo              : String(20);
        postOfficeAreaName   : String(20);
        cityTown             : generic:cityTown;
        country              : generic:country;
        countryName          : generic:countryCodeName;
        regionCode           : String(10);
        region               : String(80);
        pincode              : generic:pincode;
        companyTelNoCode     : generic:telCode;
        companyTelNoNumber   : generic:telNumber;
        companyEmailID       : generic:email;
        website              : generic:website;
        faxCode              : generic:telCode;
        faxNumber            : generic:telNumber;
        cellCode             : generic:telCode;
        cellNumber           : generic:telNumber;
        dunsNumber           : String(11);
        legalStructure       : String(50);
        legalStructureKey    : String(50);
        businessType         : String(50);
        lineOfBusiness       : generic:lineofBusiness;
        lineOfBusinessKey    : String(50);
        otherLineOfBusiness  : generic:lineofBusiness;
        establishmentYear    : generic:years;
        yearInBusiness       : String(15);
        csiCategory          : String(75);
        companyOverView      : generic:brief;
        visionStatement      : generic:brief;
        natureOfBusiness     : generic:brief;
        considerOrganization : generic:brief;
        organizationMission  : generic:brief;
        organizationChart    : generic:attachment;
        companyProfile       : generic:attachment;
        permanentEmployees   : String(15);
        specify              : generic:yesno;
        remarks              : generic:brief;
        attachments          : generic:attachment;
        saveAsDraftStatus    : Boolean default false; // true means draft mode and false means not in draft mode
}

entity companyProfile : cuid, managed {
    key email                        : generic:email;
        supplierID                   : generic:supplierID;
        bu                           : generic:bu;
        tradeLicNumber               : String(20);
        tradeIssueDate               : generic:date;
        tradeExpiryDate              : generic:date;
        tradeIssuingAuthority        : String(150);
        tradeIssuingCountry          : generic:country;
        tradeIssuingCountryKey       : generic:countryCodeName;
        tradeAttachment              : generic:attachment;
        commercialLicNumber          : String(20);
        commercialIssueDate          : generic:date;
        commercialExpiryDate         : generic:date;
        commercialIssuingAuthority   : String(150);
        commercialIssuingCountry     : String(150);
        commercialIssuingCountryKey  : generic:countryCodeName;
        commercialAttachment         : generic:attachment;
        taxtypeCode                  : String(10);
        taxtype                      : String(250);
        taxnumber                    : String(25);
        taxIssueDate                 : generic:date;
        taxExpiryDate                : generic:date;
        taxIssuingAuthority          : String(150);
        taxIssuingCountry            : String(150);
        taxIssuingCountryKey         : generic:countryCodeName;
        taxAttachment                : generic:attachment;
        computerCardnumber           : String(25);
        computerCardIssueDate        : generic:date;
        computerCardExpiryDate       : generic:date;
        computerCardIssuingAuthority : String(150);
        computerCardIssuingCountry   : String(150);
        computerCardAttachment       : generic:attachment;
        companyProfileAttachment     : generic:attachment;
        organizationAttachment       : generic:attachment;
        saveAsDraftStatus            : Boolean default false; // true means draft mode and false means not in draft mode
}

entity supplierItemCatagory : cuid, managed {
    key version        : Integer default 0;
        s4Version      : Integer default 0;
        itemID         : String(36);
        email          : generic:email;
        supplierID     : generic:supplierID;
        productService : String(36);
        itemCatagory01 : String(200);
        itemCatagory02 : String(200);
        deleteFlag     : Boolean default false;
}

entity foreignDetails : managed {
    key email                 : generic:email;
        supplierID            : generic:supplierID;
        bu                    : generic:bu;
        hasBranch             : generic:yesno;
        hasBranchCode         : String(10);
        hasBranchName         : generic:brief;
        hasGroup              : generic:yesno;
        hasGroupCode          : String(10);
        foreignGroupName      : String(50);
        foreignAddressLine1   : generic:address;
        foreignAddressLine2   : generic:address;
        foreignCityTown       : generic:cityTown;
        foreignRegionState    : generic:regionState;
        foreignRegionStateKey : String(5);
        foreignCountry        : generic:country;
        foreignCountryKey     : String(5);
        foreignPinCode        : generic:pincode;
        foreignFaxCode        : generic:telCode;
        foreignFaxNumber      : generic:telNumber;
        foreignTeleCode       : generic:telCode;
        foreignTeleNumber     : generic:telNumber;
        foreignWebSite        : generic:website;
        saveAsDraftStatus     : Boolean default false; // true means draft mode and false means not in draft mode
}

entity financialDetails : managed {
    key email                        : generic:email;
        supplierID                   : generic:supplierID;
        bu                           : generic:bu;
        hasFinancialStatement        : generic:yesno;
        hasFinancialStatementKey     : String(10);
        financialStatementAttachment : generic:attachment;
        financialTurnover1           : String(20);
        financialTurnover1Curr       : String(20);
        financialTurnover1CurrKey    : String(20);
        financialTurnover2           : generic:country;
        financialTurnover2Curr       : String(20);
        financialTurnover2CurrKey    : String(20);
        financialTurnover3           : generic:country;
        financialTurnover3Curr       : String(20);
        financialTurnover3CurrKey    : String(20);
        defaultOrderCurreny          : generic:currency;
        defaultOrderCurrenyKey       : String(20);
        bankCompanyAuditor           : generic:attachment;
        hasAgainstYour               : generic:yesno;
        hasAgainstYourKey            : String(10);
        aCompanyLocal                : generic:brief;
        aIndividualLocal             : generic:brief;
        aBankLocal                   : generic:brief;
        aCompanyForeign              : generic:brief;
        aIndividualForeign           : generic:brief;
        aBankForeign                 : generic:brief;
        hasAgainstOther              : generic:yesno;
        hasAgainstOtherKey           : String(10);
        yCompanyLocal                : generic:brief;
        yIndividualLocal             : generic:brief;
        yBankLocal                   : generic:brief;
        yCompanyForeign              : generic:brief;
        yIndividualForeign           : generic:brief;
        yBankForeign                 : generic:brief;
        saveAsDraftStatus            : Boolean default false; // true means draft mode and false means not in draft mode
}

entity bankDetails : managed {
    key bankbrachnumber          : String(150);
        email                    : generic:email;
        supplierID               : generic:supplierID;
        bu                       : generic:bu;
        sno                      : String(4);
        bankCountry              : generic:country;
        accountForignPaymentBank : String(1);
        bankname                 : String(150);
        banknumber               : String(150);
        bankCode                 : String(150);
        bankIBANIFSC             : String(150);
        bankCurrency             : generic:currency;
        bankIBANCertification    : String(150);
        bankbranch               : String(150);
        bankBranchType           : String(150);
        bankBIC                  : String(150);
        bankAccountNumber        : String(150);
        bankAccountName          : String(150);
        bankControlKey           : String(2);
        bankNew                  : String(1) default 'X';
        status                   : String(1) default 'X';
        posted                   : String(1) default '';
        saveAsDraftStatus        : Boolean default false; // true means draft mode and false means not in draft mode

}

entity businessPartner : managed {
    key email                        : generic:email;
        supplierID                   : generic:supplierID;
        bu                           : generic:bu;
        supplierDocument             : generic:attachment;
        client1companyName           : generic:companyName;
        client1valueBusiness         : String(17);
        client1valueBusinessCur      : generic:currency;
        client1ValueBusinessCurrCode : String(5);
        client1designation           : String(50);
        client1telNoCode             : generic:telCode;
        client1telNoNumber           : generic:telNumber;
        client1email                 : generic:email;
        client1rational              : generic:brief;
        client1types                 : generic:brief;
        client2companyName           : generic:companyName;
        client2valueBusiness         : String(17);
        client2valueBusinessCur      : generic:currency;
        client2ValueBusinessCurrCode : String(5);
        client2designation           : String(50);
        client2telNoCode             : generic:telCode;
        client2telNoNumber           : generic:telNumber;
        client2email                 : generic:email;
        client2rational              : generic:brief;
        client2types                 : generic:brief;
        client3companyName           : generic:companyName;
        client3valueBusiness         : String(17);
        client3valueBusinessCur      : generic:currency;
        client3ValueBusinessCurrCode : String(5);
        client3designation           : String(50);
        client3telNoCode             : generic:telCode;
        client3telNoNumber           : generic:telNumber;
        client3email                 : generic:email;
        client3rational              : generic:brief;
        client3types                 : generic:brief;
        saveAsDraftStatus            : Boolean default false; // true means draft mode and false means not in draft mode

}

entity communication : managed {
    key emailC            : generic:email;
        email             : generic:email;
        supplierID        : generic:supplierID;
        bu                : generic:bu default '';
        buName            : generic:buName default '';
        type              : String(50);
        name              : String(75) default '';
        designation       : String(75) default '';
        department        : String(75) default '';
        telNoCode         : generic:telCode default '';
        telNo             : generic:telNumber default '';
        faxNoCode         : generic:telCode default '';
        faxNo             : generic:telNumber default '';
        extension         : String(10) default '';
        mobileNoCode      : generic:telCode default '';
        mobileNo          : generic:telNumber default '';
        website           : generic:website default '';
        saveAsDraftStatus : Boolean default false; // true means draft mode and false means not in draft mode
}

entity supplierChain : managed {
    key email                    : generic:email;
        supplierID               : generic:supplierID;
        bu                       : generic:bu;
        productService           : String(150);
        productCatalogAttachment : generic:attachment;
        lineBusiness             : generic:lineofBusiness;
        lineBusinessKey          : String(50);
        lineBusiness02           : generic:lineofBusiness;
        lineBusinessID           : generic:lineofBusiness;
        otherlineBusiness        : generic:lineofBusiness;
        r1Type                   : String(50);
        r1Percentage             : String(5);
        r1Share                  : String(5);
        r2Type                   : String(50);
        r2Percentage             : String(5);
        r2Share                  : String(5);
        r3Type                   : String(50);
        r3Percentage             : String(5);
        r3Share                  : String(5);
        supplyingCountry         : String(500);
        exportingCountry         : String(500);
        manufucatureFlag         : String(1);
        manufucatureBands        : String(250);
        distributorFlag          : String(1);
        distributorBands         : String(250);
        distributorNonFlag       : String(1);
        distributorNonBands      : String(250);
        productionFacilityFlag   : String(1);
        facilityArea             : String(10);
        productionProducre       : generic:brief;
        productionType           : generic:brief;
        productionStaff          : String(50);
        productionCapacity       : generic:brief;
        provideFacility          : generic:brief;
        parmanentEmployee        : String(5);
        saveAsDraftStatus        : Boolean default false; // true means draft mode and false means not in draft mode
}

entity warehouseList : cuid, managed {
    email             : generic:email; 
    supplierID        : generic:supplierID; 
    warehouseType     : String(50); 
    numberOfWarehouse : String(10);  
    areaOfWarehouse   : String(10); 
    address           : generic:brief;
}

entity fleetList : cuid, managed {
    email        : generic:email; 
    supplierID   : generic:supplierID; 
    bu           : generic:bu; 
    action       : String(50); 
    fleetType    : String(50); 
    vehicleType  : String(10); 
    noOfVehicles : String(10);
}

entity certification : managed {
    key certificationNumber     : String(150);
        email                   : generic:email;
        supplierID              : generic:supplierID;
        bu                      : generic:bu;
        types                   : String(50);
        certification           : String(150);
        otherCertification      : String(150);
        nameCertificationBody   : String(150);
        dateCertified           : String(12);
        expiratedDate           : String(12);
        certificationAttachment : generic:attachment;
        govCertification        : String(150);
        govBreifProduct         : generic:brief;
        saveAsDraftStatus       : Boolean default false; // true means draft mode and false means not in draft mode
}


define view approversList as
    select from ct.typeTableApprover as t1
    inner join ct.approverTable as t2
        on  t1.typeId     = t2.typeId
        and t2.deleteFlag = false
    inner join ct.actorTypeApprover as t3
        on t2.actorTypeId = t3.actorTypeId
    {
        key t1.appType,
            t2.companyCode,
            t2.level   as Level,
            t2.emailId as Id,
            t2.fullName,
            t3.actorType,
            t3.actorTypeDescription
    }
    order by
        Level asc;

// Entity - [RFHS] **********************************
// Header RFHS

type attachmentsList  {
    ID           : String(36); // Row ID
    sno          : Integer; // Sno#
    attachmentId : String(64); // Attachment ID
    fileTitle    : String(100); // Attachment File Title
    fileName     : String(100); // Uploaded File Name
    fileURL      : String(255); // Attachment File URL
    status       : String(10); // Delete Status: If 'None' file is not Uploaded.
    type         : String(4); // Attachment Document Type File or Link.
}

entity attachments : cuid, managed {
    sno          : attachmentsList:sno; // Serial Number for Order
    attachmentId : attachmentsList:attachmentId; // Attachment ID
    fileTitle    : attachmentsList:fileTitle; // Attachment File Title
    fileName     : attachmentsList:fileName; // Uploaded File Name
    fileURL      : attachmentsList:fileURL; // Attachment File URL
    status       : attachmentsList:status default 'None'; // Delete Status: If 'None' file is not Uploaded.
    type         : attachmentsList:type; // Attachment Document Type File or Link.
}

entity headerRFHS : cuid, managed {
    rfhsId           : String(10); // RFHS Number Range
    plant            : String(4); // Plant (Operating Unit)
    plantName        : String(150); // Plant Name (Operating Unit Name)
    project          : String(20); // Project No
    projectName      : String(150); // Project Name
    wBSElement       : String(24); // WBS Element
    wBSElementDesc   : String(150); // WBS Element Description
    packageCode      : String(10); // Package Code
    costCode         : String(24); // Cost Code
    costCodeDesc     : String(150); // Cost Code Description
    resourceCode     : String(24); // Resource Code
    resourceCodeDesc : String(150); // Resource Code Description
    buyerGroup       : String(10); // Buyer Group
    buyerGroupName   : String(150); // Buyer Group Name
    subConSDate      : String(10); // Sub Contract Start Date
    subConEDate      : String(10); // Sub Contract Completed Date
    requestNo        : String(20); // Request Number
    requestDate      : String(10); // Request Date
    requestor        : contactType:emailId; // Requested Email ID
    approver         : contactType:emailId; // Approver Email ID
    status           : status; // Approved = 1; Submitted = 2; Rejected = 3; Draft = 4;
    attachmentId     : attachments:attachmentId; // Attachment ID // 
    initiator        : String(20); // Initiator
    initiatorName    : String(120); // Initiator Name
    instanceID       : String(36); //	WorkFlow Instance ID
    fund             : String(10); // Fund Code
    fundCentre       : String(16); // Fund Centre Code
    prNumber         : String(10); // PR Number
    Burks            : String(4); //  Company Code
    BukrsName        : String(25); //  Company Code Name
    scope            : String(500); // Scope of Work
    version          : Integer;
    items            : Composition of many itemRFHS
                           on $self = items.parent; // Associating to itemRFHS [1..N]
}

entity itemRFHS : cuid, managed {
    parent                  : Association to headerRFHS; // headerRFHS ID mapping
    estimateId              : cn.candyEstimation:estimateId; // Estimation ID UUID Key
    headerEstID             : String(36); // Parent Header ID
    projectId               : cn.candyEstimation:projectId; // Project ID
    packageCode             : String(10); // Package Code
    level                   : cn.candyEstimation:level; // Level
    priceCode               : cn.candyEstimation:priceCode; // Price Code
    pageItem                : cn.candyEstimation:pageItem; // BoQ No.
    billDescription         : cn.candyEstimation:billDescription; // BoQ Description
    postingQuantity         : cn.candyEstimation:finalQuantity; // BoQ Posting Quantity
    finalQuantity           : cn.candyEstimation:finalQuantity; // BoQ Final Quantity
    resAnalysisUnit         : cn.candyEstimation:resAnalysisUnit; // BoQ UoM
    netUserUnit             : cn.candyEstimation:netUserUnit; // Actual Quantity
    netAmountUnit           : cn.candyEstimation:netAmountUnit; // BoQ Unit Price of Resource
    costAmount              : cn.candyEstimation:costAmount; // BoQ Total Price of Resource
    posted                  : String(1); // 'X'value is send to S4
    newEntry                : String(1); // New Entry add by User
    rootPath                : String(500); // RootPath for the LineItem in TreeView
    rejected                : String(1); // 'X' rrjected from WorkFlow
    orderofselectedlineitem : Integer; //added on 21-12 for pr line item sequence
// material: String(40);				// Material
// materialName: String(150);			// Material Name
// costCode: String(20);				// Cost Code
// uom: String(3);						// Unit of Measure
// quantity: Decimal(18,2);				// Quantity
// resourceCode: String(10);			// Resource Code
}
