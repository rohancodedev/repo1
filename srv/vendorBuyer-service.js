const workFlow = require("./workFlow");
const { v4: gId } = require("uuid");
const lodash = require("lodash");

module.exports = async function (srv) {
  const {
    loginItemCatagory,
    approversList,
    userRegistration,
    SupplierWorkFlow,
    generalDetails,
    companyProfile,
    supplierItemCatagory,
  } = cds.entities("com.ltim.vendor.buyer");

  function _pad(num, size) {
    var s = "00000000000" + num;
    return s.substr(s.length - size);
  }

  srv.on("addDeleteItemsCat", async (req) => {
    let tx = cds.transaction(req),
      sVersion = await tx.run(
        SELECT.from(loginItemCatagory).where({
          "email": req.data.email.toString().toLowerCase(),
          "itemCatagory01": req.data.itemCat1,
          "itemCatagory02": req.data.itemCat2,
          "deleteFlag": false,
        })
      );

    if (req.data.status === "add") {
      if (sVersion.length === 0) {
        await tx.run(
          INSERT.into(loginItemCatagory).entries([{
            "email": req.data.email.toString().toLowerCase(),
            "itemCatagory01": req.data.itemCat1,
            "itemCatagory02": req.data.itemCat2,
            "productService": req.data.productService,
          }])
        );
        return "Item Category added Successfully.";
      } else {
        return "Selected Item Category is already available.";
      }
    } else {
      await tx.run(
        DELETE.from(loginItemCatagory).where({
          "email": req.data.email.toString().toLowerCase(),
          "itemCatagory01": req.data.itemCat1,
          "itemCatagory02": req.data.itemCat2,
          "productService": req.data.productService,
        })
      );
      return "Selected Item Category has removed Successfully.";
    }
  });

  srv.on("submitRegistration", async (req) => {
    let rData = req.data.payLoad,
      tx = cds.transaction(req),
      // sQuery = "select * from COM_LTIM_VENDOR_BUYER_USERREGISTRATION where upper(email) = upper('" + rData.email + "')",
      sQuery = "SELECT lower (concat (COMPANYNAME, concat('-', EMAIL))) as CompanyEmail from COM_LTIM_VENDOR_BUYER_USERREGISTRATION where lower (concat (COMPANYNAME, concat('-', EMAIL))) = lower(concat ('" + rData.companyName + "', concat('-', '" + rData.email + "')))",
      query = cds.parse.cql(sQuery),
      supplierIDCount1 = await tx.run(sQuery);

    console.log("#################################    sQuery    ::    " + sQuery);

    if (supplierIDCount1.length > 0) {
      return ("Email ID ( " + rData.email + " ) is already registrated with Company Name ( " + decodeURI(rData.companyName) + " )");
    } else {
      sQuery = "SELECT *  from COM_LTIM_VENDOR_BUYER_USERREGISTRATION where lower(EMAIL) = lower('" + rData.email + "')";
      query = cds.parse.cql(sQuery);
      var emailCount = await tx.run(sQuery);

      if (emailCount.length > 0) {
        return ("Email ID ( " + rData.email + " ) is already registrated with Company Name ( " + decodeURI(emailCount[0].COMPANYNAME) + " ), Use a different Email ID");
      }

      let supplierIDCount = await tx.run(SELECT.from(userRegistration, ["MAX(supplierID) as supplierID"])),
        aiSmrId = parseInt(supplierIDCount[0].supplierID === null ? 0 : supplierIDCount[0].supplierID) + 1,
        oSupplierID = _pad(aiSmrId, 10),
        oWorkFlow = new workFlow();

      // oWorkFlow.setDestination("bpmworkflowruntime");
      let oApprovalInsert = [],
        oApproversListData = [],
        oWorkFlowItems = [];

      // sQuery = "select * from " + approversList["@cds.persistence.name"] + " where appType = 'SRSR' and actorType = 'SM' and companyCode = '*'";
      sQuery = "SELECT * FROM COM_LTIM_VENDOR_BUYER_APPROVERSLIST where appType = 'SRSR' and actorType = 'SM' and companyCode = '*'";

      query = cds.parse.cql(sQuery);

      let oApproversListRaw = await tx.run(sQuery),
        workFlowID = gId(),
        sLevel = 1,
        oApproversList = lodash.sortBy(oApproversListRaw, ["Level"]);

      if (oApproversList.length > 0) {
        oApproversList.forEach((v, i) => {
          oApproversListData.push({
            actorType: v.ACTORTYPE,
            fullName: v.FULLNAME,
            Level: v.LEVEL,
            actorTypeDescription: v.ACTORTYPEDESCRIPTION,
            Id: v.ID,
            sort: sLevel,
          });

          oWorkFlowItems.push({
            wFID: workFlowID,
            supplierID: oSupplierID,
            Level: sLevel,
            Status: "X",
            EmailID: v.ID,
            Rule: v.ACTORTYPE + v.ACTORTYPEDESCRIPTION,
            workFlowType: "SRSR",
            Remarks: "",
          });

          sLevel = sLevel + 1;
        });

        console.log("1. <==== Submit Registration ====>  Starting Workflow");

        var oData = {
          "definitionId": "supplierSM",
          "context": {
            "currentLevel": 1,
            "hasNextApprover": "true",
            "approversList": oApproversListData,
            "supplierID": oSupplierID,
            "subject": "Self Supplier Registration for Supplier: " + oSupplierID,
            "data": rData,
            "currentType": oApproversListData[0].actorType,
            "currentApprover": oApproversListData[0].Id,
            "isFinalApprover": false,
            "isApproved": null,
            "email": oApproversListData[0].Id,
            "initiator": rData.email,
            "parentWKFlowID": workFlowID,
            "isEditable": true,
          },
        };

        let oWorkFlowStatus = await oWorkFlow.startWorkflow(oData);
        console.log("2. <==== Submit Registration ====>  Workflow Instance Creation Completed");

        let oUserRegistrationInsert = [{
          "ID": workFlowID,
          "email": rData.email.toString().toLowerCase(),
          "supplierID": oSupplierID,
          "fName": decodeURI(rData.fName),
          "lname": decodeURI(rData.lname),
          "companyName": decodeURI(rData.companyName),
          "status": "0",
          "wStatus": "X",
          "rLevel": "1",
          "rWFID": oWorkFlowStatus.data.id,
        }];

        console.log("3. <==== Submit Registration ====>  oWorkFlowStatus    ::    " + JSON.stringify(oWorkFlowStatus.data));

        if (oWorkFlowStatus.data.status === "RUNNING") {
          console.log("4. <==== Submit Registration ====>  Inside IF Condition  ");
          console.log("5. <==== Submit Registration ====>  AAAAAAAAAA");
          await tx.run(INSERT.into(SupplierWorkFlow).entries(oWorkFlowItems));
          console.log("6. <==== Submit Registration ====>  BBBBBBBBBB");
          await tx.run(INSERT.into(userRegistration).entries(oUserRegistrationInsert));
          console.log("7. <==== Submit Registration ====>  CCCCCCCCCC");

          await tx.run(
            INSERT.into(generalDetails).entries([
              {
                "supplierID": oSupplierID,
                "companyName": rData.companyName,
                "country": rData.country,
                "countryName": rData.countryName,
                "companyTelNoCode": rData.companyTelNoCode,
                "companyTelNoNumber": rData.companyTelNoNumber,
                "email": rData.email.toString().toLowerCase(),
                "companyEmailID": rData.email.toString().toLowerCase(),
                "website": rData.website,
                "remarks": rData.remarks,
                "attachments": rData.attachments,
              },
            ])
          );

          console.log("7. <==== Submit Registration ====>  DDDDDDDDDDDD");

          await tx.run(
            INSERT.into(companyProfile).entries([
              {
                "supplierID": oSupplierID,
                "commercialLicNumber": rData.commercialLicNumber,
              },
            ])
          );

          console.log("8. <==== Submit Registration ====>  EEEEEEEEEEEEEEE");
          let loginItemCatData = await tx.run(SELECT.from(loginItemCatagory, supLoginItems => {
            supLoginItems.productService,
              supLoginItems.itemCatagory01,
              supLoginItems.itemCatagory02
          }).where({
            email: rData.email.toString().toLowerCase()
          }));
          console.log("6. <==== Submit Registration ====>  FFFFFFFFFFFFF");
          let record = {},
            supItemCategoryArray = [],
            itemCommonID = gId();

          loginItemCatData.forEach(loginItemCatDetails => {
            record = {}
            record.itemID = itemCommonID
            record.email = rData.email.toString().toLowerCase()
            record.supplierID = oSupplierID
            record.productService = loginItemCatDetails.productService
            record.itemCatagory01 = loginItemCatDetails.itemCatagory01
            record.itemCatagory02 = loginItemCatDetails.itemCatagory02
            supItemCategoryArray.push(record)
          })

          console.log("6. <==== Submit Registration ====>  GGGGGGGGGGGGGGG supItemCategoryArray.length  ::   " + supItemCategoryArray.length);
          if (supItemCategoryArray.length > 0) {
            await tx.run(INSERT.into(supplierItemCatagory).entries(supItemCategoryArray))
          }

          console.log("6. <==== Submit Registration ====>  HHHHHHHHHHHHHHHHHHH");

          let sReturn =
            "Thanks for Registrating with LTIMindtree. Your Reference ID: " +
            oSupplierID +
            ". Once all the Level of approval done you will get login access to your Registrated Email ID " +
            rData.email +
            ".";
          return sReturn;
        } else {
          return "Failed in Trigging WorkFlow";
        }
      } else {
        return "No DoA is assigned to WorkFlow process";
      }
    }
  });

  srv.on("checkSupplierStatus", async (req) => {
    let tx = cds.transaction(req);
    let oSupplier = await tx.run(
      SELECT.from(userRegistration).where({
        supplierID: req.data.supplierID,
        email: req.data.email.toString().toLowerCase(),
      })
    );
    console.log(oSupplier);
    let oReturn = "";
    if (oSupplier[0].rStatus === "X") {
      oReturn = "Waiting for Approval.";
    } else if (oSupplier[0].rStatus === "Y") {
      oReturn =
        "Supplier has been Approved Successfully. Kindly check you registrated email.";
    } else if (oSupplier[0].rStatus === "Z") {
      oReturn = "Approval has been Reject.";
    }
    return oReturn;
  });
}