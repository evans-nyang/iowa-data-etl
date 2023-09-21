WITH source AS (
    SELECT * FROM {{ source('iowa_data', 'iowa_sales_data') }}
),

stg_sales AS (
    SELECT
        md5(invoice_line_no) as invoice_line_hash,
        state_bottle_cost,
        state_bottle_retail,
        sale_bottles,
        sale_dollars,
        sale_liters,
        sale_gallons
    FROM source
)

SELECT * FROM stg_sales
