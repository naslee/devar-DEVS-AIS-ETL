CREATE TABLE [dbo].[CoreConfiguration] (
    [ID]                        INT             IDENTITY (1, 1) NOT NULL,
    [ConfigurationName]         NVARCHAR (50)   NULL,
    [ConfigurationType]         NVARCHAR (50)   NOT NULL,
    [ConfigurationDateValue]    DATETIME        NULL,
    [ConfigurationCharValue]    NVARCHAR (50)   NULL,
    [ConfigurationIntValue]     INT             NULL,
    [ConfigurationStartDate]    DATETIME        NOT NULL,
    [ConfigurationEndDate]      DATETIME        NULL,
    [Description]               NVARCHAR (MAX)  NOT NULL,
    [IsActive]                  BIT             NULL,
    [ConfigurationDecimalValue] DECIMAL (14, 2) NULL
);

