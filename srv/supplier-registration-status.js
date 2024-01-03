module.exports = async function (srv) {

    //Admin Query : https://crossindustry-capm-vendor-buyer.cfapps.eu10.hana.ondemand.com/supplierRegistrationStatus/status

    //User Query: https://crossindustry-capm-vendor-buyer.cfapps.eu10.hana.ondemand.com/supplierRegistrationStatus/status?$filter=email  eq 'Test@test1234.com'

    // code added by shankar starts here

    const {
        statusReg
    } = cds.entities("com.ltim.vendor.buyer");

    srv.on("supplierStatus", async (req) => {
        console.log(req.data.email);
        let tx = cds.transaction(req),
            sData = await tx.run(
                SELECT.from(statusReg).where({
                    "email": req.data.email.toString().toLowerCase(),
                })
            );
        console.log("<======supplierStatus=======> sData" + JSON.stringify(sData));
        return sData;
    });

    srv.on("businessPartnerNumber", async (req) => {
        let tx = cds.transaction(req);

        let oData = await tx.run(
            UPDATE(statusReg)
                .set({
                    "BusinessPartner": req.data.BusinessPartner
                })
                .where({
                    "email": req.data.email.toString().toLowerCase
                })
        );
        console.log("<========== Business Partner ==========>" + JSON.stringify(oData));
    });


}