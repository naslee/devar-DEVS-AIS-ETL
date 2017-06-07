

CREATE FUNCTION [Entity].[Degree_GetDegreeCodeYears]
(
  @IdNumber varchar(10)
)
RETURNS varchar(max)
AS
BEGIN
  declare @returnValue varchar(max)
		, @degreeCodeYears varchar(max);

	SELECT top 1 @degreeCodeYears =  

		STUFF(
				(
					select CONCAT(
					';' , 
					isnull(dbo.ConfigurationGetCharValue(d1.DEGREE_CODE,'DegreeAbbrev'), d1.DEGREE_CODE) , 
					case 
						when d1.DEGREE_LEVEL_CODE = 'U' 
							then '' 
						else ' '
							end, 
					case 
						when d1.DEGREE_LEVEL_CODE = 'U' 
							then '' 
						else td.ADV_DETAIL1 
							end ,
					case 
						when d1.DEGREE_LEVEL_CODE = 'U' 
							then '' 
						else ' '
							end,  
					case 
						when d1.DEGREE_LEVEL_CODE = 'U' 
							then '' 
						else substring(d1.DEGREE_YEAR,3,2) 
							end  
						)
					from AIS_Prod.ADVANCE.[DEGREES] d1 
					where IS_ACTIVE = 1 
					and d1.ID_NUMBER = d.ID_NUMBER
					and d1.INSTITUTION_CODE like '001313%' 
					FOR XML PATH ('')
				)
			  ,1,1,''
			)
			
	
FROM AIS_Prod.ADVANCE.[DEGREES] d
    
	LEFT OUTER JOIN AIS_Prod.[ADVANCE].[ZZ_ADV_TABLE] td 
		ON d.MAJOR_CODE1 = td.ADV_TABLE_CODE 
		AND td.ADV_TABLE_TYPE = 'AU' /* !TODO */ --Switch to TMS view
		AND td.IS_ACTIVE = 1
		AND d.DEGREE_LEVEL_CODE <> 'U'

 WHERE d.LOCAL_IND = 'Y'
	   AND d.ID_NUMBER = REPLICATE('0', 10 - len(@IdNumber)) + @IdNumber
       AND d.DEGREE_LEVEL_CODE <> 'N' -- No Degree Earned
	   and d.IS_ACTIVE = 1
	   and d.INSTITUTION_CODE like '001313%'
	   
ORDER BY XSEQUENCE DESC;
		 
  select @returnValue = @degreeCodeYears

RETURN(@returnValue);
END;