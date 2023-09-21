WITH fact_invoices AS (
    SELECT * FROM {{ ref('fact_invoices') }}
    WHERE invoice_line_hash IS NOT NULL
),

vendors AS (
    SELECT 
        vendor_hash,
        vendor_no,
        vendor_name
    FROM {{ ref('dim_vendors') }}
),

sales AS (
    SELECT
        invoice_line_hash,
        sale_dollars
    FROM {{ ref('dim_sales') }}
),

aggregated AS (
    SELECT 
        vendors.vendor_no,
        vendors.vendor_name,
        ROUND(SUM(sales.sale_dollars), 2) AS total_sales
    FROM fact_invoices
    JOIN sales ON fact_invoices.invoice_line_hash = sales.invoice_line_hash
    JOIN vendors ON fact_invoices.vendor_hash = vendors.vendor_hash
    GROUP BY vendors.vendor_no
    ORDER BY total_sales DESC
)

SELECT * FROM aggregated
