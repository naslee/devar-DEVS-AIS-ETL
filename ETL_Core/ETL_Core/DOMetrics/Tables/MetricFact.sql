CREATE TABLE [DOMetrics].[MetricFact] (
    [AuthorId]       NVARCHAR (10)    NOT NULL,
    [ArtifactId]     BIGINT           NOT NULL,
    [DepartmentCode] NVARCHAR (5)     NOT NULL,
    [FiscalYear]     INT              NOT NULL,
    [MetricType]     NVARCHAR (10)    NOT NULL,
    [MetricDate]     DATETIME         NULL,
    [DollarsRaised]  FLOAT (53)       NULL,
    [DwSourceKey]    UNIQUEIDENTIFIER NOT NULL,
    [DwTruthKey]     UNIQUEIDENTIFIER CONSTRAINT [PK_METRIC_FACT_GUID_SEQ] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [MetricFactHash] BIGINT           NULL,
    CONSTRAINT [PK_METRIC_FACT_GUID] PRIMARY KEY NONCLUSTERED ([DwTruthKey] ASC) WITH (FILLFACTOR = 80)
);

