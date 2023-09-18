WITH source AS (
    SELECT * FROM {{ source('iowa_data', 'iowa_sales_data') }}
),

stg_stores AS (
    SELECT DISTINCT
        md5(store_no::text) as store_hash,
        store_no,
        store_name,
        store_address,
        city,
        zipcode,
        latitude,
        longitude
    FROM source
)

SELECT * FROM stg_stores
