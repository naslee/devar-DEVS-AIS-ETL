CREATE view DOMetrics.vGoodFaithEffortContactReport
(
ContactReportID,
OfficerId,
ContactDate,
ProspectId,
ProposalId,
UnitId,
ContactType,
ContactOutcome,
ContactReportTableID
)
as			
					
select distinct 
	  cr.REPORT_ID
	, AUTHOR_ID_NUMBER
	, CONTACT_DATE
	, PROSPECT_ID
	, PROPOSAL_ID
	, UNIT_CODE
	, CONTACT_TYPE
	, CONTACT_OUTCOME
	, cr.ID
from AIS_Prod.ADVANCE.CONTACT_REPORT cr
where CONTACT_TYPE in ('1', 'C', 'P', 'E')
and PROSPECT_ID is not null
and cr.IS_ACTIVE = 1