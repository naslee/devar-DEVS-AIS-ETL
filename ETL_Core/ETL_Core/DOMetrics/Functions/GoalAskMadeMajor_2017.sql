create function DOMetrics.GoalAskMadeMajor_2017
(
@GoalFiscalYear int, 
@IdNumber varchar(10)
)
RETURNS int
as
begin
declare @AskMadeMajorGoal int

select 
@AskMadeMajorGoal =  GOAL_3 
from AIS_Prod.ADVANCE.GOAL
where IS_ACTIVE = 1
and [YEAR] = @GoalFiscalYear
and ID_NUMBER = @IdNumber

return @AskMadeMajorGoal;
end;