

CREATE view [DOMetrics].[vProposalExport]
(
--1	Proposal ID
	ProposalId
--2	Solicitation Approval Status
	,SolicitationApprovalStatus
--3	Counts for Major Gift $ Raised Total
	,MeetsDollarsRaisedMajor 
--4	Title/Purpose
	,ProposalTitle
--5	Proposal Ask Amount
	,ProposalAskAmount
--6	Proposal Ask Date
	,ProposalAskDate
--7	Proposal Stage
	,ProposalStage
--8	Proposal Received Amount
	,ProposalReceivedAmount
--9	Proposal Close Date
	,ProposalCloseDate
--10 DO's Proposal Assignment
	,DoRoleProposalAssignment
--11 Proposal Assignment Active
	,IsProposalAssignmentActive
--12 AMM Contact Report ID
	,AMMContactReportId
--13 Date of AMM Contact
	,AMMContactDate
--14 Author Name
	,ContactAuthorName
--15 Prospect ID
	,ProspectId
--16 Primary Entity ID
	,PrimaryEntityId
--17 Prospect Name
	,ProspectName
--18 Overall Stage
	,OverallStage
--19 Highest Capacity
	,HighestCapacity
--20 Principal Gift Prospect
	,IsPrincipalGiftProspect
--21 Chancellor's Prospect
	,IsChancellorsProspect
--22 DO's PMATS Assignment
	,OfficersProspectRole
--23 PMATS Assignment Active
	,IsPmatsAssignmentActive
--24 Is DO Assigned to Prospect by PMR
	,IsDevOfficerPmrAssignedToProspect
--25 Dev Officer Name
	,DevOfficerName
--26 Dev Officer Unit
	,DevOfficerUnit
--27 Dev officer unit group
	,DevOfficerUnitGroup
--28 Prospect Sort Name
	,ProspectSortName
--29 Dev Officer ID
	,DevOfficerId
--30 Is DO Assigned to Prospect
	,IsDevOfficerAssignedToProspect
--31 PMR Assignment Start Date
	,PmrAssignmentStartDate
--32 PMR Assignment Stop Date
	,PmrAssignmentStopDate
--33 PMR Assignment Active
	,IsPMRAssignmentActive
--34 Is DO Assigned to Proposal
	,IsDevOfficerAssignedToProposal
--35 Prospect Active
	,IsProspectActive
--36 PMATS Assignment Start Date
	,PmatsStartDate
--37 PMATS Assignment Stop Date
	,PmatsStopDate
--38 Approval Date
	,ProposalApprovalDate
--39 Proposal Comment
	,ProposalComment
--40 Proposal Assignment Start Date
	,ProposalAssignmentStartDate
--41 Proposal Assignment Stop Date
	,ProposalAssignmentStopDate
--42 Author ID
	,ContactAuthorId
--43 Contacted Entity ID
	,ContactedEntityId
--44 Name
	,ContactedEntityName
--45 Sort Name
	,ContactedSortName
--46 Contact Report Added
	,ContactReportAdded
--47 Contact Type
	,ContactTypeDesc
--48 Contact Purpose
	,ContactPurposeDesc
--49 Other Contact Type
	,OtherContactTypeDesc
--50 MG Qualified
	,MajorGiftQualified
--51 CR Description
	,ContactDesc
--52 Comprehensive Ask
	,ComprehensiveAsk
--53 CR Ask Amount
	,AskAmount
--54 CR Audit Status
	,ContactReportAuditStatus
--55 CR Audit Date
	,ContactReportReviewDate
	,AssignmentGUID
	,ProposalGUID
	,FiscalYear
)

as

