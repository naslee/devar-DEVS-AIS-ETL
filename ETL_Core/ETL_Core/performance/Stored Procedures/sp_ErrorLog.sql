CREATE procedure [performance].[sp_ErrorLog]

	  @ProcessName varchar(100)
	, @SystemName varchar(100)
	, @ErrorObjectName varchar(100)
	, @Operation varchar(50)
	, @ErrorDescription varchar(max)
	, @ErrorActivity varchar(50)
	, @ErrorStep varchar(50)
	, @ErrorRecordIdentifier varchar(100)
	, @ErrorRecordSeverity int
	, @Outcome varchar(50)
	
as

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @CreateErrorSeverity INT;
	DECLARE @ErrorState INT;

BEGIN TRY

		IF NULLIF(@ProcessName, '') IS NULL
			RAISERROR 
			(
				N'Process name cannot be null', 
				16,
				1
			);

		IF NULLIF(@SystemName, '') IS NULL
			RAISERROR 
			(
				N'System name cannot be null', 
				16,
				1
			);

		IF NULLIF(@ErrorObjectName, '') IS NULL
			RAISERROR 
			(
				N'Error object name cannot be null', 
				16,
				1
			);

		IF NULLIF(@Operation, '') IS NULL
			RAISERROR 
			(
				N'Error operation name is required', 
				16,
				1
			);

		IF @Operation NOT IN
			(
				'Insert',
				'Update',
				'Delete',
				'Upload',
				'Download'
			)
			RAISERROR 
			(
				N'Invalid error operation type, must be ''Insert'',''Update'', ''Delete'', ''Upload'', ''Download''', 
				16,
				1
			);

		IF NULLIF(@ErrorStep, '') IS NULL
			RAISERROR 
			(
				N'Error step is required', 
				16,
				1
			);

		IF NULLIF(@ErrorRecordIdentifier, '') IS NULL
			RAISERROR 
			(
				N'Error record unique identifier is required', 
				16,
				1
			);
		
		IF NULLIF(@ErrorRecordSeverity, '') IS NULL
			RAISERROR 
			(
				N'Error severity is required', 
				16,
				1
			);

		IF @ErrorRecordSeverity NOT BETWEEN 1 and 10
			RAISERROR 
			(
				N'Error severity must be between 1 and 10', 
				16,
				1
			);
		
		insert into performance.Activity

			(
				  ProcessName
				, SystemName
				, OperationType
				, ActivityType
				, Step
				, SourceObject
				, SourceIdentifier
				, SourceDescription
				, Severity
				, Outcome	
			)

		values
			
			(
				  @ProcessName 
				, @SystemName 
				, @Operation
				, @ErrorActivity
				, @ErrorStep  
				, @ErrorObjectName
				, @ErrorRecordIdentifier  
				, @ErrorDescription 
				, @ErrorRecordSeverity
				, @Outcome
			)
		
	END TRY
	BEGIN CATCH

		SELECT 
			@ErrorMessage = ERROR_MESSAGE(),
			@CreateErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage,
				   @CreateErrorSeverity,
				   @ErrorState
				   );
	END CATCH;