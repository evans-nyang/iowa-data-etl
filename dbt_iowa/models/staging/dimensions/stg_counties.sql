WITH source AS (
    SELECT * FROM {{ source('iowa_data', 'iowa_sales_data') }}
),

stg_counties AS (
    SELECT DISTINCT
        md5(county_number::text) as county_hash,
        county_number,
        county
    FROM source
)

SELECT * FROM stg_counties
