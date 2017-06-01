



CREATE view [DOMetrics].[vDollarsRaisedAnnualSpecial]
(
  reportId
, crGuid
, authorId
, unitCode
, dateContacted
, receivedAmount
, contactFiscalYear
, isAskMadeAnnualSpecial
)

as

select distinct 
	REPORT_ID reportId
	, CONTACT_REPORT_GUID crGuid
	, AUTHOR_ID_NUMBER authorId
	, UNIT_CODE
	, convert(datetime,REP_NAME) dateContacted
	, convert(money,REP_COMMENT) ReceivedAmount
	, FISCALYEAR contactFiscalYear
	, IsAskMadeAnnualSpecial
from
(
select cr.*, ETL_Core.DOMetrics.AskMadeAnnualSpecial_2017(cr.REPORT_ID, cr.ID) IsAskMadeAnnualSpecial, d.FISCALYEAR
from AIS_Prod.ADVANCE.CONTACT_REPORT cr
	join AIS_Prod.dbo.UCDR_DATE_DIM d
		on d.[DATE] = convert(date,REP_NAME)
where cr.IS_ACTIVE = 1
	AND (cr.REP_NAME IS NOT NULL AND LTRIM(RTRIM(cr.REP_NAME)) <> '')
	) a