create function DOMetrics.[GoalDollarsRaised_2017]
(
@GoalFiscalYear int, 
@IdNumber varchar(10)
)
RETURNS int
as
begin
declare @DollarsRaisedGoal int

select 
@DollarsRaisedGoal = GOAL_5 
from AIS_Prod.ADVANCE.GOAL
where IS_ACTIVE = 1
and [YEAR] = @GoalFiscalYear
and ID_NUMBER = @IdNumber

return @DollarsRaisedGoal;
end;