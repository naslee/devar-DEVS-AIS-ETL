CREATE PROCEDURE [DOMetrics].[FactUpdate]
    @AuthorId			VARCHAR(10),
	@ArtifactId			bigint,
	@DepartmentCode		varchar(5),
	@FiscalYear			int,
	@MetricType			varchar(10),
	@MetricDate			datetime,
	@DollarsRaised		float,
	@DwSourceKey		char(38),
	@MetricFactHash		bigint
	,@DwTruthKey			char(38) --OUTPUT
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
		IF NULLIF(@AuthorId, '') IS NULL
			RAISERROR 
			(
				N'DOM-ERR: Invalid Request (author id is required)', 
				16,
				1
			);
		
		IF NULLIF(@ArtifactId, '') IS NULL
			RAISERROR 
			(
				N'DOM-ERR: Invalid Request (artifact id is required)', 
				16,
				1
			);

		IF NULLIF(@FiscalYear, '') IS NULL
			RAISERROR 
			(
				N'DOM-ERR: Invalid Request (fiscal year is required)', 
				16,
				1
			);

		IF NULLIF(@DepartmentCode, '') IS NULL
			RAISERROR 
			(
				N'DOM-ERR: Invalid Request (department code is required)', 
				16,
				1
			);

		IF @MetricType IS NULL
			RAISERROR 
			(
				N'DOM-ERR: Invalid Request (metric type is required)', 
				16,
				1
			);

		IF NULLIF(@DwSourceKey, '') IS NULL
			RAISERROR 
			(
				N'DOM-ERR: Invalid Request (metric source key is required)', 
				16,
				1
			);		

		--declare @dwSourceKey varchar(36)
		--dupe check
		--set the metric id for the duplicate record
		SELECT @AuthorId = f.AuthorId, @ArtifactId = f.ArtifactId, @MetricType = f.MetricType
		FROM DOMetrics.MetricFact f				
					
		WHERE 
			f.AuthorId = @AuthorId AND 
			f.ArtifactId = @ArtifactId AND
			f.MetricType = @MetricType
		

		--if the metric already exists, update it
		IF @ArtifactId IS NOT NULL
			BEGIN	
			
				--DECLARE @FactOutput TABLE (DwTruthKey char(38));	
							
				UPDATE DOMetrics.MetricFact
				SET
				  AuthorId = AuthorId
				  , ArtifactId = @ArtifactId
				  , DepartmentCode = @DepartmentCode
				  , FiscalYear = @FiscalYear
				  , MetricType = @MetricType
				  , MetricDate = @MetricDate
				  , DollarsRaised = @DollarsRaised
				  ,  @DwSourceKey = convert(char(38),DwSourceKey)
				  , @DwTruthKey = DwTruthKey
				  , MetricFactHash = @MetricFactHash
				  where @AuthorId = AuthorId
				  and @ArtifactId = ArtifactId 
				  and @MetricType  = MetricType
				  and @DepartmentCode = DepartmentCode

				--SELECT  @DwTruthKey = convert(char(38), DwTruthKey) FROM DOMetrics.MetricFact 
				--where  @AuthorId = AuthorId
				  --and @ArtifactId = ArtifactId 
				  --and @MetricType = MetricType
				
			END

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