create function DOMetrics.GoalAskMadeAnnualSpecial_2017
(
@GoalFiscalYear int, 
@IdNumber varchar(10)
)
RETURNS int
as
begin
declare @AskMadeAnnualSpecialGoal int

select 
@AskMadeAnnualSpecialGoal = GOAL_4 
from AIS_Prod.ADVANCE.GOAL
where IS_ACTIVE = 1
and [YEAR] = @GoalFiscalYear
and ID_NUMBER = @IdNumber

return @AskMadeAnnualSpecialGoal;
end;