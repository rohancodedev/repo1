using com.ltim.vendor.buyer as general from '../db/general-model';

@protocol: 'rest'
@path    : 'generalRestService'

service generalService @(impl: './general-service.js') {

    entity region         as projection on general.region;

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
        order by fieldValue2 asc;

    entity country        as
        select from general.country {
            country,
            name,
            tele
        }
        order by name asc

}
