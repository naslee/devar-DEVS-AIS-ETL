
CREATE view [DOMetrics].[vUserFact]
(
	  userTypeCode 
	, entityId
	, firstName
	, lastName
	, ldapId
	, userHash
)
as
select 
	convert(nvarchar(50),userTypeCode) userTypeCode
	, convert(nvarchar(50),entityId) entityId
	, convert(nvarchar(50),firstName) firstName
	, convert(nvarchar(50),lastName) lastName
	, convert(nvarchar(50),ldapId) ldapId
	,  userHash
from
( 
	select userTypeCode, entityId, firstName, lastName, ldapId, userHash
	from DOMetrics.vPermissionsAdmin

	union

	select userTypeCode, entityId, firstName, lastName, ldapId, userHash
	from DOMetrics.vPermissionsDevofficer

	union

	select userTypeCode, entityId, firstName, lastName, ldapId, userHash
	from DOMetrics.vPermissionsDefault
) a

where 
ldapId not in ('security','karenc')
and ldapId not like '%_devel'
and ldapId not like '%_pmats'



--select *
--from DOMetrics.vUser