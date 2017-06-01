CREATE PROCEDURE [Entity].[Email_GetByEntityId]
	@ids [dbo].StringListTableType READONLY
AS
	
	 SET NOCOUNT ON;

	--Define exception variables
	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;
	
	BEGIN TRY
		
		--return email addresses
		SELECT i.item IdNumber
			 , e.pref_name_sort SortName
			 , [Entity].[GetEmailAddress](e.ID_NUMBER) EmailAddress
			 , [Entity].[IsDoNotContact](e.ID_NUMBER) DoNotContact
			 , [Entity].[IsDoNotSolicit](e.ID_NUMBER) DoNotSolicit
			 , [Entity].[IsDoNotInvite](e.ID_NUMBER) DoNotInvite
			 , [Entity].[IsDoNotEmail](e.ID_NUMBER) DoNotEmail
		FROM AIS_Prod.ADVANCE.ENTITY e
			RIGHT JOIN @ids i ON i.item = e.ID_NUMBER
		WHERE e.ID_NUMBER IS NULL OR e.IS_ACTIVE = 1;

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
GO
GRANT EXECUTE
    ON OBJECT::[Entity].[Email_GetByEntityId] TO [devar-etl]
    AS [dbo];

