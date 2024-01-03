namespace com.ltim.vendor.buyer;

using {
    managed,
    cuid
} from '@sap/cds/common';

entity candyEstimation : managed {
    key estimateId                 : UUID;
        IBCID                      : String(36);
        projectId                  : String(20);

        @search: {defaultSearchElement: true}
        loadedDate                 : Timestamp;
        version                    : Integer;
        // clientId						: String(20);
        level                      : String(10);
        item                       : String(20);
        pageItem                   : String(50);
        billDescription            : String(1000); //String(500);
        unit                       : String(10);
        billQuantity               : Decimal(38, 6);
        finalQuantity              : Decimal(38, 6);
        netRate                    : Decimal(38, 6);
        sellingRate                : Decimal(38, 6);
        netFinalAmount             : Decimal(38, 6);
        sellingAmount              : Decimal(38, 6);
        trade                      : String(10);
        taskCode                   : String(10);
        taskCodeDescription        : String(500);
        taskCodeUnit               : String(10);
        taskCodeFactor             : Decimal(38, 6);
        taskCodeFinalQty           : Decimal(38, 6);
        workCode                   : String(10);
        workCodeDescription        : String(500);
        userCode1                  : String(50);
        userCode2                  : String(50);
        userCode3                  : String(50);
        userCode4                  : String(50);
        userCode5                  : String(50);
        userCode6                  : String(500);
        billCode                   : String(10);
        billCodeDescription        : String(500);
        billCodeUnit               : String(10);
        billCodeFactor             : Decimal(38, 1);
        billCodeFinalQty           : Decimal(38, 1);
        packageCode                : String(10);
        priceCode                  : String(10);
        resAnalysisCostCode        : String(10);
        resAnalysisCostDescription : String(500);
        resAnalysisType            : String(10);
        resAnalysisCode            : String(20);
        resAnalysisDescription     : String(500);
        resAnalysisUnit            : String(500);
        netUserUnit                : Decimal(38, 6);
        finalRate                  : Decimal(38, 6);
        requestID                  : String(36);
        netUsage                   : Decimal(38, 6);
        netAmountUnit              : Decimal(38, 6);
        costAmount                 : Decimal(38, 6);
        final                      : Decimal(38, 6);
        resource                   : Decimal(38, 6);
        remaining                  : Decimal(38, 6);
        Excelrownumber             : Integer;
        sellingRateText            : String(100);
        sellingAmountText          : String(100);
}

