
CREATE function [DOMetrics].[GetMaxDisqualifiedContactForAssignment]
	(
	@OfficerId varchar(10),
	@AssignmentId int
	)
returns int
as

begin

declare @returnTableId int

select top 1 @returnTableId = cr.ID
from AIS_Prod.ADVANCE.CONTACT_REPORT cr
	join DOMetrics.vPMRAssigned pmra
		on pmra.ProspectId = cr.PROSPECT_ID
		and cr.CONTACT_DATE  >= dateadd(day,dbo.ConfigurationGetIntValue('PAC','Start'), pmra.[AssignmentStart])
		and cr.CONTACT_DATE <= dateadd(day,dbo.ConfigurationGetIntValue('PAC','End'), pmra.[AssignmentStart])
 where pmra.AssignmentId = @AssignmentId
	and cr.AUTHOR_ID_NUMBER = @OfficerId 
	and cr.IS_ACTIVE = 1
	and cr.CONTACT_OUTCOME in ('NN', 'NR', 'DD') 

order by cr.CONTACT_DATE DESC
 return @returnTableId
 end