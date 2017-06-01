CREATE function DOMetrics.GetContactCountByAssignment
(
    @OfficerId varchar(10)
  , @AssignmentTableId bigint
  , @ContactTypeCode varchar(5)
)
returns int

as

begin

DECLARE @AssignmentCountReturn bigint

select @AssignmentCountReturn = isnull(CountOfContactType,0)
from 
  (
  select distinct      
	  OfficerId    
	, AssignmentId    
	, ProspectId    
	, gfe.ContactType    
	, count(*) over (partition by OfficerId, AssignmentId, gfe.ContactType) CountOfContactType    
	, FiscalYear 
	, a.AssignmentTableId 
   from DOMetrics.vPMRAssigned a    
   join       
		   (       
			   select distinct          AUTHOR_ID_NUMBER        , CONTACT_DATE        , PROSPECT_ID        , CONTACT_TYPE ContactType        , REPORT_ID ReportId        , DOMetrics.FaceToFace_2017(cr.REPORT_ID, cr.ID) isF2F       
			   from AIS_Prod.ADVANCE.CONTACT_REPORT cr       
			   where PROSPECT_ID is not null        
			   and cr.IS_ACTIVE = 1      
		   ) gfe     
	   on  gfe.CONTACT_DATE  >= dateadd(day,dbo.ConfigurationGetIntValue('PAC','Start'), a.AssignmentStart)     
	   and gfe.CONTACT_DATE <= dateadd(day,dbo.ConfigurationGetIntValue('PAC','End'), a.AssignmentStart)     
	   and a.OfficerId = gfe.AUTHOR_ID_NUMBER     
	   and a.ProspectId = gfe.PROSPECT_ID           
   
where a.OfficerId = @OfficerId
and a.AssignmentTableId = @AssignmentTableId
and gfe.ContactType = @ContactTypeCode
)a
return @AssignmentCountReturn;
end;