const cds = require("@sap/cds");
const gId = require("uuidv4");
// const nodemailer = require('nodemailer');
// const SequenceHelper = require("./lib/SequenceHelper");
module.exports = cds.service.impl((srv) => {

	const {
		PQQuestionnaires,
		Status,
		SupplierItemCats,
		activeSupplier,
		PQQSuppliers,
		Responses,
		QuestionnaireLineitems,
		WorkFlowItems,
		notes,
		logsPQQ,
		configDataList
	} = srv.entities('com.ltim.vendor.buyer.questionaire')

	srv.on("uploadItemsExcelData", async (req) => {
		let tx = cds.transaction(req);
		let excelData = req.data.excelUpload;
		console.log("<===========> Excel Data <==========>" + excelData);
		let ItemArray = [],
			InsertItem = [];
		let oInsert = [],
			oList = await tx.run(
				SELECT.from(Questions)
			);
		let itemIdCount = await tx.run(
			SELECT.from(Questions, ["MAX(questionNumber) as questionNumber"])
		);
		//Item Max Numebr
		/*let itemNo =
			parseInt(
				itemIdCount[0].questionNumber === null ? 0 : itemIdCount[0].questionNumber
			) + 1;*/
		let itemNo = oList.length;
		var itemCounter = 0;
		var itemErr = false;
		console.log(itemNo);
		var promiseAll = [];
		var allowedData = [];
		var ClassConfig = await tx.run(SELECT.from(configDataList).where({
			proccessType: 'PQQ',
			fieldName: 'Classification'
		}));
		/*ClassConfig = [{"fieldName":"Classification","fieldKey":"GEN","fieldValue":"General"},
		{"fieldName":"Classification","fieldKey":"CER","fieldValue":"Certifications"},
		{"fieldName":"Classification","fieldKey":"SPL","fieldValue":"Services / Product lines"},
		{"fieldName":"Classification","fieldKey":"ORG","fieldValue":"Organization Structure"},
		{"fieldName":"Classification","fieldKey":"FIN","fieldValue":"Financial"}];*/
		var ConfigArr = [];
		ClassConfig.forEach(async (value) => {
			ConfigArr.push(value.fieldValue);
			console.log(ConfigArr);
		})
		var QtypeConfig = await tx.run(SELECT.from(configDataList).where({
			proccessType: 'PQQ',
			fieldName: "QuestionTypes"
		}));
		/*QtypeConfig = [{"fieldName":"QuestionTypes","fieldKey":"YNQ","fieldValue":"Yes and No questions"},
		{"fieldName":"QuestionTypes","fieldKey":"TXT","fieldValue":"Text  - Limit on number of Characters in Questions and Answer 1000 characters"},
		{fieldName":"QuestionTypes","fieldKey":"MCM","fieldValue":"Multiple Choice Multiple Answer – Check Box"},
		{"fieldName":"QuestionTypes","fieldKey":"MCD","fieldValue":"Multiple Choice Single Answer – Drop Down"}];*/
		var QtypeArr = [];
		QtypeConfig.forEach(async (value) => {
			QtypeArr.push(value.fieldValue);
			console.log(QtypeArr);
		})
		excelData.forEach(async (v, index) => {
			if (ConfigArr.indexOf(v.Classification) >= 0 && QtypeArr.indexOf(v.Question_Type) >= 0) {
				var classKey = "";
				ClassConfig.forEach(async (value) => {
					if (value.fieldValue == v.Classification) {
						classKey = value.fieldKey;
					}
				});
				var UpdateEntry = {};
				var promiseEntryPass = {};
				var newID = gId();
				//const promiseEach = new Promise(async(resolve, reject) => {
				itemCounter = itemCounter + 1;
				var questKey = "";
				QtypeConfig.forEach(async (value) => {
					if (value.fieldValue == v.Question_Type) {
						questKey = value.fieldKey;
					}
				});
				var choiceOptions = v.Choices_Add_Choice_in_Comma_Seperated;
				var choices = [];
				var multiChoice = [];
				if (questKey == "TXT") {
					choices = [{
						"questionNo": parseInt(itemNo + itemCounter),
						"choiceNo": 1,
						"choiceOption": ""
					}];
				} else if (questKey == "YNQ") {
					choices = [{
						"questionNo": parseInt(itemNo + itemCounter),
						"choiceNo": 1,
						"choiceOption": "Yes"
					}, {
						"questionNo": parseInt(itemNo + itemCounter),
						"choiceNo": 2,
						"choiceOption": "No"
					}];
				} else {
					multiChoice = choiceOptions.split(",");
					multiChoice.forEach(async (value, j) => {
						choices.push({
							"questionNo": parseInt(itemNo + itemCounter),
							"choiceNo": j + 1,
							"choiceOption": value
						})
					});
				}
				promiseEntryPass = {
					"ID": newID,
					"questionNumber": parseInt(itemNo + itemCounter),
					"qType": v.qType,
					"question": v.Question,
					"responseType": v.responseType,
					"response": v.response,
					"attachmentRequired": (v.Attach_Required == "Yes") ? true : false,
					"clasification": classKey,
					"classifiDescription": v.Classification,
					"qType": questKey,
					"qTypeDescription": v.Question_Type,
					"remarks": (v.Add_Remarks == "Yes") ? true : false,
					"respNumorChar": v.respNumorChar,
					"isNumeric": (v.Numeric_Only == "Yes") ? true : false,
					"choices": choices
				}
				promiseAll.push(promiseEntryPass);
			}
		});
		if (promiseAll.length == 0) {
			console.log("s1");
			return req.error(404, 'Import of Excel data Failed');
		} else {
			console.log("s2");
			var itemsUpdate = await tx.run(INSERT.into(Questions).entries(promiseAll));
			if (promiseAll.length != excelData.length) {
				return "Uploaded with Error(s)";
			} else {
				if (itemsUpdate != 0) {
					return "Successfully Uploaded";
				} else {
					return req.error(404, 'Import of Excel data Failed');
				}
			}
		}
	});

	srv.on("addNotes", async (req) => {
		let tx = cds.transaction(req);
		let pqqID = req.data.UUID;
		var onotesData = {};
		onotesData.notesType = req.data.notesType;
		onotesData.version = req.data.version;
		onotesData.BodyText = req.data.BodyText;
		onotesData.parent_ID = pqqID;
		var itemsUpdate = await tx.run(INSERT.into(notes).entries(onotesData));
		if (itemsUpdate) {
			return "Notes Added Successfully"
		} else {
			console.log("Error in Adding Notes");
		}
	});

	srv.on("publish", async (req) => {
		let tx = cds.transaction(req);
		let sCurrentDate = new Date(),
			sDate = sCurrentDate.getDate() < 10 ? "0" + sCurrentDate.getDate() : sCurrentDate.getDate(),
			sMonth = sCurrentDate.getMonth() + 1 < 10 ? "0" + (sCurrentDate.getMonth() + 1) : sCurrentDate.getMonth() + 1,
			sYear = sCurrentDate.getFullYear(),
			sFDate = sDate + "/" + sMonth + "/" + sYear;
		//  Update Pre-Qualification questionnire
		await tx.run(
			UPDATE(PQQuestionnaires)
				.set({
					status: "Published",
					publishedDate: sFDate
				})
				.where({
					ID: req.data.ID
				})
		);
		return "true";
	});

	srv.on("amend", async (req) => {
		let tx = cds.transaction(req);
		var status = req.data.status;
		//  Update Pre-Qualification questionnire
		await tx.run(
			UPDATE(PQQuestionnaires)
				.set({
					status: "Revised",
					//status: "Approved",
					//approvedDate: sFDate,
					//publishedDate: sFDate
				})
				.where({
					ID: req.data.ID
				})
		);
		return "true";
	});

	srv.on("updateLogs", async (req) => {
		let tx = cds.transaction(req);
		// Copy Header
		//let cVersion = req.data.version;
		let logsItems = await tx.run(
			SELECT.from(logsPQQ).where({
				parent_ID: req.data.ID,
			})
		);
		let aInsertItem = [];
		var oLogPQQ = {};
		oLogPQQ.remarks = req.data.remarks;
		var oLength = logsItems.length + 1;
		oLogPQQ.sno = oLength;
		oLogPQQ.parent_ID = req.data.ID;
		aInsertItem.push(oLogPQQ);
		let qInsertLog = await tx.run(
			INSERT.into(logsPQQ).entries(oLogPQQ)
		);
		return "Success";
	});

	srv.on('approver_notificationSubmit', async (req) => {
		try {
			let tx = cds.transaction(req);
			const pqqGUIID = req.data.ID;
			var oHeader = await tx.run(SELECT.from(PQQuestionnaires).where({
				ID: pqqGUIID
			}));
			var sData = oHeader[0];
			var oContactEmail = req.data.email;
			var mailSetting = await tx.run(SELECT.one(PPA_MAILSetting, mailSetting => {
				mailSetting.host,
					mailSetting.port,
					mailSetting.user,
					mailSetting.pass,
					mailSetting.applicationEmail,
					mailSetting.applicationHost
			}).where({
				mail: 'SMTP'
			}))
			console.log(mailSetting);
			let transporter = nodemailer.createTransport({
				host: mailSetting.host,
				port: mailSetting.port,
				auth: {
					user: mailSetting.user,
					pass: mailSetting.pass
				},
				pool: true, // use pooled connection
				rateLimit: true, // enable to make sure we are limiting
				maxConnections: 1, // set limit to 1 connection only
				maxMessages: 1 // send 2 emails per second
			})
			let mailOptions = {
				from: mailSetting.applicationEmail,
				to: oContactEmail,
				//	subject: 'Progress Application Requested – ' + ProjectId + ' – ' + startDate[1] + "/" + startDate[3],
				subject: 'Pre-Qualification Questionnaire for ' + sData.pqqDescription + ' is submitted for your approval to Publish', //for Project: ' + paraProjectId + ' and Document No. : ' + paraDocumentNo + ',
				html: '<html><head> <style>table,th,td{border:1px solid black;border-collapse:collapse;}th,td{padding: 15px;text-align:left;}</style>' +
					'</head><body><p>Dear Approver,' +
					'</p><p>PQQ ' + sData.pqqDescription + ' is submitted for your approval to Publish.' +
					'<br>' +
					'PQQ No.: ' + sData.pqqNo +
					'<br>' +
					'PQQ Title: ' + sData.pqqDescription +
					'<br>' +
					'Company: ' + sData.companyDesc +
					'<br>' +
					'Plant: ' + sData.Plant +
					'<br>' +
					'Published Date: ' + sData.publishedDate +
					'<br>' +
					'Response End Date: ' + sData.responseEndDate +
					'<br>' +
					'Requestor: ' + sData.contactName +
					'<br>' +
					'Please click on link below to take action' +
					'<br>' +
					'<a href="url">[Link to Portal]</a>' +
					'<br>' +
					'Thank You,' +
					'<br>' +
					'</p></body> </html > '
			}

			transporter.sendMail(mailOptions, function (error, info) {
				if (error) {
					console.log(error)
				} else {
					console.log('Email sent: ' + info.response)
				}
			})
		} catch (error) {
			console.log(error);
		}
	});

	srv.on('approver_notificationSubmitAmend', async (req) => {
		try {
			let tx = cds.transaction(req);
			const pqqGUIID = req.data.ID;
			var oHeader = await tx.run(SELECT.from(PQQuestionnaires).where({
				ID: pqqGUIID
			}));
			var sData = oHeader[0];
			var oContactEmail = req.data.email;
			var mailSetting = await tx.run(SELECT.one(PPA_MAILSetting, mailSetting => {
				mailSetting.host,
					mailSetting.port,
					mailSetting.user,
					mailSetting.pass,
					mailSetting.applicationEmail,
					mailSetting.applicationHost
			}).where({
				mail: 'SMTP'
			}))
			console.log(mailSetting);
			let transporter = nodemailer.createTransport({
				host: mailSetting.host,
				port: mailSetting.port,
				auth: {
					user: mailSetting.user,
					pass: mailSetting.pass
				},
				pool: true, // use pooled connection
				rateLimit: true, // enable to make sure we are limiting
				maxConnections: 1, // set limit to 1 connection only
				maxMessages: 1 // send 2 emails per second
			})
			let mailOptions = {
				from: mailSetting.applicationEmail,
				to: oContactEmail,
				//	subject: 'Progress Application Requested – ' + ProjectId + ' – ' + startDate[1] + "/" + startDate[3],
				subject: 'Pre-Qualification Questionnaire for ' + sData.pqqDescription +
					' is submitted for your approval to Publish [Amended PQQ]', //for Project: ' + paraProjectId + ' and Document No. : ' + paraDocumentNo + ',
				html: '<html><head> <style>table,th,td{border:1px solid black;border-collapse:collapse;}th,td{padding: 15px;text-align:left;}</style>' +
					'</head><body><p>Dear Approver,' +
					'</p><p>PQQ ' + sData.pqqDescription + ' is submitted for your approval to Publish.' +
					'<br>' +
					'PQQ No.: ' + sData.pqqNo +
					'<br>' +
					'PQQ Title: ' + sData.pqqDescription +
					'<br>' +
					'Company: ' + sData.companyDesc +
					'<br>' +
					'Plant: ' + sData.Plant +
					'<br>' +
					'Published Date: ' + sData.PublishedDate +
					'<br>' +
					'Response End Date: ' + sData.responseEndDate +
					'<br>' +
					'Requestor: ' + sData.contactName +
					'<br>' +
					'Reason for Amendment :' +
					'<br>' +
					req.data.bodyText +
					'<br>' +
					'Please click on link below to take action' +
					'<br>' +
					'<a href="url">[Link to Portal]</a>' +
					'<br>' +
					'Thank You,' +
					'<br>' +
					'</p></body> </html > '
			}

			transporter.sendMail(mailOptions, function (error, info) {
				if (error) {
					console.log(error)
				} else {
					console.log('Email sent: ' + info.response)
				}
			})
		} catch (error) {
			console.log(error);
		}
	});

	srv.on('Supplier_notificationPublish', async (req) => {
		try {
			let tx = cds.transaction(req);
			const pqqID = req.data.ID;
			let supplierDetails = [];
			var pqq = await tx.run(SELECT.from(PQQuestionnaires).where({
				ID: pqqID
			}));
			let suppData = await tx.run(
				SELECT.from(PQQSuppliers).where({
					parent_ID: pqqID,
				})
			);
			var mailSetting = await tx.run(SELECT.one(PPA_MAILSetting, mailSetting => {
				mailSetting.host,
					mailSetting.port,
					mailSetting.user,
					mailSetting.pass,
					mailSetting.applicationEmail,
					mailSetting.applicationHost
			}).where({
				mail: 'SMTP'
			}))
			//console.log(mailSetting);

			let transporter = nodemailer.createTransport({
				host: mailSetting.host,
				port: mailSetting.port,
				auth: {
					user: mailSetting.user,
					pass: mailSetting.pass
				},
				pool: true, // use pooled connection
				rateLimit: true, // enable to make sure we are limiting
				maxConnections: 1, // set limit to 1 connection only
				maxMessages: 1 // send 2 emails per second
			})
			suppData.forEach(async (pqqSup, index) => {
				var sResDate = new Date(pqq[0].responseEndDate).toLocaleDateString('en-US');
				var mailOptions = {
					from: mailSetting.applicationEmail,
					to: pqqSup.email,
					subject: pqq[0].companyDesc + ' has invited you to participate in the Pre-Qualification Questionnaire for ' + pqq[0].pqqDescription,
					html: '<html><head> <style>table,th,td{border:1px solid black;border-collapse:collapse;}th,td{padding: 15px;text-align:left;}</style>' +
						'</head><body><p> Dear Valuable Supplier,' +
						'</p><p>' + pqq[0].companyDesc + ' is honored to invite you to participate in the PQQ (Pre-qualification Questionnaire) ' +
						pqq[0].pqqDescription +
						'<br>' +
						'This PQQ is carried out to evaluate suppliers and shortlist to a follow on RFQ (Request for Quotation) process' +
						'<br>' +
						'Use the following link to access our Supplier Portal site, in order to view the contents and respond to this PQQ. ' +
						'<br>' +
						'<a href="url">[Link to SAP Supplier Portal]</a>' +
						'<br>' +
						'Please note that the submission deadline for this PQQ is set at ' + sResDate + ', [Arabia Standard Time].' +
						'<br>' +
						'All communication regarding the PQQ must be via the supplier Portal.' +
						'<br>' +
						'Looking forward to your active participation and we encourage you to submit your responses complying to the deadline. Kindly note that any responses submitted outside of the supplier portal will not be considered in our evaluation.' +
						'<br>' +
						'<br>' +
						'Thank You,' +
						'<br>' +
						'</p></body> </html > '
				}
				transporter.sendMail(mailOptions, function (error, info) {
					if (error) {
						console.log(error)
					} else {
						console.log('Email sent: ' + info.response)
					}
				})
			});
			return "Success"
		} catch (error) {
			console.log(error);
		}
	});

	srv.on('Supplier_notificationPublishDateReduce', async (req) => {
		try {
			let tx = cds.transaction(req);
			const pqqID = req.data.ID;
			let supplierDetails = [];
			var pqq = await tx.run(SELECT.from(PQQuestionnaires).where({
				ID: pqqID
			}));
			let suppData = await tx.run(
				SELECT.from(PQQSuppliers).where({
					parent_ID: pqqID,
				})
			);
			var mailSetting = await tx.run(SELECT.one(PPA_MAILSetting, mailSetting => {
				mailSetting.host,
					mailSetting.port,
					mailSetting.user,
					mailSetting.pass,
					mailSetting.applicationEmail,
					mailSetting.applicationHost
			}).where({
				mail: 'SMTP'
			}))
			//console.log(mailSetting);

			let transporter = nodemailer.createTransport({
				host: mailSetting.host,
				port: mailSetting.port,
				auth: {
					user: mailSetting.user,
					pass: mailSetting.pass
				},
				pool: true, // use pooled connection
				rateLimit: true, // enable to make sure we are limiting
				maxConnections: 1, // set limit to 1 connection only
				maxMessages: 1 // send 2 emails per second
			})
			suppData.forEach(async (pqqSup, index) => {
				var sResDate = new Date(pqq[0].responseEndDate).toLocaleDateString('en-US');
				var mailOptions = {
					from: mailSetting.applicationEmail,
					to: pqqSup.email,
					subject: 'Pre-Qualification Questionnaire for ' + pqq[0].pqqDescription + ' submission deadline reduced – ' + pqq[0].companyDesc,
					html: '<html><head> <style>table,th,td{border:1px solid black;border-collapse:collapse;}th,td{padding: 15px;text-align:left;}</style>' +
						'</head><body><p> Dear Valuable Supplier,' +
						'</p><p>Please note that the submission deadline for PQQ ' + pqq[0].pqqDescription +
						' has been reduced and the new deadline is set at ' + sResDate + ', [Arabia Standard Time].' +
						'<br>' +
						'All communication regarding the PQQ must be via the supplier Portal.' +
						'<br>' +
						'To view the changes, please access our supplier portal <a href=url">[Click Here]</a>. After you log on, you will see the updated response end time.' +
						'<br>' +
						'Looking forward to your active participation and we encourage you to submit your responses complying to the deadline. Kindly note that any responses submitted outside of the supplier portal will not be considered in our evaluation.' +
						'<br>' +
						'<br>' +
						'Thank You,' +
						'<br>' +
						'</p></body> </html > '
				}

				transporter.sendMail(mailOptions, function (error, info) {
					if (error) {
						console.log(error)
					} else {
						console.log('Email sent: ' + info.response)
					}
				})

			});
			return "Success"
		} catch (error) {
			console.log(error);
		}
	});

	srv.on('Supplier_notificationPublishDateExtend', async (req) => {
		try {
			let tx = cds.transaction(req);
			const pqqID = req.data.ID;
			let supplierDetails = [];
			var pqq = await tx.run(SELECT.from(PQQuestionnaires).where({
				ID: pqqID
			}));
			let suppData = await tx.run(
				SELECT.from(PQQSuppliers).where({
					parent_ID: pqqID,
				})
			);
			var mailSetting = await tx.run(SELECT.one(PPA_MAILSetting, mailSetting => {
				mailSetting.host,
					mailSetting.port,
					mailSetting.user,
					mailSetting.pass,
					mailSetting.applicationEmail,
					mailSetting.applicationHost
			}).where({
				mail: 'SMTP'
			}))
			//console.log(mailSetting);

			let transporter = nodemailer.createTransport({
				host: mailSetting.host,
				port: mailSetting.port,
				auth: {
					user: mailSetting.user,
					pass: mailSetting.pass
				},
				pool: true, // use pooled connection
				rateLimit: true, // enable to make sure we are limiting
				maxConnections: 1, // set limit to 1 connection only
				maxMessages: 1 // send 2 emails per second
			})
			suppData.forEach(async (pqqSup, index) => {
				var sResDate = new Date(pqq[0].responseEndDate).toLocaleDateString('en-US');
				var mailOptions = {
					from: mailSetting.applicationEmail,
					to: pqqSup.email,
					subject: 'Pre-Qualification Questionnaire for ' + pqq[0].pqqDescription + ' submission deadline extended – ' + pqq[0].companyDesc,
					html: '<html><head> <style>table,th,td{border:1px solid black;border-collapse:collapse;}th,td{padding: 15px;text-align:left;}</style>' +
						'</head><body><p> Dear Valuable Supplier,' +
						'</p><p>Please note that the submission deadline for this PQQ has been extended until ' + sResDate +
						', [Arabia Standard Time].' +
						'<br>' +
						'All communication regarding the PQQ must be via the supplier Portal.' +
						'<br>' +
						'To view the changes, please access our supplier portal <a href=url">[Click Here]</a>. After you log on, you will see the updated response end time.' +
						'<br>' +
						'Looking forward to your active participation and we encourage you to submit your responses complying to the deadline. Kindly note that any responses submitted outside of the supplier portal will not be considered in our evaluation.' +
						'<br>' +
						'<br>' +
						'Thank You,' +
						'<br>' +
						'</p></body> </html > '
				}

				transporter.sendMail(mailOptions, function (error, info) {
					if (error) {
						console.log(error)
					} else {
						console.log('Email sent: ' + info.response)
					}
				})

			});
			return "Success";
		} catch (error) {
			console.log(error);
		}
	});

	srv.on('Supplier_notificationCancel', async (req) => {
		try {
			let tx = cds.transaction(req);
			const pqqID = req.data.ID;
			let supplierDetails = [];
			var pqq = await tx.run(SELECT.from(PQQuestionnaires).where({
				ID: pqqID
			}));
			let suppData = await tx.run(
				SELECT.from(PQQSuppliers).where({
					parent_ID: pqqID,
				})
			);
			var mailSetting = await tx.run(SELECT.one(PPA_MAILSetting, mailSetting => {
				mailSetting.host,
					mailSetting.port,
					mailSetting.user,
					mailSetting.pass,
					mailSetting.applicationEmail,
					mailSetting.applicationHost
			}).where({
				mail: 'SMTP'
			}))
			//console.log(mailSetting);

			let transporter = nodemailer.createTransport({
				host: mailSetting.host,
				port: mailSetting.port,
				auth: {
					user: mailSetting.user,
					pass: mailSetting.pass
				},
				pool: true, // use pooled connection
				rateLimit: true, // enable to make sure we are limiting
				maxConnections: 1, // set limit to 1 connection only
				maxMessages: 1 // send 2 emails per second
			})
			suppData.forEach(async (pqqSup, index) => {
				var mailOptions = {
					from: mailSetting.applicationEmail,
					to: pqqSup.email,
					subject: 'Pre-Qualification Questionnaire for ' + pqq[0].pqqDescription + ' canceled– [LTI]' + pqq[0].companyDesc,
					html: '<html><head> <style>table,th,td{border:1px solid black;border-collapse:collapse;}th,td{padding: 15px;text-align:left;}</style>' +
						'</head><body><p> Dear Valuable Supplier,' +
						'</p><p>Kindly note that the PQQ ' + pqq[0].pqqDescription + ' has been canceled.' +
						'<br>' +
						'Hence, the PQQ is no longer available for response submission due to the cancelation. We apologize any inconvenience caused.s' +
						'<br>' +
						'All communication regarding the PQQ must be via the supplier Portal. ' +
						'<br>' +
						'Looking forward to your participation for future PQQs' +
						'<br>' +
						'<br>' +
						'Thank You,' +
						'<br>' +
						'</p></body> </html > '
				}

				transporter.sendMail(mailOptions, function (error, info) {
					if (error) {
						console.log(error)
					} else {
						console.log('Email sent: ' + info.response)
					}
				})

			});
			return "Success"
		} catch (error) {
			console.log(error);
		}
	});

	srv.on('supplier_notification', async (req) => {
		try {
			let tx = cds.transaction(req);
			const pqqID = req.data.ID;
			//const mailID = req.data.mailID;
			var bodyText = req.data.bodyText;
			let suppData = req.data.suppliers;
			let supplierDetails = [];

			/*suppData.forEach(async(suppItem, index) => {
				supplierDetails.push({
					"email": suppItem.email,
					"supplierName": suppItem.supplierName
				});
			});*/

			var pqq = await tx.run(SELECT.from(PQQuestionnaires).where({
				ID: pqqID
			}));

			var mailSetting = await tx.run(SELECT.one(PPA_MAILSetting, mailSetting => {
				mailSetting.host,
					mailSetting.port,
					mailSetting.user,
					mailSetting.pass,
					mailSetting.applicationEmail,
					mailSetting.applicationHost
			}).where({
				mail: 'SMTP'
			}))
			//console.log(mailSetting);

			let transporter = nodemailer.createTransport({
				host: mailSetting.host,
				port: mailSetting.port,
				auth: {
					user: mailSetting.user,
					pass: mailSetting.pass
				},
				pool: true, // use pooled connection
				rateLimit: true, // enable to make sure we are limiting
				maxConnections: 1, // set limit to 1 connection only
				maxMessages: 1 // send 2 emails per second
			})

			suppData.forEach(async (suppItem, index) => {
				/*var supDet = await tx.run(SELECT.one(activeSupplier).where({
					supplierID: suppItem.supplierID
				}));*/
				var pqqSup = await tx.run(SELECT.from(PQQSuppliers).where({
					parent_ID: pqqID,
					supplierId: suppItem.supplierID
				}));
				var mailOptions = {
					from: mailSetting.applicationEmail,
					to: pqqSup[0].email,
					//	subject: 'Progress Application Requested – ' + ProjectId + ' – ' + startDate[1] + "/" + startDate[3],
					//subject: 'Notification ', //for Project: ' + paraProjectId + ' and Document No. : ' + paraDocumentNo + ',
					subject: 'Pre-Qualification Questionnaire for ' + pqq[0].pqqDescription + ' – Message',
					html: '<html><head> <style>table,th,td{border:1px solid black;border-collapse:collapse;}th,td{padding: 15px;text-align:left;}</style>' +
						'</head><body><p> Dear ' + suppItem.supplierName + ',' +
						/*'</p><p>You have a message in: ' + pqq[0].pqqNo + ' and message. : ' + bodyText +*/
						'</p><p>Message from ' + pqq[0].companyDesc + ' has been submitted for ' + pqq[0].pqqNo + ' as follows' +
						'<br>' + bodyText +
						'<br>' +
						'Please <a href="url">[click here]</a> to take an action' +
						'<br>' +
						'All communication regarding the PQQ must be via the supplier Portal. ' +
						'<br>' +
						'Thank you' +
						'</p></body> </html > '
				}

				transporter.sendMail(mailOptions, function (error, info) {
					if (error) {
						console.log(error)
					} else {
						console.log('Email sent: ' + info.response)
					}
				})

			});
			return "Success"
		} catch (error) {
			console.log(error);
			return "Error in Sending Mail";
		}
	});

	srv.on('getLoggedInUserInfo', async (req) => {
		if (!req.user) {
			// res.statusCode = 403;
			// res.end(`Missing JWT Token`);
			return 'Missing user'
		} else {
			// res.statusCode = 200;
			return req.user.name
		}
	});

	srv.on("updateWFPQQ", async (req) => {
		let tx = cds.transaction(req);
		// Update User Registration
		await tx.run(
			UPDATE(PQQuestionnaires)
				.set({
					wfStatus: req.data.wfstatus,
					worflowInstanceID: req.data.wfinstance
				})
				.where({
					ID: req.data.ID
				})
		);
		return "true";
	});

	srv.on("updateWFPQQSupplier", async (req) => {
		let tx = cds.transaction(req);
		let suppliers = await tx.run(
			SELECT.from(PQQSuppliers).where({
				parent_ID: req.data.ID
			})
		);
		suppliers.forEach(async (suppItem, index) => {
			if (suppItem.responseID !== null && suppItem.worflowInstanceID == null) {
				// Update 
				await tx.run(
					UPDATE(PQQSuppliers)
						.set({
							wfStatus: req.data.wfstatus,
							worflowInstanceID: req.data.wfinstance
						})
						.where({
							ID: suppItem.ID
						})
				);
			}

		});

		return "true";
	});

	srv.on("updateLogs", async (req) => {
		let tx = cds.transaction(req);
		// Copy Header
		//let cVersion = req.data.version;
		let logsItems = await tx.run(
			SELECT.from(logsPQQ).where({
				parent_ID: req.data.ID,
			})
		);
		let aInsertItem = [];
		var oLogPQQ = {};
		oLogPQQ.remarks = req.data.remarks;
		var oLength = logsItems.length + 1;
		oLogPQQ.sno = oLength;
		oLogPQQ.parent_ID = req.data.ID;
		aInsertItem.push(oLogPQQ);
		let qInsertLog = await tx.run(
			INSERT.into(logsPQQ).entries(oLogPQQ)
		);
		return "Success";
	});


})
