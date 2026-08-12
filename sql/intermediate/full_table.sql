CREATE TABLE inter.category AS 
WITH cte AS (
        SELECT "Category", "Original Description" FROM staging.checking GROUP BY "Category", "Original Description"
        UNION 
        SELECT "Category", "Original Description" FROM staging.tax_account GROUP BY "Category", "Original Description" 
        UNION 
        SELECT "Category", "Original Description" FROM staging.true_saving GROUP BY "Category", "Original Description"

)
SELECT
        nextval('serial') as account_id,
        *
        --nextval('serial') AS category_id
FROM cte GROUP BY "Category", "Original Description", "account_id";
