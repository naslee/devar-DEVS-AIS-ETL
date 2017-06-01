


CREATE view [DOMetrics].[vPMRAssignedMissed]
(
AssignmentId,
OfficerId,
AssignmentStart,
FiscalYear,
UnitCode,
AssignmentGUID
)
as
select distinct
AssignmentId,
OfficerId,
AssignmentStart,
--outerAssId,
--daysToExpiration,
FiscalYear,
UnitCode,
AssignmentGUID
from
(
	select 
		  a.AssignmentId
		, a.OfficerId
		, outerAssignment.AssignmentId outerAssId
		, a.AssignmentStart
		, datediff(day,current_timestamp,dateadd(day,dbo.ConfigurationGetIntValue('PAC','End'),a.AssignmentStart)) daysToExpiration
		, a.FiscalYear
		, a.UnitCode
		, a.AssignmentGUID
	from DOMetrics.vPMRAssigned  a
	  left outer join DOMetrics.vPMRAssignedComplete outerAssignment
	 on outerAssignment.AssignmentId = a.AssignmentId
	 and outerAssignment.OfficerId = a.OfficerId


	 where 
	   outerAssignment.AssignmentId is null
) a
where 
a.daysToExpiration <0