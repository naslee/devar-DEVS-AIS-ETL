CREATE PROCEDURE [advancement].[Appeal_GetByCode]
	@code	NVARCHAR(50)
AS
	SET NOCOUNT ON;

	--Define exception variables
	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;
	
	BEGIN TRY
		
		--
		-- Validate input
		--
		IF NULLIF(@code, 0) IS NULL
			RAISERROR 
			(
				'Advancement (Appeal): Invalid Request - appeal code is required', 
				16,
				1
			);

		SELECT LTRIM(RTRIM(a.[APPEAL_CODE])) AS AppealCode,
			   LTRIM(RTRIM(a.[ACTIVE_IND])) AS AppealIsActive,
			   LTRIM(RTRIM(a.[APPEAL_GROUP])) AppealGroupCode,
			   LTRIM(RTRIM([dbo].GetTmsDescription('V9', a.[APPEAL_GROUP]))) AS AppealGroupDescription,
			   LTRIM(RTRIM(a.[APPEAL_TYPE])) AppealTypeCode,
			   LTRIM(RTRIM([dbo].GetTmsDescription('V0', a.[APPEAL_TYPE]))) AS AppealTypeDescription,
			   LTRIM(RTRIM(a.[DESCRIPTION])) AS AppealDescription,
			   LTRIM(RTRIM(a.[PROGRAM_CODE])) AS AppealProgramCode,
			   LTRIM(RTRIM(a.[CAMPAIGN_CODE])) AS AppealCampaignCode
		FROM [AIS_Prod].[ADVANCE].[APPEAL_HEADER] a
		WHERE 
			a.[APPEAL_CODE] = @code;

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