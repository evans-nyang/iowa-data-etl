{{
    config(
        materialized='incremental',
        unique_key='item_hash',
        sort='item_hash'
    )
}}

WITH stg_items AS (
    SELECT * FROM {{ ref('stg_items') }}
),

dim_items AS (
    SELECT
        item_hash,
        item_no,
        im_desc,
        pack,
        bottle_volume_ml
    FROM stg_items
    {{ check_incremental('item_hash') }}
)

SELECT * FROM dim_items
