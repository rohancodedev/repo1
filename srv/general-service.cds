using com.ltim.vendor.buyer as general from '../db/general-model';

@protocol: 'rest'
@path    : 'generalRestService'

service generalService @(impl: './general-service.js') {

    entity country           as projection on general.country;
    entity region            as projection on general.region;
    entity configDataList    as projection on general.configDataList;
}
