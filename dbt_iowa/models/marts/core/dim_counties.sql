{{
    config(
        materialized='incremental',
        unique_key='county_hash'
    )
}}

WITH dim_counties AS (
    SELECT * FROM {{ ref('stg_counties') }}
),

final AS (
    SELECT
        county_hash,
        county,
        county_number
    FROM dim_counties
    {{ check_incremental('county_hash') }}
)

SELECT * FROM final
