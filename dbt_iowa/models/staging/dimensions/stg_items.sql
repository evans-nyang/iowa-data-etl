WITH source AS (
    SELECT * FROM {{ source('iowa_data', 'iowa_sales_data') }}
),

stg_items AS (
    SELECT DISTINCT
        md5(item_no::text) as item_hash,
        item_no,
        im_desc,
        pack,
        bottle_volume_ml,
        md5(category::text) as category_hash
    FROM source
),

stg_categories AS (
    SELECT * FROM {{ ref('stg_categories') }}
),

final AS (
    SELECT
        stg_items.*,
        stg_categories.category_name
    FROM stg_items
    LEFT JOIN stg_categories USING (category_hash)
)

SELECT * FROM final
