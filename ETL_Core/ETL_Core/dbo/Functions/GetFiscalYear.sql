CREATE function dbo.GetFiscalYear
(
	@inputDate date
)

returns int
as
begin
declare @fiscalYearReturn int
select distinct @fiscalYearReturn = a.FISCALYEAR
from AIS_Prod.dbo.UCDR_DATE_DIM a
where a.[DATE] = @inputDate
return @fiscalYearReturn
end