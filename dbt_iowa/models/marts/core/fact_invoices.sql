{{
    config(
        materialized='incremental',
        unique_key='invoice_date_hash'
    )
}}


WITH stg_invoices AS (
    SELECT * FROM {{ ref('stg_invoices') }}
),

dim_items AS (
    SELECT * FROM {{ ref('dim_items') }}
),

dim_stores AS (
    SELECT * FROM {{ ref('dim_stores') }}
),

dim_sales AS (
    SELECT * FROM {{ ref('stg_sales') }}
),

dim_vendors AS (
    SELECT * FROM {{ ref('stg_vendors') }}
),

dim_counties AS (
    SELECT * FROM {{ ref('stg_counties') }}
),

dim_categories AS (
    SELECT * FROM {{ ref('stg_categories') }}
),

_intermediate AS (
    SELECT 
        *
    FROM stg_invoices
    LEFT JOIN dim_stores USING (store_hash)
    LEFT JOIN dim_items USING (item_hash)
    LEFT JOIN dim_sales USING (invoice_line_hash)
    LEFT JOIN dim_vendors USING (vendor_hash)
    LEFT JOIN dim_counties USING (county_hash)
    LEFT JOIN dim_categories USING (category_hash)
),

final AS (
    SELECT
        date,
        invoice_date_hash,
        invoice_line_hash,
        store_hash,
        category_hash,
        item_hash,
        vendor_hash,
        county_hash
    FROM _intermediate
    {{ check_incremental('invoice_date_hash') }}
)

SELECT * FROM final
