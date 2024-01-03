using com.ltim.vendor.buyer as general from '../db/general-model';

@protocol: 'rest'
@path    : 'generalRestService'

service generalService @(impl: './general-service.js') {

    entity region         as projection on general.region;
    entity questionnaireDropdown as projection on general.questionnaireDropdown;

    entity configDataList as
        select from general.configDataList {
            bu,
            buName,
            companyName,
            proccessType,
            fieldName,
            fieldKey,
            fieldValue,
            fieldValue2,
            deleteFlag,
            status
        }
        order by
            fieldValue2 asc;

    entity country        as
        select from general.country {
            country,
            name,
            tele
        }
        order by
            name asc;

    entity currency       as
        select from general.currency {
            country,
            name
        }
        order by
            name asc;

    entity tax            as
        select from general.tax {
            tax,
            name
        }
        order by
            name asc;

}
