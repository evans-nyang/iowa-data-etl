WITH source AS (
    SELECT * FROM {{ source('iowa_data', 'iowa_sales_data') }}
),

stg_invoices AS (
    SELECT
        invoice_line_no,
        date,
        md5(invoice_line_no) as invoice_line_hash,
        md5(store_no::text) as store_hash,
        md5(category::text) as category_hash,
        md5(vendor_no::text) as vendor_hash,
        md5(county_number::text) as county_hash,
        md5(item_no::text) as item_hash
    FROM source
),

inter_proxy AS (
    SELECT
        stg_invoices.*,
        {{ dbt_utils.surrogate_key(['invoice_line_no', 'date']) }} as invoice_date_hash
    FROM stg_invoices
),

final AS (
    SELECT
        inter_proxy.*,
        ROW_NUMBER() OVER (PARTITION BY invoice_date_hash ORDER BY invoice_date_hash) as invoice_line_id
    FROM inter_proxy
)

SELECT * FROM final
