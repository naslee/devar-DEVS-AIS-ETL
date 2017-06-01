
CREATE function [DOMetrics].[ConfigurationGetFiscalYear]
(
@inputDate datetime
)
returns int
 as
 begin
 declare @fyReturnValue int

select @fyReturnValue = 
	ConfigurationIntValue
from dbo.CoreConfiguration
where 
 ConfigurationName = 'DOMCFY'
 and @inputDate between ConfigurationStartDate and ConfigurationEndDate

return @fyReturnValue;
end