CREATE TYPE [dbo].[StringListTableType] AS TABLE (
    [item] NVARCHAR (255) NOT NULL);


GO
GRANT VIEW DEFINITION
    ON TYPE::[dbo].[StringListTableType] TO [devar-etl];


GO
GRANT EXECUTE
    ON TYPE::[dbo].[StringListTableType] TO [devar-etl];

