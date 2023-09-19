WITH source AS (
    SELECT * FROM {{ source('iowa_data', 'iowa_sales_data') }}
),

stg_vendors AS (
    SELECT DISTINCT
        md5(vendor_no::text) as vendor_hash,
        vendor_no,
        vendor_name
    FROM source
)

SELECT * FROM stg_vendors
