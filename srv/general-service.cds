using com.ltim.vendor.buyer as general from '../db/general-model';

@protocol: 'rest'
@path    : 'generalRestService'

service generalService @(impl: './general-service.js') {

    entity region         as projection on general.region;
    entity configDataList as projection on general.configDataList;

    entity country        as
        select from general.country{
            country,
            name,
            tele
        } order by name asc

}
