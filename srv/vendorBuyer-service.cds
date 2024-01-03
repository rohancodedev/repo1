using {com.ltim.vendor.buyer as vb} from '../db/vendorBuyer-model';

@protocol: 'rest'
@path    : 'vendorBuyerRestService'

service vendorBuyerService @(impl: './vendorBuyer-service.js') {

    entity approversList     as projection on vb.approversList;
    entity generalDetails    as projection on vb.generalDetails;
    entity companyProfile    as projection on vb.companyProfile;
    entity SupplierWorkFlow  as projection on vb.SupplierWorkFlow;
    entity userRegistration  as projection on vb.userRegistration;
    entity foreignDetails    as projection on vb.foreignDetails;
    entity financialDetails  as projection on vb.financialDetails;
    entity bankDetails       as projection on vb.bankDetails;
    entity businessPartner   as projection on vb.businessPartner;
    entity communication     as projection on vb.communication;
    entity supplierChain     as projection on vb.supplierChain;
    entity warehouseList     as projection on vb.warehouseList;
    entity fleetList         as projection on vb.fleetList;
    entity certification     as projection on vb.certification;
    //added by shankar on 31/07/23
    entity attachments       as projection on vb.attachments;
    entity headerRFHS        as projection on vb.headerRFHS;
    entity itemRFHS          as projection on vb.itemRFHS;

    entity loginItemCatagory as
        select from vb.loginItemCatagory {
            email,
            supplierID,
            productService,
            itemCatagory01,
            itemCatagory02,
            deleteFlag
        }
        order by
            supplierID asc;

    @open
    type object {};

    type itemCategoryArrayType : {
        bu           : String(4);
        buName       : String(45);
        companyName  : String(150);
        proccessType : String(20);
        fieldName    : String(50);
        fieldKey     : String(50);
        fieldValue   : String(150);
        fieldValue2  : String(150);
        deleteFlag   : Boolean default false;
        status       : String(1) default 'X';
    }

    type addDeleteItemCatagory : {
        supplierID        : vb.generic:supplierID;
        email             : vb.generic:email;
        productService    : String(36);
        status            : String;
        itemCatagoryArray : itemCategoryArrayType
    }

    action   submitRegistration(payLoad : vb.vendorBuyerSubmit)                                returns String;
    action   addDeleteItemsCat(itemCategoryPayload : addDeleteItemCatagory)                    returns object;
    function checkSupplierStatus(email : vb.generic:email, supplierID : vb.generic:supplierID) returns String;
    function getSaveAsDraftStatus(email : vb.generic:email, saveAsDraftStatus : Boolean)       returns String;
}
