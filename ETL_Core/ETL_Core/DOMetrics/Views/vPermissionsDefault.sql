


CREATE view [DOMetrics].[vPermissionsDefault]
(
  userTypeCode
, entityId
, firstName
, lastName
, ldapId
, userHash
)
as


SELECT DISTINCT
	 'DEFAULT' userTypeCode
	, U.ID_NUMBER entityId
	, E.FIRST_NAME firstName
	, E.LAST_NAME lastName
	, R1.[USER_NAME] ldapId
	, checksum(E.FIRST_NAME + E.LAST_NAME + R1.[USER_NAME]) userHash

FROM AIS_Prod.ADVANCE.ZZ_USER_RIGHTS R1
	
	join AIS_Prod.ADVANCE.ZZ_USER U
		on R1.USER_NAME = U.USER_NAME
		and U.IS_ACTIVE = 1
		and R1.IS_ACTIVE = 1

	join AIS_Prod.ADVANCE.ENTITY E
		on E.ID_NUMBER = U.ID_NUMBER
		and E.IS_ACTIVE = 1

WHERE 
	--RIGHTS_GROUP in ('PI','PM','PZ', 'ZZ') AND 
    U.ACTIVE_IND = 'Y'
	AND CHARINDEX('_',R1.[USER_NAME]) = 0
	AND U.ID_NUMBER NOT IN 
		(
		   SELECT DISTINCT entityId from DOMetrics.vPermissionsAdmin
		   union
		   SELECT DISTINCT entityId from DOMetrics.vPermissionsDevofficer      
		)