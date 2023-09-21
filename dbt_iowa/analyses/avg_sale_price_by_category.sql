WITH fact_invoices AS (
    SELECT * FROM {{ ref('fact_invoices') }}
    WHERE invoice_line_hash IS NOT NULL
),

categories AS (
    SELECT 
        category_hash,
        category,
        category_name
    FROM {{ ref('dim_categories') }}
),

sales AS (
    SELECT
        invoice_line_hash,
        state_bottle_retail
    FROM {{ ref('dim_sales') }}
),

aggregated AS (
    SELECT 
        categories.category
        categories.category_name,
        ROUND(AVG(sales.state_bottle_retail), 2) AS average_sale_price
    FROM fact_invoices
    JOIN sales ON fact_invoices.invoice_line_hash = sales.invoice_line_hash
    JOIN categories ON fact_invoices.category_hash = categories.category_hash
    GROUP BY categories.category_name
    ORDER BY average_sale_price DESC
)

SELECT * FROM aggregated
