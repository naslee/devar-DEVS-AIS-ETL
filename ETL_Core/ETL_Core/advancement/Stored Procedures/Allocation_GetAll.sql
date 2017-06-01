
CREATE PROCEDURE [advancement].[Allocation_GetAll]
	@includeInActive	BIT = 0
AS
	SET NOCOUNT ON;

	--Define exception variables
	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;
	
	BEGIN TRY

		SELECT LTRIM(RTRIM(a.[ALLOCATION_CODE])) AS AllocationCode,
			   LTRIM(RTRIM(a.[STATUS_CODE])) AS AllocationStatusCode,
			   LTRIM(RTRIM(a.[LONG_NAME])) AS AllocationLongName,
			   LTRIM(RTRIM(a.[FUND_NAME])) AS AllocationFundName,
			   LTRIM(RTRIM(a.[ALLOC_SCHOOL])) AS AllocationSchoolCode,
			   LTRIM(RTRIM([dbo].[GetTmsDescription]('J2', a.ALLOC_SCHOOL))) AS AllocationSchool,
			   LTRIM(RTRIM(a.[ALLOC_DEPT_CODE])) AS AllocationDepartmentCode,
			   LTRIM(RTRIM([dbo].[GetTmsDescription]('J5', a.[ALLOC_DEPT_CODE]))) AS AllocationDepartment,
			   LTRIM(RTRIM(a.[ALLOC_PURPOSE])) AllocationPurposeCode,
			   LTRIM(RTRIM([dbo].[GetTmsDescription]('DN', a.[ALLOC_PURPOSE]))) AS AllocationPurpose,
			   LTRIM(RTRIM(a.[Agency])) AS AllocationAgency,
			   LTRIM(RTRIM(a.[ACCOUNT])) AS AllocationAccount,
			   LTRIM(RTRIM(a.[XREF])) AS AllocationKfsAccount,
			   LTRIM(RTRIM(a.[ALPHA_SORT])) AS AllocationUcFundCode,
			   LTRIM(RTRIM(a.endow_pool_code)) AS AllocationEndowPoolCode			   
		FROM [AIS_Prod].[ADVANCE].[ALLOCATION] a
		WHERE
			(
				@includeInActive = 1
				OR a.[STATUS_CODE] = 'A'
			)
			AND a.[IS_ACTIVE] = 1

	END TRY
	BEGIN CATCH

		SELECT 
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage,
				   @ErrorSeverity,
				   @ErrorState
				   );
	END CATCH;

RETURN 0;