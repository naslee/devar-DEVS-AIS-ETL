








/*
	reportId
	crGuid
	authorId
	dateContacted
	contactFiscalYear
*/


--declare @fiscalYear int
--set @fiscalYear = 2017

--select *
--from DOMetrics.vDollarsRaisedMajor
--where fiscalYear = @fiscalYear


create view [DOMetrics].[vDollarsRaisedMajorTest]
(
reportId,
dollarsRaised,
authorId,
unitCode,
assignmentGuid,
dateContacted,
fiscalYear
)
as

	SELECT DISTINCT 
		  P.PROPOSAL_ID reportId
		, GRANTED_AMT dollarsRaised
		, A.ASSIGNMENT_ID_NUMBER authorId
		, (
			SELECT TOP 1 UNIT_CODE 
			FROM AIS_Prod.ADVANCE.STAFF s
			WHERE s.ID_NUMBER = A.ASSIGNMENT_ID_NUMBER
				AND 
				(
					CAST(P.STOP_DATE AS DATE) 
						BETWEEN CAST(s.DATE_ACTIVATED AS DATE) 
						AND ISNULL(s.DATE_DEACTIVATED, '12/31/3000')
				)
				AND 
				(
					s.UNIT_CODE IS NOT NULL
					OR 
					LTRIM(RTRIM(s.UNIT_CODE)) <> ''
				)
			ORDER BY s.DATE_ACTIVATED DESC
		  )  unitCode
		, P.PROPOSAL_GUID assignmentGuid
		, P.STOP_DATE dateContacted
		, d.FISCALYEAR fiscalyear

	FROM AIS_Prod.ADVANCE.PROPOSAL P

	  JOIN AIS_Prod.ADVANCE.ASSIGNMENT A 
		ON P.PROPOSAL_ID = A.PROPOSAL_ID 
	
	  JOIN DOMetrics.vAskMadeMajorContactReportsTest AMM
		ON P.PROPOSAL_ID = AMM.proposalId

	  JOIN AIS_Prod.dbo.UCDR_DATE_DIM d
		on d.[DATE] = CAST(P.STOP_DATE AS DATE) 

	WHERE 
		P.IS_ACTIVE = 1  
		and A.IS_ACTIVE = 1 --CDC IS_ACTIVE flag to only capture currently active records
		and A.ASSIGNMENT_TYPE IN ('SL','SG') --Solicitation lead, solicitation team member
		and	P.PROPOSAL_TYPE = 'MGA' --Major gift ask
		and P.STAGE_CODE = 'ST'  --Stewardship
		and P.ACTIVE_IND = 'N' --Inactive proposal 
		and A.ACTIVE_IND = 'Y' --Active assignment
		and AMM.isAMM = 1


	UNION

	SELECT DISTINCT 
		  P.PROPOSAL_ID
		, GRANTED_AMT
		, A.ASSIGNMENT_ID_NUMBER
		, (
			SELECT TOP 1 UNIT_CODE 
			FROM AIS_Prod.ADVANCE.STAFF s
			WHERE s.ID_NUMBER = A.ASSIGNMENT_ID_NUMBER
				AND 
				(
					CAST(P.EXPECTED_DATE AS DATE) 
						BETWEEN CAST(s.DATE_ACTIVATED AS DATE) 
						AND ISNULL(s.DATE_DEACTIVATED, '12/31/3000')
				)
				AND 
				(
					s.UNIT_CODE IS NOT NULL
					OR 
					LTRIM(RTRIM(s.UNIT_CODE)) <> ''
				)
			ORDER BY s.DATE_ACTIVATED DESC
		  )  unitCode
		, P.PROPOSAL_GUID
		, P.EXPECTED_DATE
		, d.FISCALYEAR

	FROM AIS_Prod.ADVANCE.PROPOSAL P

	  JOIN AIS_Prod.ADVANCE.ASSIGNMENT A 
		ON P.PROPOSAL_ID = A.PROPOSAL_ID 

	  JOIN DOMetrics.vAskMadeMajorContactReportsTest AMM
		ON P.PROPOSAL_ID = AMM.proposalId

	  JOIN AIS_Prod.dbo.UCDR_DATE_DIM d
		on d.[DATE] = CAST(P.EXPECTED_DATE AS DATE)

	WHERE 
		P.IS_ACTIVE = 1 
		and A.IS_ACTIVE = 1
		and A.ASSIGNMENT_TYPE IN ('SL','SG') 
		and P.PROPOSAL_TYPE = 'MGA'
		and P.STAGE_CODE = 'GC' 
		and P.ACTIVE_IND = 'Y'
		and A.ACTIVE_IND = 'Y' 
		and AMM.isAMM = 1