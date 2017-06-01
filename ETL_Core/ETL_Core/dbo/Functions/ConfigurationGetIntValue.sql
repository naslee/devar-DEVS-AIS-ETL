CREATE function [dbo].[ConfigurationGetIntValue]
(
@configurationName nvarchar(50),
@configurationType nvarchar(50)
)
returns int
 as
 begin
 declare @configurationReturnValue int

select @configurationReturnValue = 
	ConfigurationIntValue
from dbo.CoreConfiguration
where 
 ConfigurationName = @configurationName
and ConfigurationType = @configurationType
and IsActive = 1
return @configurationReturnValue;
end