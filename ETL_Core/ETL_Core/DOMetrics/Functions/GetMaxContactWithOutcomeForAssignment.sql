CREATE function [DOMetrics].[GetMaxContactWithOutcomeForAssignment]
	(
	@OfficerId varchar(10),
	@AssignmentId int
	)
returns int
as

begin

declare @returnTableId int
declare @startDateOffset int
declare @endDateOffset int

set @startDateOffset = dbo.ConfigurationGetIntValue('PAC','Start')
set @endDateOffset = dbo.ConfigurationGetIntValue('PAC','End')

select top 1 @returnTableId = cr.ID
from AIS_Prod.ADVANCE.CONTACT_REPORT cr
	join DOMetrics.vPMRAssigned pmra
		on pmra.ProspectId = cr.PROSPECT_ID
		and cr.CONTACT_DATE  >= dateadd(day,@startDateOffset, pmra.[AssignmentStart])
		and cr.CONTACT_DATE <= dateadd(day,@endDateOffset, pmra.[AssignmentStart])
 where pmra.AssignmentId = @AssignmentId
	and cr.AUTHOR_ID_NUMBER = @OfficerId
	and cr.IS_ACTIVE = 1 
	AND cr.CONTACT_OUTCOME IS NOT NULL 
	AND LTRIM(RTRIM(cr.CONTACT_OUTCOME)) <> ''

order by cr.CONTACT_DATE DESC
 return @returnTableId
 end