

CREATE FUNCTION [Entity].[Degree_GetDegreeCodeYears]
(
  @IdNumber varchar(10)
)
RETURNS varchar(max)
AS
BEGIN
  declare @returnValue varchar(max)
		, @degreeCodeYears varchar(max);

  --set @degreeCodeYears = ' '


	SELECT DISTINCT @degreeCodeYears =  
		STUFF(
				(
					select CONCAT(';' , d1.DEGREE_CODE , ' ', td.ADV_DETAIL1 , ' ',  substring(d1.DEGREE_YEAR,3,2)  )
					from AIS_Prod.ADVANCE.[DEGREES] d1 
					where IS_ACTIVE = 1 
					and d1.ID_NUMBER = d.ID_NUMBER 
					FOR XML PATH ('')
				)
			  ,1,1,''
			)
	
FROM AIS_Prod.ADVANCE.[DEGREES] d
	LEFT OUTER JOIN AIS_Prod.[ADVANCE].[ZZ_ADV_TABLE] tg 
		ON d.DEGREE_CODE = tg.ADV_TABLE_CODE 
		AND tg.ADV_TABLE_TYPE = 'AV'  /* !TODO */ --Switch to TMS view
		AND tg.IS_ACTIVE = 1
    
	LEFT OUTER JOIN AIS_Prod.[ADVANCE].[ZZ_ADV_TABLE] td 
		ON d.MAJOR_CODE1 = td.ADV_TABLE_CODE 
		AND td.ADV_TABLE_TYPE = 'AU' /* !TODO */ --Switch to TMS view
		AND td.IS_ACTIVE = 1

 WHERE d.LOCAL_IND = 'Y'
	   AND d.ID_NUMBER = REPLICATE('0', 10 - len(@IdNumber)) + @IdNumber
       AND d.DEGREE_LEVEL_CODE <> 'N' -- No Degree Earned
	   and d.IS_ACTIVE = 1;
		 
  select @returnValue = @degreeCodeYears

RETURN(@returnValue);
END;