{{
    config(
        materialized='incremental',
        unique_key='store_hash'
    )
}}

WITH stg_stores AS (
    SELECT * FROM {{ ref('stg_stores') }}
),

stg_counties AS (
    SELECT * FROM {{ ref('stg_counties') }}
),

final AS (
    SELECT
        s.store_hash,
        s.store_no,
        s.store_name,
        s.store_address,
        s.city,
        s.zipcode,
        s.latitude,
        s.longitude,
        c.county,
        c.county_number
    FROM stg_stores s
    INNER JOIN stg_counties c ON s.store_hash = c.county_hash
    {{ check_incremental('store_hash') }}
)

SELECT * FROM final
