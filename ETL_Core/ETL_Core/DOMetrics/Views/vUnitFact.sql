--select *
--from ADVANCE.ZZ_ADV_TABLE
--where ADV_TABLE_TYPE = '00'
--and UPPER(ADV_SORT_NAME) like '%UNIT%'
create view DOMetrics.vUnitFact
(
parentUnitCode,
unitCode,
name
)
as
select ADV_MISC_CODE16 parentUnitCode, ADV_TABLE_CODE unitCode, ADV_SHORT_DESC name
from AIS_Prod.ADVANCE.ZZ_ADV_TABLE
where ADV_TABLE_TYPE = 'UU'
and IS_ACTIVE = 1
--order by ADV_MISC_CODE16