WITH source AS (
    SELECT * FROM {{ source('iowa_data', 'iowa_sales_data') }}
),

stg_items AS (
    SELECT 
        md5(item_no::text) as item_hash,
        item_no,
        im_desc,
        pack,
        bottle_volume_ml
    FROM source
)

SELECT * FROM stg_items
