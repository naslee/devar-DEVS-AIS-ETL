
CREATE function [DOMetrics].[GetFirstAMMContactReportForProposal]
	(
	@ProposalId int
	)
returns int
as

begin

declare @returnTableId int

select top 1 @returnTableId = cr.ID
from AIS_Prod.ADVANCE.CONTACT_REPORT cr
	join AIS_Prod.ADVANCE.PROPOSAL pl
		on pl.PROPOSAL_ID = cr.PROPOSAL_ID
		and pl.IS_ACTIVE = 1
 where pl.PROPOSAL_ID = @ProposalId
	and cr.IS_ACTIVE = 1
	and cr.CONTACT_PURPOSE_CODE = 'A'

order by cr.CONTACT_DATE ASC
 return @returnTableId
 end