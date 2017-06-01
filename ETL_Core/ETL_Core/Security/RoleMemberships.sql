ALTER ROLE [db_securityadmin] ADD MEMBER [dometrics-etl];


GO
ALTER ROLE [db_owner] ADD MEMBER [dometrics-etl];


GO
ALTER ROLE [db_ddladmin] ADD MEMBER [dometrics-etl];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [dometrics-etl];


GO
ALTER ROLE [db_datareader] ADD MEMBER [devar-etl];


GO
ALTER ROLE [db_datareader] ADD MEMBER [devar-reports];


GO
ALTER ROLE [db_datareader] ADD MEMBER [dometrics-etl];


GO
ALTER ROLE [db_backupoperator] ADD MEMBER [OU\DEV-SVC-SQLBackups];


GO
ALTER ROLE [db_backupoperator] ADD MEMBER [dometrics-etl];


GO
ALTER ROLE [db_accessadmin] ADD MEMBER [dometrics-etl];