with 
firstAMM as (
select distinct AMMId from 
(
select cr.ID AMMId

	, ROW_NUMBER() OVER (PARTITION BY cr.PROPOSAL_ID ORDER BY cr.CONTACT_DATE ASC) rownum
from  DOMetrics.vAskMadeMajorContactReports amm
	
	inner join AIS_Prod.ADVANCE.CONTACT_REPORT cr
		on amm.proposalId = cr.PROPOSAL_ID 
		and cr.REPORT_ID = amm.reportId
		and amm.isAMM = 1
) x
where rownum = 1
)
, contactReportsAMM as (
select distinct cr2.REPORT_ID AMMContactReportId
	, cr2.CONTACT_DATE AMMContactDate
	, cr2.AUTHOR_ID_NUMBER ContactAuthorId
	, e.PREF_MAIL_NAME ContactAuthorName
	, cr2.PROPOSAL_ID ProposalId
	, dbo.GetTmsDescription('V1',cr2.CONTACT_TYPE) ContactTypeDesc
	, dbo.GetTmsDescription('V2',cr2.CONTACT_PURPOSE_CODE) ContactPurposeDesc
	, dbo.GetTmsDescription('UE',cr2.CONTACT_INITIATED_BY) OtherContactTypeDesc
	, dbo.GetTmsDescription('UD',cr2.CONTACT_OUTCOME) MajorGiftQualified
	, cr2.REP_TYPE_CODE ComprehensiveAsk
	, cr2.CONTACTED_COMMENT AskAmount
	, cr2.DESCRIPTION ContactDesc
	, dbo.GetTmsDescription('W2',cr2.REVIEW_STATUS_CODE) ContactReportAuditStatus
	, cr2.REVIEW_DATE ContactReportReviewDate
	, cr2.DATE_ADDED ContactReportAdded
	, cr2.ID_NUMBER ContactedEntityId
	, cr2.CONTACT_REPORT_GUID
	, e2.PREF_MAIL_NAME ContactedEntityName
	, e2.PREF_NAME_SORT ContactedSortName

from firstAMM fa

	inner join AIS_Prod.ADVANCE.CONTACT_REPORT cr2
		on fa.AMMId = cr2.ID

	inner join AIS_Prod.ADVANCE.ENTITY e
		on cr2.AUTHOR_ID_NUMBER = e.ID_NUMBER 
		and e.IS_ACTIVE = 1

	inner join AIS_Prod.ADVANCE.ENTITY e2
		on cr2.ID_NUMBER = e2.ID_NUMBER 
		and e2.IS_ACTIVE = 1
)
, 
proposals as
(
	select 
		  pl.PROPOSAL_ID ProposalId
		,dbo.GetTmsDescription('TN',pl.PROPOSAL_TYPE) SolicitationApprovalStatus
		,dbo.GetTmsDescription('TX',pl.STAGE_CODE) ProposalStage
		,pl.PROPOSAL_TITLE ProposalTitle
		,pl.[START_DATE] ProposalApprovalDate
		,replace(replace(pl.DESCRIPTION, char(10),''),char(13),'') ProposalComment /*strip carriage return line feed*/
		,pl.PROPOSAL_TYPE
		,pl.ASK_AMT ProposalAskAmount
		,pl.INITIAL_CONTRIBUTION_DATE ProposalAskDate
		,pl.GRANTED_AMT ProposalReceivedAmount
		,drm.dateContacted ProposalCloseDate
		,drm.assignmentGuid ProposalGuid
	from AIS_Prod.ADVANCE.PROPOSAL pl
		inner join [ETL_Core].[DOMetrics].[vDollarsRaisedMajor] drm
		on pl.PROPOSAL_ID = drm.reportId		
	where pl.IS_ACTIVE=1		
),
pmrAssignments as
(  
	select pmra.*
	from ETL_Core.DOMetrics.vPMRAssigned pmra
	where pmra.FiscalYear >=  2017 --Fiscal year intentionally hard-coded to serve as baseline fiscal year
),
proposalAssignments as
(  
SELECT DISTINCT
	  a.[ASSIGNMENT_ID_NUMBER] OfficerId
	, a.[ASSIGNMENT_ID] AssignmentId
    , a.[PROPOSAL_ID] ProposalId
	, a.PROSPECT_ID ProspectId
	, case when a.[UNIT_CODE] = ' ' then 'UCD' else a.[UNIT_CODE] end UnitCode
	, a.[START_DATE] ProposalAssignmentStartDate
	, a.[STOP_DATE] ProposalAssignmentStopDate
	, a.[ASSIGNMENT_GUID] AssignmentGUID
	, a.[ACTIVE_IND] IsProposalAssignmentActive
	, a.[ASSIGNMENT_TYPE] AssignmentType
	, dbo.GetTmsDescription('TI',a.ASSIGNMENT_TYPE) DoRoleProposalAssignment
FROM AIS_Prod.ADVANCE.ASSIGNMENT a
	inner join [ETL_Core].[DOMetrics].[vDollarsRaisedMajor] drm
		on a.PROPOSAL_ID = drm.reportId
		and a.ASSIGNMENT_ID_NUMBER = drm.authorId
where
	a.[IS_ACTIVE] = 1
	and a.[ACTIVE_IND] = 'Y'
	and a.PROPOSAL_ID is not null
)
,
prospectAssignments as
(  
	SELECT * FROM 
	(
		SELECT
			  a2.[ASSIGNMENT_ID_NUMBER] OfficerId
			, a2.[ASSIGNMENT_ID] AssignmentId
			, a2.[PROPOSAL_ID] ProposalId
			, a2.[PROSPECT_ID] ProspectId
			, case when a2.[UNIT_CODE] = ' ' then 'UCD' else a2.[UNIT_CODE] end UnitCode
			, a2.[START_DATE] ProspectAssignmentStartDate
			, a2.[STOP_DATE] ProspectAssignmentStopDate
			, a2.[ASSIGNMENT_GUID] AssignmentGUID
			, a2.[ACTIVE_IND] IsProspectAssignmentActive
			, a2.[ASSIGNMENT_TYPE] AssignmentType
			, dbo.GetTmsDescription('TI',a2.ASSIGNMENT_TYPE) DoRoleProspectAssignment
			, ROW_NUMBER() OVER (PARTITION BY a2.[PROSPECT_ID], a2.[ASSIGNMENT_ID_NUMBER] ORDER BY a2.[START_DATE] DESC) rownum
		FROM AIS_Prod.ADVANCE.ASSIGNMENT a1			 
			inner join [ETL_Core].[DOMetrics].[vDollarsRaisedMajor] drm
				on a1.PROPOSAL_ID = drm.reportId
				and a1.ASSIGNMENT_ID_NUMBER = drm.authorId
			inner join AIS_Prod.ADVANCE.ASSIGNMENT a2
				on a2.PROSPECT_ID = a1.PROSPECT_ID
				and a2.ASSIGNMENT_ID_NUMBER = a1.ASSIGNMENT_ID_NUMBER
		where
			a1.[IS_ACTIVE] = 1 and a2.[IS_ACTIVE] = 1
			and a1.[ACTIVE_IND] = 'Y' and a2.[ACTIVE_IND] = 'Y'
			and a2.[PROPOSAL_ID] is null
	) a
	WHERE a.rownum = 1
)
,
prospects as 
(
	select DISTINCT
		  pr.PROSPECT_ID ProspectId
		, pr.PROSPECT_NAME ProspectName
		, dbo.GetTmsDescription('TX',pr.STAGE_CODE) OverallStage
		, dbo.GetTmsDescription('TE',pr.RATING_CODE) HighestCapacity
		, case 
			when pr.CLASSIFICATION_CODE = 'T' 
			 then 1 
			else 0 
			 end IsPrincipalGiftProspect
		, case 
			when pr.PROSPECT_GROUP_CODE = 'CP' 
			 then 1 
			else 0 
				end IsChancellorsProspect
		, pr.ACTIVE_IND IsProspectActive
		, pr.PROSPECT_NAME_SORT ProspectSortName
		, pe.ID_NUMBER PrimaryEntityId
	from [DEVS-AIS-ODS.OU.AD3.UCDAVIS.EDU].AIS_Prod.ADVANCE.PROSPECT pr
		left outer join [DEVS-AIS-ODS.OU.AD3.UCDAVIS.EDU].AIS_Prod.ADVANCE.PROSPECT_ENTITY pe
			on pr.PROSPECT_ID = pe.PROSPECT_ID
	where pr.IS_ACTIVE=1 and pe.PRIMARY_IND = 'Y' and pe.IS_ACTIVE = 1
)

