CREATE procedure performance.sp_ActivityLog

	  @ProcessName varchar(100)
	, @SystemName varchar(100)
	, @ActivityOperation varchar(50)
	, @ActivityObjectName varchar(100)
	, @ActivityDescription varchar(max)
	, @ActivityStep varchar(50) 
	, @ActivityOutcome varchar(50)
	, @ActivityTimestamp datetime null
	, @ActivityCount bigint


	
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

		IF @ActivityTimestamp IS NULL
			set @ActivityTimestamp = current_timestamp

		IF NULLIF(@SystemName, '') IS NULL
			RAISERROR 
			(
				N'System name cannot be null', 
				16,
				1
			);

		IF NULLIF(@ActivityObjectName, '') IS NULL
			RAISERROR 
			(
				N'Error object name cannot be null', 
				16,
				1
			);

		
		
		insert into performance.Activity
			(
				  ProcessName
				, SystemName
				, OperationType
				, SourceObject
				, SourceDescription
				, Step
				, Outcome
				, ActivityTimestamp
				, ActivityCount

			)

		values
			
			(
				  @ProcessName
				, @SystemName 
				, @ActivityOperation 
				, @ActivityObjectName 
				, @ActivityDescription 
				, @ActivityStep
				, @ActivityOutcome 
				, @ActivityTimestamp 
				, @ActivityCount

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