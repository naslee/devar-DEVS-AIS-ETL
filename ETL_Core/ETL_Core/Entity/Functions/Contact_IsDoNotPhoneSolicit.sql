

create FUNCTION [Entity].[IsDoNotPhoneSolicit] 
(
  @IdNumber varchar(10)
)
RETURNS bit
AS
BEGIN
  declare @returnValue bit
		, @hndTypeCount int;

   set @hndTypeCount = 0

  select @hndTypeCount = count(*)
  from AIS_Prod.ADVANCE.HANDLING h
  where h.HND_STATUS_CODE <> 'I'
		and h.HND_TYPE_CODE = 'DSP'
		and h.ID_NUMBER = REPLICATE('0', 10 - len(@IdNumber)) + @IdNumber
		and IS_ACTIVE = 1;
		 
  select @returnValue = case when @hndTypeCount > 0 then 1 else 0 end;

RETURN(@returnValue);
END;