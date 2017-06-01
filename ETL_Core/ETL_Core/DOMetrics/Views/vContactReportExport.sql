
CREATE view [DOMetrics].[vContactReportExport]
(
	ReportId,
	ContactDate,
	DateAdded,
	ContactType,
	ContactPurpose,
	OtherContactType,
	ContactDescription,
	MajorGiftQualified,
	ComprehensiveAsk,
	AskAmount,
	ResultOfAsk,
	ReceivedAmount,
	DateGiftBooked,
	ContactedEntityId,
	ContactedName,
	ProspectId,
	ProspectName,
	OverallStage,
	HighestCapacity,
	IsPrincipalGiftProspect,
	IsChancellorsProspect,
	IsDevOfficerAssignedToProspect,
	IsDevOfficerPmrAssignedToProspect,
	ProposalId,
	SolicitationApprovalStatus,
	ProposalStage,
	ProposalTitle,
	IsDevOfficerAssignedToProposal,
	DevOfficerName, 
	DevOfficerUnit, 
	DevOfficerUnitGroup,
	ContactReportUnit,
	ContactReportUnitGroup, 
	ContactedSortName,
	DevOfficerId,
	PmrAssignmentStartDate,
	PmrAssignmentStopDate,
	AuthorName,
	AuthorId,
	IsProspectActive,
	AssignmentType,
	PmatsStartDate,
	PmatsStopDate,
	IsAssignmentActive,
	ProposalApprovalDate,
	ProposalComment,
	ContactReportAuditStatus,
	ContactReportReviewDate,
	ContactReportGUID,
	FiscalYear,
	IsFaceToFace,
	IsAskMadeMajor,
	IsAskMadeAnnualSpecial,
	IsDollarsRaisedAnnual,
	IsComprehensiveAsk,
	IsFacultyInteraction,
	ProspectSortName
)

as

with 
contactReports as
(
	select 
		  cr.REPORT_ID ReportId
		, cr.CONTACT_DATE ContactDate
		, cr.DATE_ADDED DateAdded
		, dbo.GetTmsDescription('V1',cr.CONTACT_TYPE) ContactType
		, dbo.GetTmsDescription('V2',cr.CONTACT_PURPOSE_CODE) ContactPurpose
		, dbo.GetTmsDescription('UE',cr.CONTACT_INITIATED_BY) OtherContactType
		, cr.[DESCRIPTION] ContactDescription
		, dbo.GetTmsDescription('UD',cr.CONTACT_OUTCOME) MajorGiftQualified
		, cr.REP_TYPE_CODE ComprehensiveAsk
		, cr.CONTACTED_COMMENT AskAmount
		, dbo.GetTmsDescription('UB',cr.CONTACT_ATTITUDE) ResultOfAsk
		, cr.REP_COMMENT ReceivedAmount
		, cr.REP_NAME DateGiftBooked
		, cr.AUTHOR_ID_NUMBER AuthorId
		, cr.ID_NUMBER ContactedEntityId
		, cr.CONTACTED_NAME ContactedName
		, cr.PROSPECT_ID ProspectId
		, cr.PROPOSAL_ID ProposalId
		, cr.CONTACTED_SORT_NAME ContactedSortName
		, cr.AUTHOR_ID_NUMBER DevOfficerId
		, dbo.GetTmsDescription('W2',cr.REVIEW_STATUS_CODE) ContactReportAuditStatus
		, cr.REVIEW_DATE ContactReportReviewDate
		, cr.CONTACT_REPORT_GUID ContactReportGUID
		, isnull(DOMetrics.FaceToFace_2017(cr.REPORT_ID, cr.ID),0) isFaceToFace
		, isnull(DOMetrics.AskMadeMajor_2017(cr.REPORT_ID, cr.ID),0) isAskMadeMajor
		, isnull(DOMetrics.AskMadeAnnualSpecial_2017(cr.REPORT_ID, cr.ID),0) isAskMadeAnnualSpecial
		, case when dras.crGuid is not null then 1 else 0 end isDollarsRaisedAnnual
		, isnull(DOMetrics.ComprehensiveAsk_2017(cr.REPORT_ID, cr.ID),0) isComprehensiveAsk
		, isnull(DOMetrics.FacultyInteraction_2017(cr.REPORT_ID, cr.ID),0) isFacultyInteraction
		, cr.UNIT_CODE unitCode
		, CASE
			WHEN dras.reportId IS NOT NULL
				THEN convert(date,dras.dateContacted)
			ELSE
				null
		  END DollarsRaisedDate


	from AIS_Prod.ADVANCE.CONTACT_REPORT cr
		left outer join DOMetrics.vDollarsRaisedAnnualSpecial dras
			on dras.crGuid = cr.CONTACT_REPORT_GUID
			and dras.isAskMadeAnnualSpecial = 1
			and dras.receivedAmount > 0 
    
	where cr.IS_ACTIVE=1
	   
),

