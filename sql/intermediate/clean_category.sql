DROP SEQUENCE category_id;
CREATE SEQUENCE category_id;

CREATE OR REPlACE TABLE inter.clean_category AS
WITH cte AS (
    SELECT trim(lower("Category")) AS category
    FROM
        inter.full_table
    GROUP BY "Category"
)

SELECT
    nextval('category_id')::INT AS category_id,
    cte.category::VARCHAR as category_description,
    CASE
        WHEN
            cte.category
            IN (
                'paycheck', 'income',
                'taxes', 'federal tax', 'student loan',
                'groceries', 'doctor', 'mortgage & rent'
            )

            THEN 1
        ELSE 0
    END AS category_essential
FROM cte;

SELECT * FROM inter.clean_category;
