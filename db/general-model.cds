namespace com.ltim.vendor.buyer;

using {
    managed,
    cuid
} from '@sap/cds/common';

entity country : managed {
    country : String(3);
    name    : String(150);
    tele    : String(5);
}

entity region : managed {
    country : String(3);
    region  : String(5);
    name    : String(150);
}

entity configDataList : managed {
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
