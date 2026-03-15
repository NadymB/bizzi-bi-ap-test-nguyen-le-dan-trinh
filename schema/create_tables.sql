/*===================================================================
            An Accounts Payable Management System Schema 
===================================================================*/

-- Creating the data model for the invoice management system

-- Create the structure of various tables in the invoice database
-- Table: companies: store information Bizzi's subsidiaries they manage within the system
DROP TABLE IF EXISTS companies CASCADE;
CREATE TABLE companies (
    company_id SERIAL PRIMARY KEY, 
    company_name VARCHAR(100) NOT NULL,
    industry VARCHAR(50),
    country VARCHAR(50)
);

-- Table: vendors: store information about the vendors that  invoiced
DROP TABLE IF EXISTS vendors CASCADE;
CREATE TABLE vendors (
    vendor_id SERIAL PRIMARY KEY, 
    vendor_name VARCHAR(100) NOT NULL,
    vendor_category VARCHAR(50),
    country VARCHAR(50),
    payment_terms_days INT NOT NULL
);

-- Table: invoices (fact table): store information about invoices received from vendors
DROP TYPE IF EXISTS invoice_status CASCADE;
CREATE TYPE invoice_status AS ENUM (
    'approved',
    'paid',
    'submitted'
);

DROP TABLE IF EXISTS invoices CASCADE;
CREATE TABLE invoices (
    invoice_id SERIAL PRIMARY KEY, 
    company_id INT NOT NULL,
    vendor_id INT NOT NULL,
    issue_date DATE NOT NULL,
    received_date DATE NOT NULL,
    due_date DATE,
    approved_date DATE,
    paid_date DATE,
    invoice_amount NUMERIC(10, 2) NOT NULL,
    currency CHAR(3) NOT NULL,
    status invoice_status NOT NULL,
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);

-- Table: invoice_items: store information about details of expenses in each invoice 
DROP TABLE IF EXISTS invoice_items CASCADE;
CREATE TABLE invoice_items (
    invoice_item_id SERIAL PRIMARY KEY, 
    invoice_id INT NOT NULL,
    category VARCHAR(50),
    amount NUMERIC(10, 2) CHECK (amount >= 0),
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
); 

-- Table: payments: store payment information for each invoice
DROP TABLE IF EXISTS payments CASCADE;
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY, 
    invoice_id INT NOT NULL,
    payment_method VARCHAR(50),
    bank_fee NUMERIC(10, 2),
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);

-- Table: approvers: store information about approvers of invoices
DROP TABLE IF EXISTS approvers CASCADE;
CREATE TABLE approvers (
    approver_id SERIAL PRIMARY KEY, 
    approver_name VARCHAR(100),
    department VARCHAR(50),
    level INT
);

-- Table: invoice_approvals: store information about which approver approved which invoice and when
DROP TABLE IF EXISTS approvals CASCADE;
CREATE TABLE approvals (
    approval_id SERIAL PRIMARY KEY, 
    invoice_id INT NOT NULL,
    approver_id INT NOT NULL,
    approval_level INT,
    approval_at TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    FOREIGN KEY (approver_id) REFERENCES approvers(approver_id)
);

-- Table: currency_rate: store information about currency exchange rate against USD 
DROP TABLE IF EXISTS currency_rates CASCADE;
CREATE TABLE currency_rates (
    currency CHAR(3), 
    rate_to_usd NUMERIC(10, 2),
    rate_date DATE,
    PRIMARY KEY (currency, rate_date)
);
