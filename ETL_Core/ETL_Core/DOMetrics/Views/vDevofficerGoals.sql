create view DOMetrics.vDevofficerGoals
(
	  entityId
	, unitId
	, metricTypeId
	, fiscalYear
	, goal
	, startDate
	, endDate
	, createUserId
	, UnitId
)
as

select 
a.entityId, s.UNIT_CODE unitId, mt.MetricTypeId  metricTypeId, 2017 fiscalYear, a.goal, convert(date,'2016-07-01') startDate, convert(date,'2017-06-30') endDate, 140 createUserid, u.UnitId

from
(
	select uf.*, isnull(DOMetrics.GoalFaceToFace_2017(2017, entityId),0) goal, 'F2F' metricTypeId
	from DOMetrics.UserFact uf
		
	where userTypeCode = 'DEVOFFICER'
	
	union

	select uf.*, isnull(DOMetrics.GoalAskMadeAnnualSpecial_2017(2017, entityId),0), 'AMAS'
	from DOMetrics.UserFact uf
	where userTypeCode = 'DEVOFFICER'

	union

	select uf.*, isnull(DOMetrics.GoalAskMadeMajor_2017(2017, entityId),0), 'AMM'
	from DOMetrics.UserFact uf
	where userTypeCode = 'DEVOFFICER'

	union

	select uf.*, isnull(DOMetrics.GoalComprehensiveAsk_2017(2017, entityId),0), 'CA'
	from DOMetrics.UserFact uf
	where userTypeCode = 'DEVOFFICER'

	union

	select uf.*, isnull(DOMetrics.GoalDollarsRaised_2017(2017, entityId),0), 'DR'
	from DOMetrics.UserFact uf
	where userTypeCode = 'DEVOFFICER'

	union

	select uf.*, isnull(DOMetrics.GoalPMRAssigned_2017(2017, entityId),0), 'PA'
	from DOMetrics.UserFact uf
	where userTypeCode = 'DEVOFFICER'

	union

	select uf.*, isnull(DOMetrics.GoalFacultyInteraction_2017(2017, entityId),0), 'FI'
	from DOMetrics.UserFact uf
	where userTypeCode = 'DEVOFFICER'
) a
 join AIS_Prod.ADVANCE.STAFF s
	on a.entityId = s.ID_NUMBER
	and s.IS_ACTIVE = 1

 join [advbi-DO_Metrics].DO_Metrics.dbo.Unit   u
		on s.UNIT_CODE = u.Code collate database_default

join [advbi-DO_Metrics].DO_Metrics.dbo.MetricType mt
	on mt.Code = a.metricTypeId collate database_default