WITH fact_invoices AS (
    SELECT * FROM {{ ref('fact_invoices') }}
    WHERE invoice_line_hash IS NOT NULL
),

sales AS (
    SELECT
        invoice_line_hash,
        sale_dollars
    FROM {{ ref('dim_sales') }}
),

aggregated AS (
    SELECT 
        date,
        ROUND(SUM(sales.sale_dollars), 2) AS total_sales
    FROM fact_invoices
    JOIN sales ON fact_invoices.invoice_line_hash = sales.invoice_line_hash
    GROUP BY date
    ORDER BY date DESC
)

SELECT * FROM aggregated
