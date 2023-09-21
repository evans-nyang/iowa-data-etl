{{
    config(
        materialized='incremental',
        unique_key='category_hash'
    )
}}

WITH dim_categories AS (
    SELECT * FROM {{ ref('stg_categories') }}
),

final AS (
    SELECT
        category_hash,
        category,
        category_name
    FROM dim_categories
    {{ check_incremental('category_hash') }}
)

SELECT * FROM final
