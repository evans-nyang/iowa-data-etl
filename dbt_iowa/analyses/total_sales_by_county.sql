WITH fact_invoices AS (
    SELECT * FROM {{ ref('fact_invoices') }}
    WHERE invoice_line_hash IS NOT NULL
),

counties AS (
    SELECT 
        county_hash,
        county,
        county_number
    FROM {{ ref('dim_counties') }}
),

sales AS (
    SELECT
        invoice_line_hash,
        sale_dollars
    FROM {{ ref('dim_sales') }}
),

aggregated AS (
    SELECT 
        counties.county_number,
        counties.county,
        ROUND(SUM(sales.sale_dollars), 2) AS total_sales
    FROM fact_invoices
    JOIN sales ON fact_invoices.invoice_line_hash = sales.invoice_line_hash
    JOIN counties ON fact_invoices.county_hash = counties.county_hash
    GROUP BY counties.county
    ORDER BY total_sales DESC
)

SELECT * FROM aggregated
