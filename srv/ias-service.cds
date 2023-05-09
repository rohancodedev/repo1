@protocol: 'rest'
@path    : 'iasRestService'
service iasService @(impl: './ias-service.js') {
    @open
    type object {};

    action   createIASUser(input : object) returns object;
}
