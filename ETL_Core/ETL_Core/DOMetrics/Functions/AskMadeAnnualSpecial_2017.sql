create function DOMetrics.AskMadeAnnualSpecial_2017
(
  @ContactReportID int
, @ContactReportTableID bigint

)
RETURNS int

as
begin
DECLARE 
@IsAskMadeAnnualSpecial bit
select @IsAskMadeAnnualSpecial = isnull(cr.REPORT_ID,0)  --convert(money, cr.REP_COMMENT)
from AIS_Prod.ADVANCE.CONTACT_REPORT cr
where cr.CONTACT_TYPE in ('C', 'V', 'P')
and cr.CONTACT_PURPOSE_CODE ='B'
and cr.IS_ACTIVE = 1
and cr.REPORT_ID = @ContactReportID
and cr.ID = @ContactReportTableID
return @IsAskMadeAnnualSpecial;
end;