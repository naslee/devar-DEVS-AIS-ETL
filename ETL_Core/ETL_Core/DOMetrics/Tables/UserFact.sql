CREATE TABLE [DOMetrics].[UserFact] (
    [userTypeCode] NVARCHAR (50) NULL,
    [entityId]     NVARCHAR (10) NULL,
    [firstName]    NVARCHAR (50) NULL,
    [lastName]     NVARCHAR (50) NULL,
    [ldapId]       NVARCHAR (16) NULL,
    [userHash]     INT           NULL
);

