

CREATE view [DOMetrics].[vProspectExport]
(
--1 Prospect ID
	ProspectId
--2 Prospect Name
	,ProspectName
--3 Overall Stage
	,OverallStage
--4 Highest Capacity
	,HighestCapacity
--5 Principal Gift Prospect
	,IsPrincipalGiftProspect
--6 Chancellors Prospect
	,IsProspectChancellors
--7 Primary Entity ID
	,PrimaryEntityId
--8 PMR Assignment Start Date
	,PmrAssignmentStartDate
--9 DO has met good faith effort to contact this prospect (1 | 0)
	,MetPmrAssignedGoodFaithEffort
--10 DO has F2F w/in 90 days of PMR-Assign
	,MetPmrAssignedWithFaceToFace
--11 DO has Qual w/in 90 days of PMR-Assign
	,IsPmrAssignedQualified
--12 DO has Disqual/NN/NR w/in 90 days of PMR-Assign
	,IsPmrAssignedDisqualified
--12a DO has IP w/in 90 days of PMR-Assign
	,IsPmrAssignedInProgress
--13 Count of DO phone w/in 90 days of PMR-Assign
	,CountPmrAssignedPhoneContacts
--14 Count of DO corresp/email w/in 90 days of PMR-Assign
	,CountPmrAssignedEmailContacts
--15 Count of DO attempts w/in 90 days of PMR-Assign
	,CountPmrAssignedContactAttempts
--16 Count of DO net/soc event w/in 90 days of PMR-Assign
	,CountPmrAssignedSocialContacts
--17 Dev Officer Name
	,OfficerName
--18 Dev Officer Unit
	,Unit
--19 Dev officer Unit group
	,UnitGroup
--20 Prospect Sort Name
	,ProspectSortName
--21 Dev Officer ID
	,DevOfficerId
--22 Is DO Assigned to Prospect
	,IsProspectAssignedToOfficer
--23 Is DO Assigned to Prospect by PMR
	,IsDevOfficerPmrAssignedToProspect
--24 PMR Assignment Stop Date
	,PmrAssignmentStopDate
--25 PMR Assignment Active
	,IsPmrAssignmentActive
--26 Counts for PMR-Assigned Total
	,MeetsPmrAssigned
--27 Prospect Active
	,IsProspectActive
--28 DO's PMATS Assignment
	,OfficersProspectRole
--29 PMATS Assignment Start Date
	,PmatsAssignmentStartDate
--30 PMATS Assignment Stop Date
	,PmatsAssignmentStopDate
--31 PMATS Assignment Active
	,IsPmatsAssignmentActive
	,AssignmentGUID
	,FiscalYear
)

AS 

WITH 
prospects AS 
(
	select 
		  p.PROSPECT_ID ProspectId
		, p.PROSPECT_NAME ProspectName
		, dbo.GetTmsDescription('TX',p.STAGE_CODE) OverallStage
		, dbo.GetTmsDescription('TE',p.RATING_CODE) HighestCapacity
		, case 
			when p.CLASSIFICATION_CODE = 'T' 
			 then 1 
			else 0 
			 end IsPrincipalGiftProspect
		, case 
			when p.PROSPECT_GROUP_CODE = 'CP' 
			 then 1 
			else 0 
				end IsChancellorsProspect
		, p.ACTIVE_IND IsProspectActive
		, p.PROSPECT_NAME_SORT ProspectSortName
		                
	from AIS_Prod.ADVANCE.PROSPECT p
     
	where p.IS_ACTIVE=1
),
prospectAssignments as
(  
	select pmra.*, uf.firstName+' '+uf.lastName entityName
	from ETL_Core.DOMetrics.vPMRAssigned pmra
	left outer join ETL_Core.DOMetrics.vUserFact uf on pmra.OfficerId = uf.entityId
)

	select distinct
--1 Prospect ID
		pr.ProspectId
--2 Prospect Name
		,pr.ProspectName
--3 Overall Stage
		,pr.OverallStage
--4 Highest Capacity
		,pr.HighestCapacity
--5 Principal Gift Prospect
		,pr.IsPrincipalGiftProspect
--6 Chancellors Prospect
		,pr.IsChancellorsProspect
--7 Primary Entity ID
		,pe.ID_NUMBER PrimaryEntityId
--8 PMR Assignment Start Date
		,a.AssignmentStart PmrAssignmentStartDate
--9 DO has met good faith effort to contact this prospect (1 | 0)
		,case when pmrac.OfficerId is not null then 1 else 0 end MetPmrAssignedGoodFaithEffort
--10 DO has F2F w/in 90 days of PMR-Assign
		,isnull(pmrac.isFaceToFace,0) MetPmrAssignedWithFaceToFace
--11 DO has Qual w/in 90 days of PMR-Assign
		,case when ETL_Core.DOMetrics.GetMaxContactByOutcomeForAssignment(a.OfficerId,a.AssignmentId, 'QU') is not null then 1 else 0 end IsPmrAssignedQualified
