create function DOMetrics.[AskMadeMajor_2017] 
(
  @ContactReportID int
, @ContactReportTableID bigint

)
RETURNS int

as
begin
DECLARE @IsAskMadeMajor bit
select @IsAskMadeMajor = isnull(cr.REPORT_ID,0)
from AIS_Prod.ADVANCE.CONTACT_REPORT cr
where cr.CONTACT_TYPE in ('C', 'V', 'P')
and cr.CONTACT_PURPOSE_CODE ='A'
and cr.IS_ACTIVE = 1
and cr.REPORT_ID = @ContactReportID
and cr.ID = @ContactReportTableID

return @IsAskMadeMajor;
end;