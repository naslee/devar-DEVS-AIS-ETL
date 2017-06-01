
CREATE function [DOMetrics].[FaceToFace_2017] 
	(
		@ContactReportID int
		, @ContactReportTableId bigint
	)
returns int 
as
begin
	DECLARE @IsFaceToFace bit
	
	select @IsFaceToFace = isnull(cr.REPORT_ID, 0)
	
	from AIS_Prod.ADVANCE.CONTACT_REPORT cr

	where
		(
		   (cr.CONTACT_TYPE = 'V')
		   or (cr.CONTACT_TYPE = 'V' and cr.CONTACT_INITIATED_BY = 'FCLM')
		   or (cr.CONTACT_TYPE  in ('C', 'P') and cr.CONTACT_INITIATED_BY = 'FCGS') --may need to include V
		)
	and cr.CONTACT_TYPE <> 'R'
	and cr.REPORT_ID = @ContactReportID
	and cr.ID = @ContactReportTableID

return @IsFaceToFace
end