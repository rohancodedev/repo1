using {com.ltim.vendor.buyer as suppStatus} from '../db/supplier-registration-status';

@protocol: 'rest'
@path    : 'supplierRegistrationStatus'
// @requires: 'authenticated-user' // commented by shankar due login issue.

service supplierRegistrationStatus @(impl: './supplier-registration-status.js') {
    @open
    type object {};

    entity status as projection on suppStatus.status;
    function supplierStatus(email : String(241)) returns object;

}
