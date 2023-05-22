@protocol: 'rest'
@path    : 'workflowRestService'
service workflowService @(impl: './workflowcall-service.js') {
    @open
    type object {};

    action submitWorkflow(wfInputData : object) returns object;

}
