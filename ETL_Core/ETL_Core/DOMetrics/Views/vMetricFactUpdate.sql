

CREATE view [DOMetrics].[vMetricFactUpdate]
(
	  AuthorId
	, ArtifactId
	, DepartmentCode
	, FiscalYear
	, MetricType
	, MetricDate
	, DollarsRaised
	, DwSourceKey
	, MetricFactHash
	, ActionType
)
as

select distinct  vf.AuthorId, vf.ArtifactId, vf.DepartmentCode, vf.FiscalYear, vf.MetricType, vf.MetricDate, vf.DollarsRaised, vf.DwSourceKey, vf.MetricFactHash, 'I' actionType
from DOMetrics.vMetricFact vf
left outer join DOMetrics.MetricFact uf
	on vf.ArtifactId = uf.ArtifactId
	and vf.AuthorId = uf.AuthorId
	and vf.MetricType = uf.MetricType
where uf.ArtifactId is null

union all

select distinct  mf.AuthorId, mf.ArtifactId, mf.DepartmentCode, mf.FiscalYear, mf.MetricType, mf.MetricDate, mf.DollarsRaised, mf.DwSourceKey, mf.MetricFactHash,'U' actionType
from DOMetrics.vMetricFact mf
join DOMetrics.MetricFact a 
	on a.ArtifactId = mf.ArtifactId
	and a.AuthorId = mf.AuthorId
	and a.MetricType = mf.MetricType
where mf.MetricFactHash <> a.MetricFactHash

union all

select a.AuthorId, a.ArtifactId, a.DepartmentCode, a.FiscalYear, a.MetricType, a.MetricDate, a.DollarsRaised, a.DwSourceKey, a.MetricFactHash, 'D' actionType--, DwTruthKey--, MetricFactHash
from DOMetrics.MetricFact a
	left outer join DOMetrics.vMetricFact b
		on a.AuthorId = b.AuthorId
		and a.ArtifactId = b.ArtifactId
		and a.MetricType = b.MetricType
where b.ArtifactId is null