{{
    config(
        materialized='incremental',
        unique_key='store_hash'
    )
}}

WITH stg_stores AS (
    SELECT * FROM {{ ref('stg_stores') }}
),

final AS (
    SELECT
        store_hash,
        store_no,
        store_name,
        store_address,
        city,
        zipcode,
        latitude,
        longitude
    FROM stg_stores
    {{ check_incremental('store_hash') }}
)

SELECT * FROM final
