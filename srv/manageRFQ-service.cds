using {com.ltim.vendor.buyer as rfq} from '../db/manageRFQ-model';
using {com.ltim.vendor.buyer as cn} from '../db/candy-model';

@protocol: 'rest'
@path    : 'manageRFQRestService'

service manageRFQService @(impl: './manageRFQ-service.js') {
    @cds.redirection.target: true
    entity headerRFQ                     as projection on rfq.headerRFQ;
    entity itemRFQ                       as projection on rfq.itemRFQ;
    entity rfqitemattachments            as projection on rfq.rfqitemattachments;
    entity subconQuoteImageAttachment    as projection on rfq.subconQuoteImageAttachment;
    entity subconRFQImageAttachment      as projection on rfq.subconRFQImageAttachment;
    entity notesRFQ                      as projection on rfq.notesRFQ;
    entity supplierRFQ                   as projection on rfq.supplierRFQ;
    entity supplierContracts             as projection on rfq.supplierContracts;
    entity rfqattachments                as projection on rfq.rfqattachments;
    entity questionsRFQ                  as projection on rfq.questionsRFQ;
    entity MultipleChoicesRFQ            as projection on rfq.MultipleChoicesRFQ;
    entity quotationsRFQ                 as projection on rfq.quotationsRFQ;
    entity techApproversRFQ              as projection on rfq.techApproversRFQ;
    entity logsRFQ                       as projection on rfq.logsRFQ;
    entity BuyerSupplierConversationsRFQ as projection on rfq.BuyerSupplierConversationsRFQ;
    entity ConversationAttachmentsRFQ    as projection on rfq.ConversationAttachmentsRFQ;
    entity cmisMessengerFolderRFQ        as projection on rfq.cmisMessengerFolderRFQ;
    entity ToSuppliersRFQ                as projection on rfq.ToSuppliersRFQ;
    entity fieldLevelAttachments         as projection on rfq.fieldLevelAttachments;

    // RealOnly::ValueHelp for Project with search

    @readonly
    entity requestorVH as 
        select from rfq.headerRFQ distinct {
            key initiator,
                initiatorName
        }
        group by 
            initiator,
            initiatorName
        order by 
            initiator asc;

    @readonly
    entity packageCode as 
        select from cn.candyEstimation distinct {
            key projectId,
                packageCode,
                resAnalysisCostCode,
                resAnalysisCostDescription,
                resAnalysisCode,
                resAnalysisDescription
        }
        where 
            resAnalysisType = 'S'
            or resAnalysisType = 'D'
            or resAnalysisType = 'P'
        group by
            projectId,
            packageCode,
            resAnalysisCostCode,
            resAnalysisCostDescription,
            resAnalysisCode,
            resAnalysisDescription
        order by 
            packageCode asc;
    
    @readonly
    entity projectVH  as 
        select from rfq.headerRFQ distinct {
            key project,
                projectName
        }
        group by
            project,
            projectName
        order by
            project asc;
    
    @readonly
    entity rfqVH   as 
        select from rfq.headerRFQ distinct {
            key rfqId,
                rfqDescription
        }
        group by
            rfqId,
            rfqDescription
        order by
            rfqId asc;

}
