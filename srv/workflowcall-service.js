const workFlow = require("./workFlow");

module.exports = async function (srv) {

    srv.on("submitWorkflow", async (req) => {
        var rData = req.data["wfInputData"],
            oWorkFlow = new workFlow();

        return await oWorkFlow.startWorkflow(rData);
    });
};
