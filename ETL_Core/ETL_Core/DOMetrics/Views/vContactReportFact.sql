/*
   @entityId			NVARCHAR(10),
	@unitCode			NVARCHAR(50),
	@fiscalYear			INT,
	@metricTypeCode		NVARCHAR(50),
	@dollarsRaised		FLOAT = NULL,
	@metricCreditDate	DATETIME,
	@dwSourceKey		UNIQUEIDENTIFIER,
	@dwTruthKey			UNIQUEIDENTIFIER,
	@metricId			UNIQUEIDENTIFIER OUTPUT
*/


CREATE view DOMetrics.vContactReportFact
(
authorId
, contactFiscalYear
, metricType
, dateContacted
, unitCode
, dwSourceKey
, dwTruthKey
)
as
select
	  authorId
	, contactFiscalYear
	, convert(nvarchar(10),metricType) metricType
	, dateContacted
	, unitCode
	, cast(crGuid as uniqueidentifier) dwSourceKey
	, cast(crGuid as uniqueidentifier) dwTruthKey

from
(

	select 
	  reportId
	, crGuid
	, authorId
	, dateContacted
	, unitCode
	, contactFiscalYear
	, isFI
	, 'FI' metricType
	from DOMetrics.vFacultyInteractionContactReports
	where isFI = 1

	union

	select 
	  reportId
	, crGuid
	, authorId
	, dateContacted
	, unitCode
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
	, dateContacted
	, unitCode
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
	, dateContacted
	, unitCode
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
	, dateContacted
	, unitCode
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
	, dateContacted
	, unitCode
	, contactFiscalYear
	, isF2FF
	, 'FM'
	from DOMetrics.vFaceToFaceFacilitatedContactReports
	where isF2FF = 1
) a

 --join [advbi-DO_Metrics].DO_Metrics.dbo.[User] us
	--	on us.EntityId = a.authorId collate database_default

--select *
--from [advbi-DO_Metrics].DO_Metrics.dbo.Unit