
CREATE FUNCTION [Entity].[Entity_GetHouseholdId] 
(
  @IdNumber varchar(10)
)
RETURNS varchar(10)
AS
BEGIN
  declare @returnValue varchar(10);

  select @returnValue =  case when e1.ID_NUMBER > e1.SpouseId then e1.ID_NUMBER else e1.SpouseId end
  from (
  select e.ID_NUMBER
		, case when e.SPOUSE_ID_NUMBER = ' ' then ID_NUMBER else e.SPOUSE_ID_NUMBER end SpouseId
  from AIS_Prod.ADVANCE.ENTITY e
  where e.ID_NUMBER = REPLICATE('0', 10 - len(@IdNumber)) + @IdNumber
		and IS_ACTIVE = 1
	) e1;

RETURN(@returnValue);
END;