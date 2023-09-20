{{
    config(
        materialized='incremental',
        unique_key='vendor_hash'
    )
}}

WITH dim_vendors AS (
    SELECT * FROM {{ ref('stg_vendors') }}
),

final AS (
    SELECT
        vendor_hash,
        vendor_no,
        vendor_name
    FROM dim_vendors
    {{ check_incremental('vendor_hash') }}
)

SELECT * FROM final
