WITH fact_invoices AS (
    SELECT * FROM {{ ref('fact_invoices') }}
    WHERE invoice_line_hash IS NOT NULL
),

stores AS (
    SELECT 
        store_hash,
        store_no,
        store_name
    FROM {{ ref('dim_stores') }}
),

sales AS (
    SELECT
        invoice_line_hash,
        sale_dollars
    FROM {{ ref('dim_sales') }}
),

aggregated AS (
    SELECT 
        stores.store_no,
        stores.store_name,
        ROUND(SUM(sales.sale_dollars), 2) AS total_sales
    FROM fact_invoices
    JOIN sales ON fact_invoices.invoice_line_hash = sales.invoice_line_hash
    JOIN stores ON fact_invoices.store_hash = stores.store_hash
    GROUP BY stores.store_no
    ORDER BY total_sales DESC
)

SELECT * FROM aggregated
