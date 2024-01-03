using { com.ltim.vendor.buyer as configure } from '../db/approverTable-model';
@protocol: 'rest'
@path    : 'approverTableRestService'

service approverTableService @(impl: './approverTable-service.js') {

    entity approverTable as projection on configure.approverTable;
    entity typeTableApprove as projection on configure.typeTableApprover;
    entity actorTypeApprover as projection on configure.actorTypeApprover;
    entity documentRespository as projection on configure.documentRespository;
    
}

