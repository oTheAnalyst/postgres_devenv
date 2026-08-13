DROP SEQUENCE transaction_id;
DROP TABLE inter.clean_transaction;
CREATE SEQUENCE transaction_id;
CREATE TABLE inter.clean_transaction AS
WITH cte AS (
        SELECT
                TRIM(LOWER("Category")) AS category
        FROM
                inter.full_table
        GROUP BY
                "Category"
) SELECT
        cte.category as transaction,
        nextval('transaction_id') AS category_id
FROM
        cte WHERE category IN(
                        'transfer', 
                 'interest income'

                );
SELECT
        *
FROM
        inter.clean_transaction;
