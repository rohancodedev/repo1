using {com.ltim.vendor.buyer as cn} from '../db/candy-model';

@protocol: 'rest'
@path    : 'candyRestService'

service candyService @(impl: './candy-service.js') {

    entity candyEstimation as projection on cn.candyEstimation;
}