--12 DO has Disqual/NN/NR w/in 90 days of PMR-Assign
		,case when ETL_Core.DOMetrics.GetMaxDisqualifiedContactForAssignment(a.OfficerId,a.AssignmentId) is not null then 1 else 0 end IsPmrAssignedDisqualified
--12a DO has IP w/in 90 days of PMR-Assign
		,case when ETL_Core.DOMetrics.GetMaxContactByOutcomeForAssignment(a.OfficerId,a.AssignmentId, 'IP') is not null then 1 else 0 end IsPmrAssignedInProgress
--13 Count of DO phone w/in 90 days of PMR-Assign
		,isnull(ETL_Core.DOMetrics.GetContactCountByAssignment(a.OfficerId,a.AssignmentTableId,'P'),0) CountPmrAssignedPhoneContacts
--14 Count of DO corresp/email w/in 90 days of PMR-Assign
		,isnull(ETL_Core.DOMetrics.GetContactCountByAssignment(a.OfficerId,a.AssignmentTableId,'C'),0) CountPmrAssignedEmailContacts
--15 Count of DO attempts w/in 90 days of PMR-Assign
		,isnull(ETL_Core.DOMetrics.GetContactCountByAssignment(a.OfficerId,a.AssignmentTableId,'1'),0) CountPmrAssignedContactAttempts
--16 Count of DO net/soc event w/in 90 days of PMR-Assign
		,isnull(ETL_Core.DOMetrics.GetContactCountByAssignment(a.OfficerId,a.AssignmentTableId,'E'),0) CountPmrAssignedSocialContacts
--17 Dev Officer Name
		,e.PREF_NAME_SORT DevOfficerName           
--18 Dev Officer Unit
		,suf.[name] DevOfficerUnit
--19 Dev officer Unit group
		,CASE WHEN spuf.[name] IS NULL THEN suf.[name] ELSE spuf.[name] END DevOfficerUnitGroup
--20 Prospect Sort Name
		,pr.ProspectSortName
--21 Dev Officer ID
		,a.OfficerId DevOfficerId
--22 Is DO Assigned to Prospect
		,dbo.IsDevOfficerAssignedToProspect(a.OfficerId, a.ProspectId) IsDevOfficerAssignedToProspect
--23 Is DO Assigned to Prospect by PMR
		,dbo.IsDevOfficerPmrAssignedToProspect(a.OfficerId, a.ProspectId) IsDevOfficerPmrAssignedToProspect
--24 PMR Assignment Stop Date
		,a.AssignmentEnd PmrAssignmentStopDate
--25 PMR Assignment Active
		,case when a.AssignmentId is not null then 1 else 0 end IsPMRAssignmentActive
--26 Counts for PMR-Assigned Total
		,count(isnull(pmrac.AssignmentId,0)) over (partition by a.ProspectId) MeetsPmrAssigned
--27 Prospect Active
		,pr.IsProspectActive
--28 DO's PMATS Assignment
		, dbo.GetTmsDescription('TI',a.AssignmentType)  OfficersProspectRole
--29 PMATS Assignment Start Date
		,a.AssignmentStart PmatsStartDate
--30 PMATS Assignment Stop Date
		,a.AssignmentEnd PmatsStopDate
--31 PMATS Assignment Active
		,case when a.AssignmentEnd is null and a.AssignmentStart is not null then 1 else 0 end IsPmatsAssignmentActive
		,a.AssignmentGUID
		,d.FiscalYear
	from prospectAssignments a
	inner join AIS_Prod.dbo.UCDR_DATE_DIM d
		on d.[DATE] = a.AssignmentStart
	inner join AIS_Prod.ADVANCE.ENTITY e
		on e.ID_NUMBER = a.OfficerId
		and e.IS_ACTIVE = 1
	inner join prospects pr 
		on a.ProspectId = pr.ProspectId
	inner join AIS_Prod.ADVANCE.PROSPECT_ENTITY pe
		on pr.ProspectId = pe.PROSPECT_ID 
			AND pe.PRIMARY_IND = 'Y'
			AND pe.IS_ACTIVE = 1
	left outer join ETL_Core.DOMetrics.vPMRAssignedComplete pmrac 
		on a.AssignmentGUID = pmrac.AssignmentGUID and a.OfficerId = pmrac.OfficerId
	left outer join AIS_Prod.ADVANCE.STAFF s
		on s.ID_NUMBER = a.OfficerId
		and s.IS_ACTIVE = 1
	left outer join DOMetrics.vUnitFact suf
		on suf.unitCode = s.UNIT_CODE
	left outer join DOMetrics.vUnitFact spuf
		on suf.parentUnitCode = spuf.unitCode
	
where d.FiscalYear = DOMetrics.ConfigurationGetFiscalYear(current_timestamp)