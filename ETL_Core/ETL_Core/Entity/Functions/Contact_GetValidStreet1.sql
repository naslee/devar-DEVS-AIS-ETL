

CREATE FUNCTION [Entity].[GetValidStreet1] 
(
  @IdNumber varchar(10)
)
RETURNS varchar(100)
AS
BEGIN
  declare @returnValue varchar(100);

  select @returnValue = a2.STREET1
  from (select a1.STREET1
				, row_number() over(partition by a1.ID_NUMBER
								order by a1.address_sort , a1.XSEQUENCE desc) as rn
		from ( 
				select a.*
						, case 
							when a.ADDR_PREF_IND = 'Y' then 1
							when a.ADDR_TYPE_CODE = 'H' then 2
							when a.ADDR_TYPE_CODE = 'B' then 3
							when a.ADDR_TYPE_CODE = 'A' then 4
							when a.ADDR_TYPE_CODE = 'R' then 5
							when a.ADDR_TYPE_CODE = 'Z' then 6
							when a.ADDR_TYPE_CODE = '6' then 9
							else 99
							end address_sort	
				from AIS_Prod.ADVANCE.ADDRESS a
				where a.ADDR_TYPE_CODE in ('H','B','A','R','Z','6')
						and a.ADDR_STATUS_CODE in ('A',' ')
						and a.ID_NUMBER = REPLICATE('0', 10 - len(@IdNumber)) + @IdNumber
						and a.IS_ACTIVE = 1
			 ) a1
		) a2
  where a2.rn = 1;

RETURN(@returnValue);
END;