



CREATE view [DOMetrics].[vPMRAssignedFaceToFace]
(
	AssignmentId,
	OfficerId,
	FiscalYear,
	UnitCode,
	ContactDate,
	AssignmentGUID,
	IsFaceToFace
)
as

select distinct AssignmentId, OfficerId, FiscalYear, UnitCode, AssignmentStart ContactDate, a.AssignmentGUID, isnull(isF2f,0) isF2F
from DOMetrics.vPMRAssigned a
	join 
		(
		select distinct 
				AUTHOR_ID_NUMBER
			, CONTACT_DATE
			, PROSPECT_ID
			, CONTACT_TYPE
			, DOMetrics.FaceToFace_2017(cr.REPORT_ID, cr.ID) isF2f
		from AIS_Prod.ADVANCE.CONTACT_REPORT cr
		where PROSPECT_ID is not null
			and cr.IS_ACTIVE = 1

		) gfe
	on  gfe.CONTACT_DATE  >= dateadd(day,dbo.ConfigurationGetIntValue('PAC','Start'), a.AssignmentStart)
	and gfe.CONTACT_DATE <= dateadd(day,dbo.ConfigurationGetIntValue('PAC','End'), a.AssignmentStart)
	and a.OfficerId = gfe.AUTHOR_ID_NUMBER
	and a.ProspectId = gfe.PROSPECT_ID
	and isF2f = 1