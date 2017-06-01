create function [DOMetrics].[AskMadeMajor_2017_TEST] 
(
  @ContactType varchar(5)
, @ContactPurposeCode varchar(5)
, @IsActive bit

)
RETURNS int

as
begin
DECLARE @IsAskMadeMajor bit
select @IsAskMadeMajor = case when @ContactType in ('C', 'V', 'P')
and @ContactPurposeCode ='A'
and @IsActive= 1
then 1 else 0 end
return @IsAskMadeMajor;
end;