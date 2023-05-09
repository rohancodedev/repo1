using {com.ltim.vendor.buyer as vb} from '../db/vendorBuyer-model';

@protocol: 'rest'
@path    : 'vendorBuyerRestService'

service vendorBuyerService @(impl: './vendorBuyer-service.js') {

    entity approversList     as projection on vb.approversList;
    entity generalDetails    as projection on vb.generalDetails;
    entity companyProfile    as projection on vb.companyProfile;
    entity SupplierWorkFlow  as projection on vb.SupplierWorkFlow;
    entity loginItemCatagory as projection on vb.loginItemCatagory;
    entity userRegistration  as projection on vb.userRegistration;


    action   submitRegistration(payLoad : vb.vendorBuyerSubmit)                                                                                                                            returns String;
    function addDeleteItemsCat(supplierID : vb.generic:supplierID, email : vb.generic:email, productService : String(36), itemCat1 : String(200), itemCat2 : String(200), status : String) returns String;
    function checkSupplierStatus(email : vb.generic:email, supplierID : vb.generic:supplierID)                                                                                             returns String;
}

