

create function DOMetrics.FacultyInteraction_2017
(
  @ContactReportID int
, @ContactReportTableID bigint
)
RETURNS int
as
begin
DECLARE @IsFacultyInteraction bit
select @IsFacultyInteraction = isnull(cr.REPORT_ID,0)
from AIS_Prod.ADVANCE.CONTACT_REPORT cr
WHERE cr.CONTACT_INITIATED_BY = 'FCGF'
and cr.CONTACT_TYPE <> 'R'
and cr.REPORT_ID = @ContactReportID
and cr.ID = @ContactReportTableID
return @IsFacultyInteraction
end