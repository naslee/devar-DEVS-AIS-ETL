
CREATE FUNCTION [Entity].[GetContactPreferenceSummary](@EntityId VARCHAR(10))

RETURNS	@entityAddressComplete TABLE 
	(
		EntityId VARCHAR(10) NOT NULL,
		HouseholdId VARCHAR(10) NULL,
		IsDoNotContact BIT NOT NULL,
		IsDoNotEmail BIT NOT NULL,
		IsDoNotEmailInvite BIT NOT NULL,
		IsDoNotEmailSolicit BIT NOT NULL,
		IsDoNotInvite BIT NOT NULL,
		IsDoNotMail BIT NOT NULL,
		IsDoNotMailInvite BIT NOT NULL,
		IsDoNotMailSolicit BIT NOT NULL,
		IsDoNotPhone BIT NOT NULL,
		IsDoNotPhoneSolicit BIT NOT NULL,
		IsDoNotSolicit BIT NOT NULL
	)
				
AS

	BEGIN
		DECLARE
			@internalEntityId VARCHAR(10),
			@householdId VARCHAR(10),
			@isDoNotContact BIT,
			@isDoNotEmail BIT,
			@isDoNotEmailInvite BIT,
			@isDoNotEmailSolicit BIT,
			@isDoNotInvite BIT,
			@isDoNotMail BIT,
			@isDoNotMailInvite BIT,
			@isDoNotMailSolicit BIT,
			@isDoNotPhone BIT,
			@isDoNotPhoneSolicit BIT,
			@isDoNotSolicit BIT 

		SELECT
			@internalEntityId = @EntityId,
			@householdId = ETL_Core.Entity.GetHouseholdId(@EntityId),
			@isDoNotContact = ETL_Core.Entity.IsDoNotContact(@EntityId),
			@isDoNotEmail = ETL_Core.Entity.IsDoNotEmail(@EntityId),
			@isDoNotEmailInvite = ETL_Core.Entity.IsDoNotEmailInvite(@EntityId),
			@isDoNotEmailSolicit = ETL_Core.Entity.IsDoNotEmailSolicit(@EntityId),
			@isDoNotInvite = ETL_Core.Entity.IsDoNotInvite(@EntityId),
			@isDoNotMail = ETL_Core.Entity.IsDoNotMail(@EntityId),
			@isDoNotMailInvite = ETL_Core.Entity.IsDoNotMailInvite(@EntityId),
			@isDoNotMailSolicit = ETL_Core.Entity.IsDoNotMailSolicit(@EntityId),
			@isDoNotPhone = ETL_Core.Entity.IsDoNotPhone(@EntityId),
			@isDoNotPhoneSolicit = ETL_Core.Entity.IsDoNotPhoneSolicit(@EntityId),
			@isDoNotSolicit = ETL_Core.Entity.IsDoNotSolicit(@EntityId);

		IF @EntityId IS NOT NULL
			BEGIN
				INSERT @entityAddressComplete
				SELECT 
					@internalEntityId,
					@householdId,
					@isDoNotContact,
					@isDoNotEmail,
					@isDoNotEmailInvite,
					@isDoNotEmailSolicit,
					@isDoNotInvite,
					@isDoNotMail,
					@isDoNotMailInvite,
					@isDoNotMailSolicit,
					@isDoNotPhone,
					@isDoNotPhoneSolicit,
					@isDoNotSolicit 
			END;
		
		RETURN;
	END;