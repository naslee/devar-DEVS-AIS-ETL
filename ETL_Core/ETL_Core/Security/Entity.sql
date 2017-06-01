CREATE SCHEMA [Entity]
    AUTHORIZATION [dbo];


GO
GRANT SELECT
    ON SCHEMA::[Entity] TO [devar-etl];


GO
GRANT EXECUTE
    ON SCHEMA::[Entity] TO [devar-etl];

