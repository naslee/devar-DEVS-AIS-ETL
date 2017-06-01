CREATE function [dbo].[ConfigurationGetCharValue]
(
@configurationName nvarchar(50),
@configurationType nvarchar(50)
)
returns varchar(50)
 as
 begin
 declare @configurationReturnValue varchar(50)

select @configurationReturnValue = 
	ConfigurationCharValue
from dbo.CoreConfiguration
where 
 ConfigurationName = @configurationName
and ConfigurationType = @configurationType
and IsActive = 1
return @configurationReturnValue;
end
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ConfigurationGetCharValue] TO [devar-etl]
    AS [dbo];

