INSTALL postgres;
LOAD postgres;
ATTACH 'dbname=fmart user=pretender host=/run/user/1000/devenv-e38e48e/postgres/' AS postgres_db(TYPE postgres);
CREATE
OR REPLACE TABLE postgres_db.staging.true_saving AS SELECT
        *
FROM
        read_csv('./data/true_savings.csv');
CREATE
OR REPLACE TABLE postgres_db.staging.checking AS SELECT
        *
FROM
        read_csv('./data/checking.csv');
CREATE
OR REPLACE TABLE postgres_db.staging.tax_account AS SELECT
        *
FROM
        read_csv('./data/tax_account.csv');
