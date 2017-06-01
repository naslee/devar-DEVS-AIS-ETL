
CREATE function [DOMetrics].[GetMaxContactByOutcomeForAssignment]
	(
	@OfficerId varchar(10),
	@AssignmentId int,
	@OutcomeCode varchar(10)
	)
returns int
as

begin

declare @returnTableId int

select @returnTableId = ID
from
(
	select ID, CONTACT_OUTCOME, rownum
	from
	(
		select 
			cr.ID,
			cr.CONTACT_OUTCOME,
			ROW_NUMBER() OVER (PARTITION BY pmra.AssignmentId, cr.AUTHOR_ID_NUMBER ORDER BY cr.CONTACT_DATE DESC) as rownum
		from AIS_Prod.ADVANCE.CONTACT_REPORT cr
			join DOMetrics.vPMRAssigned pmra
				on pmra.ProspectId = cr.PROSPECT_ID
				and cr.CONTACT_DATE  >= dateadd(day,dbo.ConfigurationGetIntValue('PAC','Start'), pmra.[AssignmentStart])
				and cr.CONTACT_DATE <= dateadd(day,dbo.ConfigurationGetIntValue('PAC','End'), pmra.[AssignmentStart])
		where pmra.AssignmentId = @AssignmentId
			and cr.AUTHOR_ID_NUMBER = @OfficerId 
			and cr.IS_ACTIVE = 1
			and cr.CONTACT_OUTCOME IS NOT NULL
			and LTRIM(RTRIM(cr.CONTACT_OUTCOME)) <> ''
	) a
	where rownum = 1 AND CONTACT_OUTCOME = @OutcomeCode
) b

 return @returnTableId
 end