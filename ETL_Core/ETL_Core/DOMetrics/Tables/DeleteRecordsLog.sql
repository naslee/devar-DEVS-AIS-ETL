CREATE TABLE [DOMetrics].[DeleteRecordsLog] (
    [AuthorId]           NVARCHAR (10)    NULL,
    [DepartmentCode]     NVARCHAR (5)     NULL,
    [FiscalYear]         INT              NULL,
    [MetricType]         NVARCHAR (10)    NULL,
    [MetricDate]         DATETIME         NULL,
    [DollarsRaised]      FLOAT (53)       NULL,
    [DwSourceKey]        UNIQUEIDENTIFIER NULL,
    [MetricFactHash]     BIGINT           NULL,
    [outputKey]          VARCHAR (1)      NULL,
    [ActionType]         VARCHAR (1)      NULL,
    [ArtifactId]         BIGINT           NULL,
    [convDwSourceKey]    VARCHAR (50)     NULL,
    [convMetricType]     VARCHAR (10)     NULL,
    [convAuthorId]       VARCHAR (10)     NULL,
    [convDepartmentCode] VARCHAR (5)      NULL,
    [dwTruthKeyDer]      VARCHAR (50)     NULL
);

