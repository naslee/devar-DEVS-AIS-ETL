



CREATE view [DOMetrics].[vPMRAssigned]
(
	  OfficerId
	, AssignmentId
	, ProspectId
	, UnitCode
	, FiscalYear
	, AssignmentStart
	, AssignmentEnd
	, AssignmentGUID
	, IsAssignmentActive
	, AssignmentTableId
	, AssignmentType
)

AS

SELECT DISTINCT
	  a.[ASSIGNMENT_ID_NUMBER]
	, a.[ASSIGNMENT_ID]
    , a.[PROSPECT_ID]
	, case when a.[UNIT_CODE] = ' ' then 'UCD' else a.[UNIT_CODE] end UNIT_CODE
	, d.[FISCALYEAR]
	, a.[START_DATE]
	, a.[STOP_DATE]
	, a.[ASSIGNMENT_GUID]
	, a.[ACTIVE_IND]
	, a.[ID]
	, a.[ASSIGNMENT_TYPE]

FROM AIS_Prod.ADVANCE.ASSIGNMENT a
	join AIS_Prod.dbo.UCDR_DATE_DIM d
		on a.[START_DATE] = d.[DATE]
where
	    a.[IS_ACTIVE] = 1
	and a.[ASSIGNMENT_TYPE] = 'LM'
	and a.[PRIORITY_CODE] = 'PQ'
	and a.[PROSPECT_ID] is not null