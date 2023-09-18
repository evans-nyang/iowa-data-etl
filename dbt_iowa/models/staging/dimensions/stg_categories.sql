WITH source AS (
    SELECT * FROM {{ source('iowa_data', 'iowa_sales_data') }}
),

stg_categories AS (
    SELECT DISTINCT
        md5(category::text) as category_hash,
        category,
        category_name
    FROM source
)

SELECT * FROM stg_categories
