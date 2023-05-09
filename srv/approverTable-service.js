const cds = require('@sap/cds')
const { v4: uuid } = require('uuid');

module.exports = (srv) => {
    const {
        approverTable
	} = srv.entities('com.ltim.vendor.buyer')
    srv.before('CREATE', 'approverTable', async req => {

		//console.log(req.data);
		req.data.UUID = uuid();
		let tx = cds.transaction(req);
		let sQuery =
			"select * from COM_LTIM_VENDOR_BUYER_APPROVERTABLE where typeId = " + req.data.typeId +
			" and companyCode ='" + req.data.companyCode + "' and projectId ='" + req.data.projectId + "' and level =" + req.data.level +
			" and attribute1 ='" + req.data.attribute1 + "' and attribute2 ='" + req.data.attribute2 + "' and attribute3 ='" + req.data.attribute3 +
			"' and attribute4 ='" + req.data.attribute4 + "' and attribute5 ='" + req.data.attribute5 + "' and deleteFlag = False",
			query = cds.parse.cql(sQuery);
		let approverTableCount = await tx.run(sQuery);
		if (approverTableCount.length > 0) {
			req.reject(409, "Entity Already exists ");
		}
		// let tx = cds.transaction(req);

	})
    srv.before('UPDATE', 'approverTable', async req => {

		//console.log(req.data);
		// req.data.UUID = uuid();
		let tx = cds.transaction(req);
		let sQuery =
			"select * from COM_LTIM_VENDOR_BUYER_APPROVERTABLE where typeId = " + req.data.typeId +
			" and companyCode ='" + req.data.companyCode + "' and projectId ='" + req.data.projectId + "' and level =" + req.data.level +
			" and attribute1 ='" + req.data.attribute1 + "' and attribute2 ='" + req.data.attribute2 + "' and attribute3 ='" + req.data.attribute3 +
			"' and attribute4 ='" + req.data.attribute4 + "' and attribute5 ='" + req.data.attribute5 +
			"'and deleteFlag = false  and fullName ='" + req.data.fullName + "'  and emailId ='" + req.data.emailId + "'",
			query = cds.parse.cql(sQuery);
		let approverTableCount = await tx.run(sQuery);
		if (approverTableCount.length > 0) {
			req.reject(409, "Entity Already exists ");
		}
		// let tx = cds.transaction(req);

	})
    
}