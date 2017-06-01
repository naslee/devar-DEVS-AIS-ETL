


CREATE VIEW [DOMetrics].[vPermissionsDevofficer]
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
	 'DEVOFFICER' userTypeCode
	, U.ID_NUMBER entityId
	, E.FIRST_NAME firstName
	, E.LAST_NAME lastName
	, R1.[USER_NAME] ldapId
	--, CASE 
	--	WHEN CHARINDEX('_',R1.[USER_NAME]) > 0
	--		then 
	--			LEFT(R1.[USER_NAME],CHARINDEX('_',R1.[USER_NAME])-1)
	--	else R1.[USER_NAME] 
	--   end ldapId
	, checksum(STAFF_TYPE_CODE,E.FIRST_NAME + E.LAST_NAME + R1.[USER_NAME]) userHash


FROM AIS_Prod.ADVANCE.ZZ_USER_RIGHTS R1
	join AIS_Prod.ADVANCE.ZZ_USER U
		on R1.[USER_NAME] = U.[USER_NAME]
		and U.IS_ACTIVE = 1
		and R1.IS_ACTIVE = 1

	join AIS_Prod.ADVANCE.STAFF S
		on S.ID_NUMBER = U.ID_NUMBER
		and S.IS_ACTIVE = 1

	join AIS_Prod.ADVANCE.ENTITY E
		on E.ID_NUMBER = U.ID_NUMBER
		and E.IS_ACTIVE = 1

WHERE 
	--RIGHTS_GROUP = 'PM' AND 
	U.ACTIVE_IND = 'Y'
	AND 
	S.STAFF_TYPE_CODE = 'DEV'
    AND S.ACTIVE_IND = 'Y'  
	AND CHARINDEX('_',R1.[USER_NAME]) = 0   
	AND U.ID_NUMBER NOT IN 
		(
		   SELECT entityId
		   from DOMetrics.vPermissionsAdmin
		)
UNION



select 
'DEVOFFICER',	'0001024058',	'Trish',	'Bloemker Sowers',	'tbsowers',	-423453817

union

select
'DEVOFFICER',	'0001050603',	'Mark',	'Jones',	'mksjones',	-743927201

union

select
'DEVOFFICER',	'0000987839',	'Patrick',	'Nolan',	'pnolan',	212005814

union
select
'DEVOFFICER', '0000792829',    'Cynthia',    'Spiro',    'cspiro',    -348083848