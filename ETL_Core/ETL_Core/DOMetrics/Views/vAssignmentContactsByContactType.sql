CREATE view DOMetrics.vAssignmentContactsByContactType
(
	  OfficerId
	, AssignmentId
	, ProspectId
	, ContactType
	, ContactDescription
	, CountOfContactType
	, FiscalYear
	, AssignmentTableId
)
as


  select distinct      
	  OfficerId    
	, AssignmentId    
	, ProspectId    
	, gfe.ContactType    
	, ContactType.ContactDescription    
	, count(ReportId) over (partition by OfficerId, AssignmentId, gfe.ContactType) CountOfContactType    
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
   join       
		(       
			select         
			ADV_TABLE_CODE ContactType        
			, replace(replace(ADV_SHORT_DESC,' ', ''),'/','') ContactDescription       
			from AIS_Prod.ADVANCE.ZZ_ADV_TABLE       
			where ADV_TABLE_TYPE = 'V1'        
			and IS_ACTIVE = 1      
		) ContactType     
		on ContactType.ContactType = gfe.ContactType