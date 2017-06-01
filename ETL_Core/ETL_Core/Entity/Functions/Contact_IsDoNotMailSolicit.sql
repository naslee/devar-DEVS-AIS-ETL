
create FUNCTION [Entity].[IsDoNotMailSolicit] 
(
  @IdNumber varchar(10)
)
RETURNS bit
AS
BEGIN
  declare 
  @returnValue bit,
  @hndTypeCount int
	

  select @hndTypeCount = 
	  (
		  select count(*)
		  from AIS_Prod.ADVANCE.HANDLING h
		  where h.HND_STATUS_CODE <> 'I'
				and h.HND_TYPE_CODE = 'DSM'
				and h.ID_NUMBER = REPLICATE('0', 10 - len(@IdNumber)) + @IdNumber
				and IS_ACTIVE = 1
	  );
		 
  select @returnValue = case when @hndTypeCount > 0 then 1 else 0 end;

RETURN(@returnValue);
END;