
create function [DOMetrics].[FaceToFaceSubstantive_2017]
	(
		@ContactReportID int
		, @ContactReportTableId bigint
	)
returns int 
as
begin
DECLARE @IsSubstantive bit
	
	select @IsSubstantive = isnull(cr.REPORT_ID, 0)

	from AIS_Prod.ADVANCE.CONTACT_REPORT cr

	where
		cr.CONTACT_TYPE  in ('C', 'P') 
		and cr.CONTACT_INITIATED_BY = 'FCGS'
		and cr.REPORT_ID = @ContactReportID
		and cr.ID = @ContactReportTableID
return @IsSubstantive
end