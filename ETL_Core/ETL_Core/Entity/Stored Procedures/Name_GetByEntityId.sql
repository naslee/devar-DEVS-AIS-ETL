CREATE PROCEDURE [Entity].[Name_GetByEntityId]
	@ids [dbo].StringListTableType READONLY
AS
	
	 SET NOCOUNT ON;

	--Define exception variables
	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;
	
	BEGIN TRY
		
		--return names
		SELECT i.item IdNumber
         , e.FIRST_NAME FirstName
         , e.LAST_NAME LastName
         , n.FIRST_NAME NickName
         , [Entity].[GetDegreeCodeYears](e.ID_NUMBER) DegreeCodeYears
		 , job1.EmployerName Employer1
		 , job1.JobTitle Title1
		 , job1.EmployerUnit EmployerUnit1
		 , job2.EmployerName Employer2
		 , job2.JobTitle Title2
		 , job2.EmployerUnit EmployerUnit2
		 , job3.EmployerName Employer3
		 , job3.JobTitle Title3
		 , job3.EmployerUnit EmployerUnit3
		 , job1.HasGreaterThan3Records MoreThan3Titles
		FROM AIS_Prod.ADVANCE.ENTITY e
			INNER JOIN @ids i 
				ON i.item = e.ID_NUMBER
			LEFT JOIN AIS_Prod.ADVANCE.NAME n 
				ON e.ID_NUMBER = n.ID_NUMBER 
				AND n.NAME_TYPE_CODE = 'NN'
			outer apply Entity.fnEmployment_GetByEntityId(e.ID_NUMBER, 1) job1
			outer apply Entity.fnEmployment_GetByEntityId(e.ID_NUMBER, 1) job2
			outer apply Entity.fnEmployment_GetByEntityId(e.ID_NUMBER, 1) job3

	    WHERE (n.ID_NUMBER IS NULL OR n.IS_ACTIVE = 1)
			  AND e.IS_ACTIVE = 1;


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