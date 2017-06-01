
CREATE function [DOMetrics].[GetUnitName]
	(
	@UnitCode varchar(16)
	)
returns varchar(100)
as

begin

declare @returnUnitName varchar(16)

select  @returnUnitName = a.[name]
from DOMetrics.vUnitFact a
	
 where a.unitCode = @UnitCode


 return @returnUnitName
 end