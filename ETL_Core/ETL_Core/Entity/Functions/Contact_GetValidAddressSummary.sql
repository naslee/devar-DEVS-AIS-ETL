
CREATE FUNCTION [Entity].[GetValidAddressSummary](@EntityId VARCHAR(10))

RETURNS	@entityAddressComplete TABLE 
	(
		EntityId VARCHAR(10) NOT NULL,
		HouseholdId VARCHAR(10) NULL,
		ValidAddressTypeCode VARCHAR(10) NULL,
		ValidStreet1 VARCHAR(100) NULL,
		ValidStreet2 VARCHAR(100) NULL,
		ValidStreet3 VARCHAR(100) NULL,
		ValidCity VARCHAR(100) NULL,
		ValidStateCode VARCHAR(10) NULL,
		ValidZipCode VARCHAR(100) NULL
	)
				
AS

	BEGIN
		DECLARE
			@internalEntityId VARCHAR(10),
			@householdId VARCHAR(10),
			@validAddressTypeCode VARCHAR(10),
			@validStreet1 VARCHAR(100),
			@validStreet2 VARCHAR(100),
			@validStreet3 VARCHAR(100),
			@validCity VARCHAR(100),
			@validStateCode VARCHAR(10),
			@validZipCode VARCHAR(100)

		SELECT
			@internalEntityId = @EntityId,
			@householdId = [Entity].GetHouseholdId(@EntityId),
			@validAddressTypeCode = ETL_Core.Entity.GetValidAddrTypeCode(@EntityId),
			@validStreet1 = ETL_Core.Entity.GetValidStreet1(@EntityId),
			@validStreet2 = ETL_Core.Entity.GetValidStreet2(@EntityId),
			@validStreet3 = ETL_Core.Entity.GetValidStreet3(@EntityId),
			@validCity = ETL_Core.Entity.GetValidCity(@EntityId),
			@validStateCode = ETL_Core.Entity.GetValidStateCode(@EntityId),
			@validZipCode = ETL_Core.Entity.GetValidZipCode(@EntityId);

		IF @EntityId IS NOT NULL
			BEGIN
				INSERT @entityAddressComplete
				SELECT 
					@internalEntityId,
					@householdId,
					@validAddressTypeCode,
					@validStreet1,
					@validStreet2,
					@validStreet3,
					@validCity,
					@validStateCode,
					@validZipCode
			END;
		
		RETURN;
	END;