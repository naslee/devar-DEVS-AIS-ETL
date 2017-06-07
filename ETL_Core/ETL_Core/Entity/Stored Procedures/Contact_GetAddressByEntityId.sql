CREATE PROCEDURE [Entity].[Contact_GetAddressByEntityId]
	@ids [dbo].StringListTableType READONLY
AS
	
	 SET NOCOUNT ON;

	--Define exception variables
	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;
	
	BEGIN TRY
		
		--return email addresses
		SELECT DISTINCT y.* FROM 
		(
			SELECT x.*
			, RANK() OVER(PARTITION BY x.householdId ORDER BY x.idNumber) rk
			FROM 
			(
				SELECT DISTINCT i.entityId idNumber
					, e.PREF_NAME_SORT SortName
					, e.PREF_MAIL_NAME PrefName
					, e.LAST_NAME LastName
					, e.FIRST_NAME FirstName
					, i.householdId
					, spe.pref_mail_name SpousePrefName
					, e.spouse_id_number SpouseIdNumber
					, e.JNT_SALUTATION JointSalutation
					, a.ValidAddressTypeCode ValidAddressType
					, a.ValidStreet1
					, a.ValidStreet2
					, a.ValidStreet3
					, a.ValidCity
					, a.ValidStateCode
					, a.ValidZipCode
					, pa.addr_type_code PrefAddressType
					, pa.street1 PrefStreet1
					, isnull(pa.street2,' ') PrefStreet2
					, isnull(pa.street3,' ') PrefStreet3
					, pa.city PrefCity
					, pa.state_code PrefState
					, pa.zipcode PrefZipCode
					, [Entity].[IsDoNotContact](e.ID_NUMBER) DoNotContact
					, [Entity].[IsDoNotSolicit](e.ID_NUMBER) DoNotSolicit
					, [Entity].[IsDoNotInvite](e.ID_NUMBER) DoNotInvite
					, [Entity].[IsDoNotMail](e.ID_NUMBER) DoNotMail
				FROM (
						select i.item entityId, Entity.GetHouseholdId(i.item) householdId
						from @ids i
					) i
				 join AIS_Prod.ADVANCE.ENTITY e
					 ON i.entityId = e.ID_NUMBER							
					LEFT JOIN AIS_Prod.ADVANCE.ENTITY spe ON e.SPOUSE_ID_NUMBER = spe.ID_NUMBER
					LEFT JOIN AIS_Prod.ADVANCE.ADDRESS pa 
						ON i.householdId = pa.ID_NUMBER 
						AND pa.ADDR_PREF_IND = 'Y'
					OUTER APPLY [Entity].GetValidAddressSummary(i.householdId) a
				WHERE 
					e.ID_NUMBER IS NULL
					OR
					(
						e.IS_ACTIVE = 1
						AND
						(spe.ID_NUMBER IS NULL OR spe.IS_ACTIVE = 1)
						AND
						(pa.ID_NUMBER IS NULL OR pa.IS_ACTIVE = 1)
					)
								
			) x
		) y
		WHERE y.rk = 1
		
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
    ON OBJECT::[Entity].[Contact_GetAddressByEntityId] TO [devar-etl]
    AS [dbo];

