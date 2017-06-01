CREATE view DOMetrics.vFaceToFaceContactReports
(
  reportId
, crGuid
, authorId
, dateContacted
, unitCode
, contactFiscalYear
, isF2F
)

as


SELECT 	
 REPORT_ID reportId
, CONTACT_REPORT_GUID crGuid
, cr.AUTHOR_ID_NUMBER authorId
, cr.CONTACT_DATE dateContacted
, cr.UNIT_CODE unitCode
, d.FISCALYEAR contactFiscalYear
, isnull(ETL_Core.DOMetrics.FaceToFace_2017(cr.REPORT_ID,cr.ID),0) IsF2F
					FROM AIS_Prod.ADVANCE.CONTACT_REPORT cr
					JOIN AIS_Prod.dbo.UCDR_DATE_DIM d
						on cr.CONTACT_DATE = d.[DATE] 
					WHERE
					   cr.IS_ACTIVE = 1