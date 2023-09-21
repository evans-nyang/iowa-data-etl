WITH fact_invoices AS (
    SELECT * FROM {{ ref('fact_invoices') }}
    WHERE invoice_line_hash IS NOT NULL
),

cities AS (
    SELECT 
        store_hash,
        city
    FROM {{ ref('dim_stores') }}
)

sales AS (
    SELECT
        invoice_line_hash,
        sale_dollars
    FROM {{ ref('dim_sales') }}
),

aggregated AS (
    SELECT 
        cities.city,
        ROUND(SUM(sales.sale_dollars), 2) AS total_sales
    FROM fact_invoices
    JOIN sales ON fact_invoices.invoice_line_hash = sales.invoice_line_hash
    JOIN cities ON fact_invoices.store_hash = cities.store_hash
    GROUP BY cities.city
    ORDER BY total_sales DESC
)

SELECT * FROM aggregated
