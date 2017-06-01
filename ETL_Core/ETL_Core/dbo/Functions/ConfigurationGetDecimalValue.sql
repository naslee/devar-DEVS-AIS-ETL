
CREATE function [dbo].[ConfigurationGetDecimalValue]
(
@configurationName nvarchar(50),
@configurationType nvarchar(50)
)
returns decimal(14,2)
 as
 begin
 declare @configurationReturnValue decimal(14,2)

select @configurationReturnValue = 
	ConfigurationDecimalValue
from dbo.CoreConfiguration
where 
 ConfigurationName = @configurationName
and ConfigurationType = @configurationType
and IsActive = 1
return @configurationReturnValue;
end
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ConfigurationGetDecimalValue] TO [devar-etl]
    AS [dbo];

