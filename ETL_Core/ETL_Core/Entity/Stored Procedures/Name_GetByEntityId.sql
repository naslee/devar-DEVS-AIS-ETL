
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
		 , case when job1.EmploymentRecordCount > 3 then 1 else 0 end MoreThan3Titles
		 , a.COMPANY_NAME_1 EmployerAddress1
		 , a.COMPANY_NAME_2 EmployerAddress2
		 , a.BUSINESS_TITLE EmployerAddressTitle

		FROM AIS_Prod.ADVANCE.ENTITY e
			INNER JOIN @ids i 
				ON i.item = e.ID_NUMBER
			LEFT JOIN AIS_Prod.ADVANCE.NAME n 
				ON e.ID_NUMBER = n.ID_NUMBER 
				AND n.NAME_TYPE_CODE = 'NN'
			LEFT OUTER JOIN AIS_Prod.ADVANCE.[ADDRESS] a
				on a.ID_NUMBER = e.ID_NUMBER
				and a.IS_ACTIVE = 1
				and a.ADDR_TYPE_CODE = 'B'
			outer apply Entity.Employment_GetActiveByEntityId(e.ID_NUMBER, 1) job1
			outer apply Entity.Employment_GetActiveByEntityId(e.ID_NUMBER, 2) job2
			outer apply Entity.Employment_GetActiveByEntityId(e.ID_NUMBER, 3) job3

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