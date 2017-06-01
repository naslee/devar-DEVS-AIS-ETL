CREATE TABLE [log].[execution_history] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [startTime]       DATETIME       NOT NULL,
    [endTime]         DATETIME       NULL,
    [systemName]      VARCHAR (100)  NOT NULL,
    [dbName]          VARCHAR (100)  NULL,
    [schemaName]      VARCHAR (100)  NULL,
    [objectName]      VARCHAR (100)  NOT NULL,
    [operationType]   VARCHAR (10)   NOT NULL,
    [step]            VARCHAR (500)  NULL,
    [msg]             VARCHAR (1000) NULL,
    [count]           INT            NULL,
    [isError]         BIT            DEFAULT ((0)) NOT NULL,
    [operationStatus] VARCHAR (100)  NULL,
    [currentUser]     VARCHAR (100)  DEFAULT (suser_sname()) NOT NULL
);

