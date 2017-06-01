
CREATE FUNCTION [Entity].[Contact_GetEmailAddress] 
(
  @IdNumber varchar(10)
)
RETURNS varchar(100)
AS
BEGIN
  declare @returnValue varchar(100);

  select @returnValue = e2.EMAIL_ADDRESS
  from (select e1.EMAIL_ADDRESS
				, row_number() over(partition by e1.ID_NUMBER
								order by e1.email_sort , e1.XSEQUENCE desc) as rn
		from ( 
				select e.*
				/* !TODO  */
				/* REMOVE HARDCODING */ 
						, case 
							when e.PREFERRED_IND = 'Y' then 1
							when e.EMAIL_TYPE_CODE = 'E' then 2
							when e.EMAIL_TYPE_CODE = 'H' then 3
							when e.EMAIL_TYPE_CODE = 'B' then 4
							when e.EMAIL_TYPE_CODE = 'L' then 5
							when e.EMAIL_TYPE_CODE = 'A' then 6
							when e.EMAIL_TYPE_CODE = 'R' then 7
							when e.EMAIL_TYPE_CODE = 'Z' then 8
							else 99
							end email_sort	
				from AIS_Prod.ADVANCE.EMAIL e
				where e.EMAIL_TYPE_CODE in ('E', 'H', 'B', 'L', 'A', 'R', 'Z')
						and e.EMAIL_STATUS_CODE in ('A',' ')
						and e.ID_NUMBER = REPLICATE('0', 10 - len(@IdNumber)) + @IdNumber
						and e.IS_ACTIVE = 1
			 ) e1
		) e2
  where e2.rn = 1;

RETURN(@returnValue);
END;