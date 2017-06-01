CREATE function [dbo].[ConfigurationGetDateValue]
(
@configurationName nvarchar(50),
@configurationType nvarchar(50)
)
returns datetime
 as
 begin
 declare @configurationReturnValue datetime

select @configurationReturnValue = 
	ConfigurationIntValue
from dbo.CoreConfiguration
where 
 ConfigurationName = @configurationName
and ConfigurationType = @configurationType
and IsActive = 1
return @configurationReturnValue;
end