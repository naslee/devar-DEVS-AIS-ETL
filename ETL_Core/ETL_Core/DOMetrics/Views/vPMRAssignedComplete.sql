




CREATE view [DOMetrics].[vPMRAssignedComplete]
(
AssignmentId, OfficerId, FiscalYear, UnitCode, isFaceToFace, AssignmentGUID, ContactDate
)
as
	
	select distinct
		AssignmentId, OfficerId, FiscalYear, UnitCode, isFaceToFace, AssignmentGUID,  ContactDate
	--select *
	from
	(
	select AssignmentId, OfficerId, FiscalYear, UnitCode, isFaceToFace, AssignmentGUID,   ContactDate
	from (
			select distinct 
				  AssignmentId
				, a.OfficerId
				, count(distinct gfe.ContactType) ContactTypeCount
				, count(distinct gfe.ContactDate) ContactDateCount
				, a.FiscalYear
				, a.UnitCode
				, 0 isFaceToFace
				, a.AssignmentGUID
				--, max(gfe.ContactDate) ContactDate
				, AssignmentStart  ContactDate
			from DOMetrics.vPMRAssigned a
				join DOMetrics.vGoodFaithEffortContactReport gfe
					on  gfe.ContactDate  >= dateadd(day,dbo.ConfigurationGetIntValue('PAC','Start'), a.[AssignmentStart])
					and gfe.ContactDate <= dateadd(day,dbo.ConfigurationGetIntValue('PAC','End'), a.[AssignmentStart])
					and a.[OfficerId] = gfe.OfficerId
					and a.ProspectId = gfe.ProspectId

			group by AssignmentId, a.OfficerId,a.AssignmentGUID, a.FiscalYear, UnitCode, AssignmentStart
			) a
		where ContactTypeCount > 1
			and ContactDateCount > 5

	union

	--GOOD FAITH EFFORT - Face to Face contact report within 90 days of assignment
				select distinct AssignmentId, OfficerId, FiscalYear, UnitCode, isF2F, AssignmentGUID, AssignmentStart
			from DOMetrics.vPMRAssigned a
				join 
					(
					select distinct 
						  AUTHOR_ID_NUMBER
						, CONTACT_DATE
						, PROSPECT_ID
						, DOMetrics.FaceToFace_2017(cr.REPORT_ID, cr.ID) isF2F
					from AIS_Prod.ADVANCE.CONTACT_REPORT cr
					where PROSPECT_ID is not null
						and cr.IS_ACTIVE = 1
					) gfe
				on  gfe.CONTACT_DATE  >= dateadd(day,dbo.ConfigurationGetIntValue('PAC','Start'), a.AssignmentStart)
				and gfe.CONTACT_DATE <= dateadd(day,dbo.ConfigurationGetIntValue('PAC','End'), a.AssignmentStart)
				and a.OfficerId = gfe.AUTHOR_ID_NUMBER
				and a.ProspectId = gfe.PROSPECT_ID	
				and isF2F = 1	

	union


	-- GOOD FAITH EFFORT: Phone, correspondence/email, networking/social event, attempt to contact with a contact outcome
			select distinct AssignmentId, a.OfficerId , a.FiscalYear, UnitCode, 0 isFaceToFace, AssignmentGUID, AssignmentStart
			from DOMetrics.vPMRAssigned a
				join DOMetrics.vGoodFaithEffortContactReport gfe
				on      
						gfe.ContactDate >= dateadd(day,dbo.ConfigurationGetIntValue('PAC','Start'), a.AssignmentStart)
					and gfe.ContactDate <= dateadd(day,dbo.ConfigurationGetIntValue('PAC','End'), a.AssignmentStart)
					and a.OfficerId = gfe.OfficerId
					and a.ProspectId = gfe.ProspectId
			where gfe.ContactOutcome <> ' '
			
		) a
		where FiscalYear = DOMetrics.ConfigurationGetFiscalYear(current_timestamp)