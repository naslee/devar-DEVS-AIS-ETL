
CREATE procedure [DOMetrics].[Metric_GetTruthKey]
	@AuthorId varchar(10),
	@ArtifactId int,
	@DepartmentCode varchar(50),
	@FiscalYear int,
	@MetricType varchar(10),
	@dwTruthKey varchar(38) OUTPUT

as
select @dwTruthKey = '{'+convert(varchar(36),DwTruthKey)+'}'

from DOMetrics.MetricFact

where 
	@AuthorId = AuthorId and
	@ArtifactId = ArtifactId and
	--@DepartmentCode = DepartmentCode and
	@FiscalYear = FiscalYear and
	@MetricType = MetricType