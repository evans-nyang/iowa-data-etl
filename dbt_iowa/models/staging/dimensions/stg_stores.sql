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
        longitude,
        md5(county_number::text) as county_hash,
        md5(vendor_no::text) as vendor_hash
    FROM source
),

stg_counties AS (
    SELECT * FROM {{ ref('stg_counties') }}
),

stg_vendors AS (
    SELECT * FROM {{ ref('stg_vendors') }}
),

staging AS (
    SELECT stg_stores.*,
        stg_counties.county_number,
        stg_vendors.vendor_no
    FROM stg_stores
    LEFT JOIN stg_counties USING (county_hash)
    LEFT JOIN stg_vendors USING (vendor_hash)
)

SELECT * FROM staging
