/*===================================================================
    Data Validation Queries for Invoice Management System
===================================================================*/
\echo '======== CHECKING DUPLICATE INVOICES ==========='
SELECT invoice_id, count(*) 
FROM invoices
GROUP BY invoice_id
HAVING count(*) > 1;

\echo '======== CHECKING INVOICES PAID BEFORE APPROVAL ==========='
SELECT 
    i.invoice_id, 
    c.company_name, 
    v.vendor_name, 
    i.paid_date, 
    i.approved_date, 
    i.invoice_amount 
FROM invoices AS i
JOIN companies AS c 
    ON i.company_id = c.company_id
JOIN vendors AS v 
    ON i.vendor_id = v.vendor_id
WHERE i.paid_date < i.approved_date;

\echo '======== CHECKING PAID STATUS WITHOUT PAID_DATE ===========' 
SELECT invoice_id 
FROM invoices 
WHERE paid_date IS NULL AND status = 'paid';

\echo '======== CHECKING ORPHAN FOREIGN KEYS ==========='
\echo 'Checking invoice_items referencing missing invoices'
SELECT ii.invoice_id 
FROM invoice_items AS ii
WHERE NOT EXISTS (
    SELECT 1 
    FROM invoices AS i
    WHERE ii.invoice_id = i.invoice_id
);

\echo 'Checking payments referencing missing invoices'
SELECT p.invoice_id 
FROM payments AS p
WHERE NOT EXISTS (
    SELECT 1 
    FROM invoices AS i
    WHERE p.invoice_id = i.invoice_id
);

\echo 'Checking approvals referencing missing invoices'
SELECT a.invoice_id 
FROM approvals AS a
WHERE NOT EXISTS (
    SELECT 1 
    FROM invoices AS i
    WHERE a.invoice_id = i.invoice_id
);

\echo 'Checking invoices referencing missing vendors'
SELECT i.vendor_id 
FROM invoices AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM vendors AS v
    WHERE i.vendor_id = v.vendor_id
);

\echo 'Checking invoices referencing missing companies'
SELECT i.company_id 
FROM invoices AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM companies AS c
    WHERE i.company_id = c.company_id
);

\echo 'Checking approvals referencing missing approvers'
SELECT a.approver_id 
FROM approvals AS a
WHERE NOT EXISTS (
    SELECT 1 
    FROM approvers AS ap
    WHERE a.approver_id = ap.approver_id
);

\echo '======== CHECKING NEGATIVE INVOICE AMOUNTS ==========='
SELECT 
    i.invoice_id, 
    c.company_name, 
    v.vendor_name, 
    i.invoice_amount, 
    i.currency, 
    i.status 
FROM invoices AS i 
JOIN companies AS c 
    ON i.company_id = c.company_id
JOIN vendors AS v 
    ON i.vendor_id = v.vendor_id
WHERE invoice_amount < 0;