select DISTINCT
--1	Proposal ID
	pl.ProposalId
--2	Solicitation Approval Status
	,pl.SolicitationApprovalStatus
--3	Counts for Major Gift $ Raised Total
	--, case when dras.assignmentGuid is not null then 1 else 0 end MeetsDollarsRaisedMajor
	,1 MeetsDollarsRaisedMajor  -- come back
--4	Title/Purpose
	,pl.ProposalTitle
--5	Proposal Ask Amount
	,pl.ProposalAskAmount
--6	Proposal Ask Date
	,pl.ProposalAskDate
--7	Proposal Stage
	,pl.ProposalStage
--8	Proposal Received Amount
	,pl.ProposalReceivedAmount
--9	Proposal Close Date
	,pl.ProposalCloseDate
--10 DO's Proposal Assignment
	,pla.DoRoleProposalAssignment
--11 Proposal Assignment Active
	,pla.IsProposalAssignmentActive
--12 AMM Contact Report ID
	,cr.AMMContactReportId
--13 Date of AMM Contact
	,cr.AMMContactDate
--14 Author Name
	,cr.ContactAuthorName
--15 Prospect ID
	,pr.ProspectId
--16 Primary Entity ID
	,pr.PrimaryEntityId
--17 Prospect Name
	,pr.ProspectName
