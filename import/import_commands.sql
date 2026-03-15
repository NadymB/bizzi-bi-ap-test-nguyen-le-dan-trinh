/*===================================================================
                Import CSV files into the database
===================================================================*/

-- Import CSV files into the database using the \copy command in psql
\copy companies FROM 'bizzi_junior_ap_dataset/companies.csv' DELIMITER ',' CSV HEADER
\copy vendors FROM 'bizzi_junior_ap_dataset/vendors.csv' DELIMITER ',' CSV HEADER
\copy approvers FROM 'bizzi_junior_ap_dataset/approvers.csv' DELIMITER ',' CSV HEADER
\copy currency_rates FROM 'bizzi_junior_ap_dataset/currency_rates.csv' DELIMITER ',' CSV HEADER
\copy invoices FROM 'bizzi_junior_ap_dataset/invoices.csv' DELIMITER ',' CSV HEADER
\copy invoice_items FROM 'bizzi_junior_ap_dataset/invoice_items.csv' DELIMITER ',' CSV HEADER
\copy payments FROM 'bizzi_junior_ap_dataset/payments.csv' DELIMITER ',' CSV HEADER
\copy approvals FROM 'bizzi_junior_ap_dataset/approvals.csv' DELIMITER ',' CSV HEADER

-- Check the number of records imported into each table
SELECT count(*) AS count_companies FROM companies;
SELECT count(*) AS count_vendors FROM vendors;
SELECT count(*) AS count_approvers FROM approvers;
SELECT count(*) AS count_currency_rates FROM currency_rates;
SELECT count(*) AS count_invoices FROM invoices;
SELECT count(*) AS count_invoice_items FROM invoice_items;
SELECT count(*) AS count_payments FROM payments;
SELECT count(*) AS count_approvals FROM approvals;