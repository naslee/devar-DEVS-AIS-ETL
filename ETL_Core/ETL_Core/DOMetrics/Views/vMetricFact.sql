



CREATE view [DOMetrics].[vMetricFact]
	(
		AuthorId,
		ArtifactId,
		DepartmentCode,
		FiscalYear,
		MetricType,
		MetricDate,
		DollarsRaised,
		DwSourceKey,
		MetricFactHash
	)
 as

select
	  authorId
	, reportId
	, u.unitCode
	, contactFiscalYear
	, convert(varchar(10),metricType) metricType
	, dateContacted
    , dollarsRaised
	, convert(varchar(36),crGuid)  dwSourceKey
	, checksum(concat(authorId, u.unitCode, metricType, dateContacted, dollarsRaised, convert(varchar(36),crGuid))) metricFactHash
	

from
(

	select 
		  reportId
		, crGuid
		, authorId
		, unitCode
		, dateContacted
		, 0 dollarsRaised
		, contactFiscalYear
		, isFI
		, 'FI' metricType
	from DOMetrics.vFacultyInteractionContactReports
	where isFI = 1

	union

	select 
		  AssignmentId reportId
		, AssignmentGUID
		, OfficerId AuthorId
		, UnitCode
		, AssignmentStart MetricDate
		, 0 DollarsRaised
		, FiscalYear
		, 1 isPmrAssigned
		, 'PA' MetricType

	from DOMetrics.vPMRAssigned

	union

	select 
		  AssignmentId reportId
		, AssignmentGUID
		, OfficerId AuthorId
		, UnitCode
		, ContactDate MetricDate
		, 0 DollarsRaised
		, FiscalYear
		, 1 isPmrAssignedComplete
		, 'PAC' MetricType

	from DOMetrics.vPMRAssignedComplete

	union

	select 
		  AssignmentId reportId
		, AssignmentGUID
		, OfficerId AuthorId
		, UnitCode
		, AssignmentStart
		, 0 DollarsRaised
		, FiscalYear
		, 1 isPmrAssignedComplete
		, 'PAM' MetricType

	from DOMetrics.vPMRAssignedMissed

	union

	select 
		  AssignmentId reportId
		, AssignmentGUID
		, OfficerId AuthorId
		, UnitCode
		, ContactDate MetricDate
		, 0 DollarsRaised
		, FiscalYear
		, 1 isPmrAssignedComplete
		, 'PAF2F' MetricType

	from DOMetrics.vPMRAssignedFaceToFace
	--where isFaceToFace = 1

	union

	select 
		  reportId
		, crGuid
		, authorId
		, unitCode
		, dateContacted
		, 0 dollarsRaised
		, contactFiscalYear
		, isAMAS
		, 'AMAS'
	from DOMetrics.vAskMadeAnnualSpecialContactReports
	where isAMAS = 1

	union

	select 
		  reportId
		, crGuid
		, authorId
		, unitCode
		, dateContacted
		, 0 dollarsRaised
		, contactFiscalYear
		, isAMM
		, 'AMM'
	from DOMetrics.vAskMadeMajorContactReports
	where isAMM = 1

	union

	select 
		  reportId
		, crGuid
		, authorId
		, unitCode
		, dateContacted
		, 0 dollarsRaised
		, contactFiscalYear
		, isComprehensiveAsk
		, 'CA'
	from DOMetrics.vComprehensiveAskContactReports
	where isComprehensiveAsk = 1
	
	union

	select 
		  reportId
		, crGuid
		, authorId
		, unitCode
		, dateContacted
		, 0 dollarsRaised
		, contactFiscalYear
		, isF2F
		, 'F2F'
	from DOMetrics.vFaceToFaceContactReports
	where isF2F = 1
	

	union

	select 
		  reportId
		, crGuid
		, authorId
		, unitCode
		, dateContacted
		, 0 dollarsRaised
		, contactFiscalYear
		, isF2FF
		, 'FM'
	from DOMetrics.vFaceToFaceFacilitatedContactReports
	where isF2FF = 1
	
	union
	
	select 
		  reportId
		, crGuid
		, authorId
		, unitCode
		, dateContacted
		, 0 dollarsRaised
		, contactFiscalYear
		, isF2FS
		, 'SM'
	from DOMetrics.vFaceToFaceSubstantiveContactReports
	where isF2FS = 1
	
	union 

	select 
		reportId,
		assignmentGuid,
		authorId,
		unitCode,
		dateContacted,
		dollarsRaised,
		fiscalYear,
		1,
		'DRM'
	from DOMetrics.vDollarsRaisedMajor

	union

	select 
		reportId,
		crGuid,
		authorId,
		unitCode,
		dateContacted,
		receivedAmount,
		contactFiscalYear,
		1,
		'DRAS'
	from DOMetrics.vDollarsRaisedAnnualSpecial
	where 
	
	isAskMadeAnnualSpecial = 1

	union 

	select distinct	
		  AssignmentId
		, AssignmentGUID
		, OfficerId
		, UnitCode
		, cr.CONTACT_DATE
		, 0
		, FiscalYear
		, 1
		, dbo.[ConfigurationGetCharValue](CONTACT_OUTCOME, 'QualType')
	from DOMetrics.vPMRAssigned pmra

	join AIS_Prod.ADVANCE.CONTACT_REPORT cr
		on cr.ID = DOMetrics.GetMaxQualifiedContactForAssignment(OfficerId, AssignmentId)

	union

	select distinct	
		  AssignmentId
		, AssignmentGUID
		, OfficerId
		, UnitCode
		, AssignmentStart
		, 0 dollarsRaised
		, FiscalYear
		, 1 isMetric
		, 'PACQNC'
	from DOMetrics.vPMRAssigned pmra
	where DOMetrics.GetMaxContactForAssignment(OfficerId, AssignmentId) is null

	union

	select distinct	
		  AssignmentId
		, AssignmentGUID
		, OfficerId
		, UnitCode
		, AssignmentStart
		, 0 dollarsRaised
		, FiscalYear
		, 1 isMetric
		, 'PACQNO'
	from DOMetrics.vPMRAssigned pmra
	where DOMetrics.GetMaxQualifiedContactForAssignment(OfficerId, AssignmentId) is null
	 and DOMetrics.GetMaxContactForAssignment(OfficerId, AssignmentId) is not null

) a

left outer join DOMetrics.vUnitFact   u
		on a.unitCode = u.unitCode
join DOMetrics.UserFact us
		on a.authorId = us.entityId 

where contactFiscalYear = DOMetrics.ConfigurationGetFiscalYear(current_timestamp)