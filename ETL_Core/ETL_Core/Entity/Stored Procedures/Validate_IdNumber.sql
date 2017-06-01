CREATE PROCEDURE [Entity].[Validate_IdNumber]
	@ids [dbo].StringListTableType READONLY
AS
	
	 SET NOCOUNT ON;

	--Define exception variables
	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;
	
	BEGIN TRY
		
		SELECT i.item IdNumber,
			CASE 
				WHEN e.ID_NUMBER IS NULL 
					THEN 0 
				ELSE 1 
			END IsValid
		FROM AIS_Prod.ADVANCE.ENTITY e
			RIGHT JOIN @ids i ON i.item = e.ID_NUMBER
		WHERE e.ID_NUMBER IS NULL OR e.IS_ACTIVE = 1

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