--18 Overall Stage
	,pr.OverallStage
--19 Highest Capacity
	,pr.HighestCapacity
--20 Principal Gift Prospect
	,pr.IsPrincipalGiftProspect
--21 Chancellor's Prospect
	,pr.IsChancellorsProspect
--22 DO's PMATS Assignment
	,pra.DoRoleProspectAssignment OfficersProspectRole
--23 PMATS Assignment Active
	,case when pra.ProspectAssignmentStopDate is null and pra.ProspectAssignmentStartDate is not null then 1 else 0 end IsPmatsAssignmentActive
--24 Is DO Assigned to Prospect by PMR
	,case when pmra.AssignmentId is not null then 1 else 0 end  IsDevOfficerPmrAssignedToProspect
--25 Dev Officer Name
	,s.[NAME] DevOfficerName
--26 Dev Officer Unit
	,suf.[name] DevOfficerUnit
--27 Dev officer unit group
	,spuf.[name] DevOfficerUnitGroup
--28 Prospect Sort Name
	,pr.ProspectSortName
--29 Dev Officer ID
	,pla.OfficerId DevOfficerId
--30 Is DO Assigned to Prospect
	,case when pra.AssignmentId is not null then 1 else 0 end  IsDevOfficerAssignedToProspect
--31 PMR Assignment Start Date
	,pmra.AssignmentStart PmrAssignmentStartDate
--32 PMR Assignment Stop Date
	,pmra.AssignmentEnd PmrAssignmentStopDate
--33 PMR Assignment Active
	,case when pmra.AssignmentId is not null then 1 else 0 end IsPMRAssignmentActive
--34 Is DO Assigned to Proposal
	,case when pla.AssignmentId is not null then 1 else 0 end  IsDevOfficerAssignedToProposal
--35 Prospect Active
	,pr.IsProspectActive
--36 PMATS Assignment Start Date
	,pra.ProspectAssignmentStartDate PmatsStartDate
--37 PMATS Assignment Stop Date
	,pra.ProspectAssignmentStopDate PmatsStopDate
--38 Approval Date
	,pl.ProposalApprovalDate
--39 Proposal Comment
	,pl.ProposalComment
--40 Proposal Assignment Start Date
	,pla.ProposalAssignmentStartDate
--41 Proposal Assignment Stop Date
	,pla.ProposalAssignmentStopDate
--42 Author ID
	,cr.ContactAuthorId
--43 Contacted Entity ID
	,cr.ContactedEntityId
--44 Name
	,cr.ContactedEntityName
--45 Sort Name
	,cr.ContactedSortName
--46 Contact Report Added
	,cr.ContactReportAdded
--47 Contact Type
	,cr.ContactTypeDesc
--48 Contact Purpose
	,cr.ContactPurposeDesc
--49 Other Contact Type
	,cr.OtherContactTypeDesc
--50 MG Qualified
	,cr.MajorGiftQualified
--51 CR Description
	,cr.ContactDesc
--52 Comprehensive Ask
	,cr.ComprehensiveAsk
--53 CR Ask Amount
	,cr.AskAmount
--54 CR Audit Status
	,cr.ContactReportAuditStatus
--55 CR Audit Date
	,cr.ContactReportReviewDate
	,pla.AssignmentGUID
	,pl.ProposalGuid
	,d.FiscalYear

from proposalAssignments pla
	inner join proposals pl
		on pla.ProposalId = pl.ProposalId
	inner join AIS_Prod.dbo.UCDR_DATE_DIM d
		on d.[DATE] = CAST(pl.ProposalCloseDate AS DATE)	
	left outer join prospects pr
		on pla.ProspectId = pr.ProspectId
	join contactReportsAMM cr
		on pla.ProposalId = cr.ProposalId
	left outer join prospectAssignments pra
		on pla.ProspectId = pra.ProspectId 
			and pla.OfficerId = pra.OfficerId
	left outer join pmrAssignments pmra
		on pla.ProspectId = pmra.ProspectId and pla.OfficerId = pmra.OfficerId
	left outer join AIS_Prod.ADVANCE.STAFF s
		on s.ID_NUMBER = pla.OfficerId
		and s.IS_ACTIVE = 1
	left outer join DOMetrics.vUnitFact suf
		on suf.unitCode = s.UNIT_CODE
	left outer join DOMetrics.vUnitFact spuf
		on suf.parentUnitCode = spuf.unitCode

where d.FISCALYEAR = DOMetrics.ConfigurationGetFiscalYear(current_timestamp)