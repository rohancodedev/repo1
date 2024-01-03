const workFlow = require("./workFlow");

module.exports = async function (srv) {

    const {
        status
      } = cds.entities("com.ltim.vendor.buyer");

    srv.on("submitWorkflow", async (req) => {
        var rData = req.data["wfInputData"],
            tx = cds.transaction(req),
            oWorkFlow = new workFlow();
        console.log("<======> RData <=======>" + rData);

        let oWorkflowStatus = await oWorkFlow.startWorkflow(rData);
        console.log("<========== Submit Approval ==========>  Workflow Instance Creation Completed    " + JSON.stringify(oWorkflowStatus));

        if (oWorkflowStatus.message.status === "RUNNING") {
           await tx.run(UPDATE(status).set({
            "questionnaireStatus": "Completed",
            "questionnaireApprovalStatus": "Awaiting for Approval"
           }).
           where({
            "email": rData.context.workflowData.GeneralDetails.companyEmailID.toString().toLowerCase()
           })) 
        }
        
    });
};
