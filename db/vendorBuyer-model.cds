namespace com.ltim.vendor.buyer;

using {
    managed,
    cuid
} from '@sap/cds/common';
using {com.ltim.vendor.buyer as ct} from '../db/approverTable-model';


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
    date            : String(10);
    attachment      : String(500);
    currency        : String(3);
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
    key version              : Integer default 0;
        s4Version            : Integer default 0;
        email                : generic:email;
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
        businessType         : String(50);
        lineOfBusiness       : generic:lineofBusiness;
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
}

entity companyProfile : cuid, managed {
    key version                      : Integer default 0;
        s4Version                    : Integer default 0;
        email                        : generic:email;
        supplierID                   : generic:supplierID;
        bu                           : generic:bu;
        tradeLicNumber               : String(20);
        tradeIssueDate               : generic:date;
        tradeExpiryDate              : generic:date;
        tradeIssuingAuthority        : String(150);
        tradeIssuingCountry          : generic:country;
        tradeAttachment              : generic:attachment;
        commercialLicNumber          : String(20);
        commercialIssueDate          : generic:date;
        commercialExpiryDate         : generic:date;
        commercialIssuingAuthority   : String(150);
        commercialIssuingCountry     : String(150);
        commercialAttachment         : generic:attachment;
        taxtype                      : String(25);
        taxnumber                    : String(25);
        taxIssueDate                 : generic:date;
        taxExpiryDate                : generic:date;
        taxIssuingAuthority          : String(150);
        taxIssuingCountry            : String(150);
        taxAttachment                : generic:attachment;
        computerCardnumber           : String(25);
        computerCardIssueDate        : generic:date;
        computerCardExpiryDate       : generic:date;
        computerCardIssuingAuthority : String(150);
        computerCardIssuingCountry   : String(150);
        computerCardAttachment       : generic:attachment;
        companyProfileAttachment     : generic:attachment;
        organizationAttachment       : generic:attachment;
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
