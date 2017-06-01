





CREATE view [DOMetrics].[vUserFactUpdate]
(
  entityId
, userTypeCode
, firstName
, lastName
, ldapId
, recType
, userHash
)
as
with deltaUsers
as
(
	select entityId, userHash, firstName, lastName
	from DOMetrics.[vUserFact]
	except
	select entityId, userHash,firstName, lastName
	from DOMetrics.UserFact
)

,updateUsers
as
(
select distinct  uf.entityId, 'U' actionType
from DOMetrics.vUserFact uf
join deltaUsers a 
	on a.entityId = uf.entityId
intersect 
select distinct ufe.entityId, 'U' actionType
from DOMetrics.UserFact ufe
)
,
insertUsers as
(
select distinct  vf.entityId, 'I' actionType
from DOMetrics.vUserFact vf
left outer join DOMetrics.UserFact uf
	on vf.entityId = uf.entityId
where uf.entityId is null

)
,
deleteUsers as
(
select distinct  entityId
from DOMetrics.UserFact 
except
select entityId from
DOMetrics.vUserFact uf
	
)



select   entityId
, userTypeCode
, firstName
, lastName
, ldapId
, actionType recType
, userHash
from
(
	select uf.userTypeCode,  iu.entityId,  uf.firstName, uf.lastName, uf.ldapId, actionType, uf.userHash
	from insertUsers iu
		join DOMetrics.vUserFact uf
			on uf.entityId = iu.entityId
	union
	select uf.userTypeCode,  iu.entityId,  uf.firstName, uf.lastName, uf.ldapId, actionType, uf.userHash
	from updateUsers iu
		join DOMetrics.vUserFact uf
			on uf.entityId = iu.entityId
	union
	select uf.userTypeCode,  iu.entityId,  uf.firstName, uf.lastName, uf.ldapId, 'D', uf.userHash
	from deleteUsers iu
	join DOMetrics.UserFact uf
			on uf.entityId = iu.entityId
) a
 where entityId is not null
and upper(ldapId) not like '%_GIFTS'
and upper(ldapId) not like '%_TEST%'
and upper(ldapId) not like '%_PMATS'
and ldapId <> 'llcarran'
and firstName <> ' '
and entityId not in
(
'0000781936',
'0000906408',
'0000214882',
'0000845521',
'0000084584'
)