

create function DOMetrics.[GoalPMRAssigned_2017]
(
@GoalFiscalYear int, 
@IdNumber varchar(10)
)
RETURNS int
as
begin
declare @PMRAssignedGoal int

select @PMRAssignedGoal = count(*) over (partition by ASSIGNMENT_ID_NUMBER)
from AIS_Prod.ADVANCE.ASSIGNMENT a
 join AIS_Prod.dbo.UCDR_DATE_DIM d
  on a.START_DATE = d.DATE
where  
d.FISCALYEAR = @GoalFiscalYear
and a.IS_ACTIVE = 1
and a.PRIORITY_CODE = 'PQ'
and a.ASSIGNMENT_TYPE = 'LM'
and ASSIGNMENT_ID_NUMBER = @IdNumber
and a.START_DATE <= current_timestamp

return @PMRAssignedGoal;
end;