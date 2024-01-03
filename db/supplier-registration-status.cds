namespace com.ltim.vendor.buyer;

entity statusReg {
    key email                       : String(241);
        supplierID                  : String(12);
        regStatus                   : String(25);
        questionnaireStatus         : String(25);
        questionnaireApprovalStatus : String(25);
        BusinessPartner             : String(15);
}