prospects as 
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
		, p.PROSPECT_NAME_SORT
		                
	from AIS_Prod.ADVANCE.PROSPECT p
     
	where p.IS_ACTIVE=1
),

proposals as
(
	select 
		  pr.PROPOSAL_ID ProposalId
		, dbo.GetTmsDescription('TN',pr.PROPOSAL_TYPE) SolicitationApprovalStatus
		, dbo.GetTmsDescription('TX',pr.STAGE_CODE) ProposalStage
		, pr.PROPOSAL_TITLE ProposalTitle
		, pr.[START_DATE] ProposalApprovalDate
		, replace(replace(pr.DESCRIPTION, char(10),''),char(13),'') ProposalComment /*strip carriage return line feed*/

	from AIS_Prod.ADVANCE.PROPOSAL pr
	 
	where pr.IS_ACTIVE=1
),

allProspectAssignments as
(  
	 select 
		  ProspectId
		, PmatsStartDate
		, PmatsStopDate
		, DevOfficerIdNumber
		, AssignmentType
		, IsAssignmentActive
		, IsPmrAssigned
		, PmrAssignmentStartDate
		, PmrAssignmentStopDate
	 from
	 (
		select 
			  a.PROSPECT_ID ProspectId
			, a.[START_DATE] PmatsStartDate
			, a.STOP_DATE PmatsStopDate
			, a.ASSIGNMENT_ID_NUMBER DevOfficerIdNumber
			, dbo.GetTmsDescription('TI',a.ASSIGNMENT_TYPE) AssignmentType
			, a.ACTIVE_IND IsAssignmentActive
			, case 
				when a.PRIORITY_CODE = 'PQ' 
				  and a.ASSIGNMENT_TYPE = 'LM' 
				 then 1 
				 else 0 
			   end IsPmrAssigned
			, case 
				when a.PRIORITY_CODE = 'PQ' 
				  and a.ASSIGNMENT_TYPE = 'LM' 
				 then a.[START_DATE] 
				 else null 
			   end PmrAssignmentStartDate
			, case 
				when a.PRIORITY_CODE = 'PQ' 
				  and a.ASSIGNMENT_TYPE = 'LM' 
				 then a.STOP_DATE 
				 else null 
				end PmrAssignmentStopDate
			, case 
				when a.PRIORITY_CODE = 'PQ' 
				  and a.ASSIGNMENT_TYPE = 'LM' 
				 then a.ACTIVE_IND 
				 else null 
				end IsPmrAssignmentActive -- is there a function available for 'isPMRAssigned?
			,	rank() over (partition by a.PROSPECT_ID, a.ASSIGNMENT_ID_NUMBER order by a.[START_DATE] desc, case when a.[STOP_DATE] is null then 1 else 0 end DESC) assignmentRank

			from AIS_Prod.ADVANCE.ASSIGNMENT a
				 where a.IS_ACTIVE=1
				 and a.PROPOSAL_ID is null 
				 and a.PROSPECT_ID is not null /*prospect assignments only */
	) a
	where assignmentRank = 1
)


 
select 
	  ReportId
	, ContactDate
	, DateAdded
	, ContactType
	, ContactPurpose
	, OtherContactType
	, ContactDescription
	, MajorGiftQualified
	, ComprehensiveAsk
	, AskAmount
	, ResultOfAsk
	, ReceivedAmount
	, DateGiftBooked
	, ContactedEntityId
	, ContactedName
	, ProspectId
	, ProspectName
	, OverallStage
	, HighestCapacity
	, IsPrincipalGiftProspect
	, IsChancellorsProspect
	, is_dev_officer_assigned_to_prospect
	, is_dev_officer_pmr_assigned_to_prospect
	, ProposalId
	, SolicitationApprovalStatus
	, ProposalStage
	, ProposalTitle
	, IsDevOfficerAssignedToProposal
	, dev_officer_name
	, DevOfficerUnit
	, DevOfficerUnitGroup--dev officer unit group
	, ContactReportUnit 
	, ContactReportUnitGroup
	, ContactedSortName
	, author_id
	, PmrAssignmentStartDate
	, PmrAssignmentStopDate
	, author_name
	, author_id
	, IsProspectActive
	, authors_pmats_assignment
	, PmatsStartDate
	, PmatsStopDate
	, IsAssignmentActive
	, ProposalApprovalDate
	, ProposalComment
	, ContactReportAuditStatus
	, ContactReportReviewDate
	, ContactReportGUID
	, FiscalYear
	, isFaceToFace
	, isAskMadeMajor
	, isAskMadeAnnualSpecial
	, isDollarsRaisedAnnual
	, isComprehensiveAsk
	, isFacultyInteraction
	--, DollarsRaisedDate
	, ProspectSortName
	from
		(
			select 
				cr.ReportId,
				cr.ContactDate,
				cr.DateAdded,
				cr.ContactType,
				cr.ContactPurpose,
				cr.OtherContactType,
				cr.ContactDescription,
				cr.MajorGiftQualified,
				cr.ComprehensiveAsk,
				cr.AskAmount,
				cr.ResultOfAsk,
				cr.ReceivedAmount,
				cr.DateGiftBooked,
				cr.ContactedEntityId,
				cr.ContactedName,
				cr.ProspectId,
				p.ProspectName,
				p.OverallStage,
				p.HighestCapacity,
				p.IsPrincipalGiftProspect,
				p.IsChancellorsProspect,
				dbo.IsDevOfficerAssignedToProspect(cr.DevOfficerId, cr.ProspectId) is_dev_officer_assigned_to_prospect,
				dbo.IsDevOfficerPmrAssignedToProspect(cr.DevOfficerId, cr.ProspectId) is_dev_officer_pmr_assigned_to_prospect,
				pr.ProposalId,
				pr.SolicitationApprovalStatus,
				pr.ProposalStage,
				pr.ProposalTitle,
				dbo.IsDevOfficerAssignedToProposal(cr.DevOfficerId,cr.ProspectId) IsDevOfficerAssignedToProposal,
				e.PREF_NAME_SORT dev_officer_name -- dev officer name
				, suf.[name] DevOfficerUnit--dev officer unit
				, spuf.[name] DevOfficerUnitGroup--dev officer unit group
				, [uf].[name] ContactReportUnit, 
				[puf].[name] ContactReportUnitGroup, 
				cr.ContactedSortName,
				mrpa.PmrAssignmentStartDate,
				mrpa.PmrAssignmentStopDate,
				e.PREF_NAME_SORT author_name, 
				cr.DevOfficerId author_id,
				p.IsProspectActive,
				mrpa.AssignmentType authors_pmats_assignment,
				mrpa.PmatsStartDate,
				mrpa.PmatsStopDate,
				mrpa.IsAssignmentActive,
				pr.ProposalApprovalDate,
				pr.ProposalComment,
				cr.ContactReportAuditStatus,
				cr.ContactReportReviewDate,
				cr.ContactReportGUID,
				dbo.GetFiscalYear(convert(date,current_timestamp)) FiscalYear,
				cr.isFaceToFace,
				cr.isAskMadeMajor,
				cr.isAskMadeAnnualSpecial,
				cr.isDollarsRaisedAnnual,
				cr.isComprehensiveAsk,
				cr.isFacultyInteraction,
				cr.DollarsRaisedDate,
				dbo.GetFiscalYear(convert(date,cr.DollarsRaisedDate)) DollarsRaisedFy,
				dbo.GetFiscalYear(convert(date, cr.ContactDate)) ContactDateFy,

				p.PROSPECT_NAME_SORT ProspectSortName

			from contactReports cr

				 left outer join prospects p 
					on cr.ProspectId = p.ProspectId
	 
				 left outer join allProspectAssignments mrpa 
					on cr.ProspectId = mrpa.ProspectId 
					and cr.DevOfficerId = mrpa.DevOfficerIdNumber
	 
				 left join proposals pr 
					on cr.ProposalId = pr.ProposalId
	 
				 left outer join DOMetrics.vUnitFact uf
					on uf.unitCode = cr.unitCode

				 left outer join DOMetrics.vUnitFact puf
					on uf.parentUnitCode = puf.unitCode

				 join AIS_Prod.ADVANCE.ENTITY e
					on e.ID_NUMBER = cr.DevOfficerId
					and e.IS_ACTIVE = 1

				 left outer join AIS_Prod.ADVANCE.STAFF s
					on s.ID_NUMBER = cr.AuthorId
					and s.IS_ACTIVE = 1

				 left outer join DOMetrics.vUnitFact suf
					on suf.unitCode = s.UNIT_CODE

				 left outer join DOMetrics.vUnitFact spuf
					on suf.parentUnitCode = spuf.unitCode
		) a

where 
	DollarsRaisedFy = DOMetrics.ConfigurationGetFiscalYear(current_timestamp) 
	or ContactDateFy = DOMetrics.ConfigurationGetFiscalYear(current_timestamp)