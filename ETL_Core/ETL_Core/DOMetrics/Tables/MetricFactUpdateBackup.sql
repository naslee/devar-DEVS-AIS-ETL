CREATE TABLE [DOMetrics].[MetricFactUpdateBackup] (
    [AuthorId]       NVARCHAR (10)    NULL,
    [ArtifactId]     BIGINT           NULL,
    [DepartmentCode] NVARCHAR (16)    NULL,
    [FiscalYear]     INT              NULL,
    [MetricType]     NVARCHAR (10)    NULL,
    [MetricDate]     DATETIME2 (7)    NULL,
    [DollarsRaised]  FLOAT (53)       NULL,
    [DwSourceKey]    UNIQUEIDENTIFIER NULL,
    [MetricFactHash] BIGINT           NULL,
    [ActionType]     VARCHAR (1)      NOT NULL
);

