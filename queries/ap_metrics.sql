/*===================================================================
                Accounts Payable Metrics Queries
===================================================================*/

-- 1. Average Approval Time (monthly)
\echo '======== AVERAGE APPROVAL TIME (MONTHLY) ==========='
SELECT 
    DATE_TRUNC('month', received_date)::DATE AS month,
    AVG(approved_date - received_date) AS avg_approval_time_days
FROM invoices
WHERE approved_date IS NOT NULL
GROUP BY month
ORDER BY month;

-- 2. Percentage Late Payments
\echo '======== PERCENTAGE LATE PAYMENTS ==========='
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN paid_date > due_date THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS late_payment_percentage
FROM invoices
WHERE paid_date IS NOT NULL AND due_date IS NOT NULL AND invoice_amount > 0;

-- 3. Invoice Aging Buckets
\echo '======== INVOICE AGING BUCKETS ==========='
SELECT
    CASE
        WHEN paid_date IS NULL THEN 'Unpaid'
        WHEN due_date IS NULL THEN 'Unknown Due Date'
        WHEN invoice_amount < 0 THEN 'Credit Note'
        WHEN paid_date - due_date <= 0 THEN 'Current'
        WHEN paid_date - due_date <= 30 THEN '1-30 days'
        WHEN paid_date - due_date <= 60 THEN '31-60 days'
        WHEN paid_date - due_date <= 90 THEN '61-90 days'
        ELSE '90+ days'
    END AS aging_bucket,
    COUNT(*) AS invoice_count,
    SUM(invoice_amount) AS total_amount
FROM invoices
GROUP BY 1
ORDER BY aging_bucket DESC;

-- 4. Total Spend by Vendor Category
\echo '======== TOTAL SPEND BY VENDOR CATEGORY ==========='
SELECT 
    v.vendor_category,
    SUM(i.invoice_amount) AS total_spend
FROM invoices AS i 
JOIN vendors AS v ON i.vendor_id = v.vendor_id 
GROUP BY v.vendor_category
ORDER BY total_spend DESC;

-- 5. Top 10 Vendors by Spend
\echo '======== TOP 10 VENDOR BY SPEND ==========='
SELECT 
    v.vendor_name,
    SUM(i.invoice_amount * cr.rate_to_usd) AS total_spend_usd
FROM invoices AS i
JOIN vendors AS v 
    ON i.vendor_id = v.vendor_id
JOIN currency_rates AS cr
    ON i.currency = cr.currency
GROUP BY v.vendor_name
ORDER BY total_spend_usd DESC;