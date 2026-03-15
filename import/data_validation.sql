/*===================================================================
    Data Validation Queries for Invoice Management System
===================================================================*/
\echo '======== CHECKING DUPLICATE INVOICES ==========='
SELECT invoice_id, count(*) 
FROM invoices
GROUP BY invoice_id
HAVING count(*) > 1;

\echo '======== CHECKING INVOICES PAID BEFORE APPROVAL ==========='
SELECT i.invoice_id, c.company_name, v.vendor_name, i.paid_date, i.approved_date, i.invoice_amount FROM invoices AS i
JOIN companies AS c ON i.company_id = c.company_id
JOIN vendors AS v ON i.vendor_id = v.vendor_id
WHERE i.paid_date < i.approved_date;

\echo '======== CHECKING PAID STATUS WITHOUT PAID_DATE ===========' 
SELECT invoice_id FROM invoices 
WHERE paid_date IS NULL AND status = 'paid';

\echo '======== CHECKING ORPHAN FOREIGN KEYS ==========='
\echo 'Checking invoice_items referencing missing invoices'
SELECT invoice_id FROM invoice_items 
WHERE invoice_id NOT IN (SELECT invoice_id FROM invoices);

\echo 'Checking payments referencing missing invoices'
SELECT invoice_id FROM payments 
WHERE invoice_id NOT IN (SELECT invoice_id FROM invoices);

\echo 'Checking approvals referencing missing invoices'
SELECT invoice_id FROM approvals
WHERE invoice_id NOT IN (SELECT invoice_id FROM invoices);

\echo 'Checking invoices referencing missing vendors'
SELECT vendor_id FROM invoices 
WHERE vendor_id NOT IN (SELECT vendor_id FROM vendors);

\echo 'Checking invoices referencing missing companies'
SELECT company_id FROM invoices
WHERE company_id NOT IN (SELECT company_id FROM companies);

\echo 'Checking approvals referencing missing approvers'
SELECT approver_id FROM approvals
WHERE approver_id NOT IN (SELECT approver_id FROM approvers);

\echo '======== CHECKING NEGATIVE INVOICE AMOUNTS ==========='
SELECT i.invoice_id, c.company_name, v.vendor_name, i.invoice_amount, i.currency, i.status FROM invoices AS i 
JOIN companies AS c ON i.company_id = c.company_id
JOIN vendors AS v ON i.vendor_id = v.vendor_id
WHERE invoice_amount < 0;
