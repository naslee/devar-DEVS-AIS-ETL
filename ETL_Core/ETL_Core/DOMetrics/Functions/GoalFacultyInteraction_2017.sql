
--drop procedure ETL.DOMetricsGoal2017

create function DOMetrics.[GoalFacultyInteraction_2017]
(
@GoalFiscalYear int, 
@IdNumber varchar(10)
)
RETURNS int
as
begin
declare @FacultyInteractionGoal int

select 
@FacultyInteractionGoal = GOAL_6 
from AIS_Prod.ADVANCE.GOAL
where IS_ACTIVE = 1
and [YEAR] = @GoalFiscalYear
and ID_NUMBER = @IdNumber

return @FacultyInteractionGoal;
end;