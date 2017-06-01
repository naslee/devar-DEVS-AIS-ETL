
CREATE PROCEDURE [DOMetrics].[FactDelete]
    @AuthorId			VARCHAR(10),
	@ArtifactId			bigint,
	@DepartmentCode		varchar(5),
	@FiscalYear			int,
	@MetricType			varchar(10)

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

		
		--if the metric already exists, update it
		IF @ArtifactId IS NOT NULL
			BEGIN	
			
				--DECLARE @FactOutput TABLE (DwTruthKey char(38));	
							
				DELETE FROM DOMetrics.MetricFact
				Where
				  AuthorId = @AuthorId
				  and ArtifactId = @ArtifactId
				  and DepartmentCode = @DepartmentCode
				  and FiscalYear = @FiscalYear
				  and MetricType = @MetricType
			
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