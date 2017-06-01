CREATE TABLE [performance].[Activity] (
    [ID]                INT           IDENTITY (1, 1) NOT NULL,
    [ProcessName]       VARCHAR (100) NOT NULL,
    [SystemName]        VARCHAR (100) NOT NULL,
    [OperationType]     VARCHAR (50)  NULL,
    [ActivityType]      VARCHAR (50)  NULL,
    [Step]              VARCHAR (50)  NULL,
    [SourceObject]      VARCHAR (100) NOT NULL,
    [SourceIdentifier]  VARCHAR (100) NULL,
    [SourceDescription] VARCHAR (MAX) NULL,
    [Severity]          INT           NULL,
    [Outcome]           VARCHAR (50)  NULL,
    [ActivityTimestamp] DATETIME      DEFAULT (getdate()) NOT NULL,
    [ActivityCount]     BIGINT        NULL
);

