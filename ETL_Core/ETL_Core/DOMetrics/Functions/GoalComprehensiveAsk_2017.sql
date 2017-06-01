create function DOMetrics.GoalComprehensiveAsk_2017
(
@GoalFiscalYear int, 
@IdNumber varchar(10)
)
RETURNS int
as
begin
declare @ComprehensiveAskGoal int

select 
--@FaceToFaceGoal = GOAL_1
--@AskMadeMajorGoal =  GOAL_3 
--@AskMadeAnnualSpecialGoal = GOAL_4 
--@DollarsRaisedGoal = GOAL_5 
--@FacultyInteractionGoal = GOAL_6 
@ComprehensiveAskGoal = GOAL_7 
from AIS_Prod.ADVANCE.GOAL
where IS_ACTIVE = 1
and [YEAR] = @GoalFiscalYear
and ID_NUMBER = @IdNumber

return @ComprehensiveAskGoal;
end;