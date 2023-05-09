namespace com.ltim.vendor.buyer;

using {
    managed,
    cuid
} from '@sap/cds/common';

entity typeTableApprover : managed {
    key typeId             : Integer;
        appType            : String(500);
        appTypeDescription : String(500);
        oData			   : String(200);
        entityName  	   : String(200);
        system  		   : String(10);
        attribute1  	   : String(200);
        attribute2  	   : String(200);
        attribute3  	   : String(200);
        attribute4  	   : String(200);
        attribute5  	   : String(200);
        company  	       : String(1);
        project  	       : String(1);
        typeGroup          : String(20);
}

entity approverTable : managed {
	key UUID        : UUID;
    	typeId      : Integer;
        companyCode : String(12);
    	projectId   : String(20);
    	level       : Integer;
    	attribute1  : String(200);
    	attribute2  : String(200);
    	attribute3  : String(200);
    	attribute4  : Integer64;
    	attribute5  : Integer64;
        actorTypeId : Integer;
        emailId     : String(500); 
        fullName    : String(500);
        deleteFlag	: Boolean default false;
}

entity actorTypeApprover : managed {
    key actorTypeId          : Integer;
        actorType            : String(500);
        typeId               : Integer;
        actorTypeDescription : String(500);
}

