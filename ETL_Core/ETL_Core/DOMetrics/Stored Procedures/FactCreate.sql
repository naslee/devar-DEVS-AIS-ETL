CREATE PROCEDURE [DOMetrics].[FactCreate]
    @AuthorId			VARCHAR(10),
	@ArtifactId			bigint,
	@DepartmentCode		varchar(5),
	@FiscalYear			int,
	@MetricType			varchar(10),
	@MetricDate			datetime,
	@DollarsRaised		float,
	@DwSourceKey		varchar(38),
	@MetricFactHash		bigint
	,@DwTruthKey			uniqueidentifier OUTPUT
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

		declare @dwSourceKeyCheck varchar(36)
		--dupe check
		--set the metric id for the duplicate record
		SELECT @dwSourceKeyCheck = f.DwSourceKey
		FROM DOMetrics.MetricFact f				
					
		WHERE 
			f.AuthorId = @AuthorId AND 
			f.DwSourceKey = @DwSourceKey AND
			f.MetricType = @MetricType

		

		--if the metric doesn't already exist, create it
		IF @dwSourceKeyCheck IS NULL
			BEGIN	
			
				DECLARE @FactOutput TABLE (DwTruthKey char(38));	
							
				INSERT INTO DOMetrics.MetricFact
					(AuthorId, ArtifactId, DepartmentCode, FiscalYear, MetricType, MetricDate, DollarsRaised, DwSourceKey, MetricFactHash)
				OUTPUT 
					INSERTED.DwTruthKey INTO @FactOutput
				VALUES
					(@AuthorId, @ArtifactId, @DepartmentCode, @FiscalYear, @MetricType, @MetricDate, @DollarsRaised, @DwSourceKey, @MetricFactHash);

				SELECT @DwTruthKey = DwTruthKey FROM @FactOutput;
				
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