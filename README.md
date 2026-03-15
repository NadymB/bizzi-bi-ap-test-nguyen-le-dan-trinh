<div align="center" >
<h1><strong>Bizzi BI AP Test </strong></h1>
</div>

## Project Overview
This project was completed as part of the Bizzi BI Accounts Payable (AP) technical test, focusing on SQL analysis, dashboard development, and analytical insights.
The test includes: 
- Data Ingestion & Modeling
- Core AP Metrics
- Dashboard
- Analytical Thinking
- Communication

## Environment

PostgreSQL version used: **17.6**

## Setup Instructions

#### 1. Prerequisites

Before running this project, make sure the following tools are installed:

- PostgreSQL (version 17)
- `psql` command line tool
- Git

Verify PostgreSQL installation:

```bash
psql --version
```

#### 2. Clone repository:

```bash
git clone <repo_url>
cd bizzi-bi-ap-test-nguyen-le-dan-trinh
```

#### 3. Create database:

```bash
createdb -U postgres bizzi_ap
```

#### 4. Connect to database:

```bash
psql -U postgres -d bizzi_ap
```

#### 5. Create tables (Schema):

```bash
\i schema/create_tables.sql
```

#### 6. Import Dataset into database:

```bash
\i import/import_commands.sql
```

#### 7. Run data validation:

```bash
\i import/data_validation.sql
```

#### 8. Run AP metrics:

```bash
\i queries/ap_metrics.sql
```

#### 9. Exit PostgreSQL:

```bash
\q
```

## Dataset 
The dataset contains:
- 3 `companies`
- 10 `vendors`
- 4 `approvers`
- 201 `approvals`
- 201 `invoices`
- 405 `invoice_items`
- 152 `payments`
- 2 `currency_rates`

Data validation checks:

- No duplicate invoices
- No paid invoices without `paid_date`
- No orphan foreign keys

## Data Quality Issues

- **11 invoices** were paid before approval
- **1 invoice** has a negative invoice amount (likely a credit note)
- **47 invoices** have missing `paid_date`
- **1 invoice** has missing `due_date`

## Data Model (ERD)

[View ERD](https://drive.google.com/file/d/1WrE0d9TIQSUB1JlRannwIyAH6cK6433o/view?usp=sharing)

## Analytical Insights
#### 1. Operational inefficiencies:
*Slow approval process:* <br>

- The average time from **invoice received to approval is approximately 5 days**.
- A slow approval process may delay payment processing and increase the risk of late payments. <br>

*High late payment rate:* <br>

- **50% of invoices are paid after the due date**. Possible causes include:
  - Delays in approval workflow
  - Inefficient invoice tracking
  - Operational bottlenecks in the AP process <br>

*Large number of overdue invoices:*
- **76 out of 152 paid invoices are overdue (50%)**.
- This indicates that invoices may not be monitored closely after approval, leading to delayed payments. <br>

*Missing payment information:* <br>

- There are **47 invoices with missing `paid_date`**, including **30 approved invoices** and **17 invoices still in submitted status**.
  - Approved invoices without payment may indicate delays in payment processing or system issues where payment dates were not recorded.
  - Submitted invoices suggest the approval process may still be pending due to incorrect invoice or delays from approvers.
- Incomplete payment tracking reduce financial visibility and affect reporting accuracy. <br>

*Data completeness issue:*
- One invoice has a missing `due_date`.
- Since the due date is usually calculated based on payment terms and invoice receipt date. Missing values suggest potential system automation gaps or manual data entry issues.<br>

*Business Impact:* <br>

- These operational inefficiencies may lead to:
  - Delayed payments to vendors
  - Reduced vendor trust
  - Potential loss of preferential pricing or service agreements <br>

#### 2. AP process risks:

*Vendor concentration risk:* <br>

- Shopee Ads accounts for approximately **$338K in spending**, representing **around 25% of total vendor spend**.
- High dependence on a single vendor increases financial concentration risk. <br>

*High late payment rate among key vendors:* <br>

- Several high-spend vendors also show **late payment rates above 50%**, including:
  - Shopee Ads
  - Viettel Telecom
  - Meta Ads
  - Vietnam Airlines
  - FPT Software 
- Frequent late payments to strategic vendors may damage long-term business relationships. <br>

*Approval and payment control risk:* <br>

- The dataset shows **11 invoices paid before approval**, indicating weaknesses in the approval control process, increases the risk of:
  - Financial reporting errors
  - Unauthorized payments
  - Fraud or compliance issues <br>
  
*Data quality risks:* <br>

- One invoice has a negative invoice amount (-500 SGD = 370 USD).
- This may represent a credit note or refund, but without proper classification it could lead to misinterpretation in financial reporting.

#### 3. Suggested analytics feature:
*AP workflow monitoring system:* <br>

- Bizzi could implement a system to monitor invoice approval and payment workflows in real time, including:
  - Tracking approval delays
  - Notify approvers when invoices are approaching due dates
  - Alert the finance team about invoices likely to become overdue <br>

*Predictive late payment alerts:* <br>

- Using historical data, the system could identify invoices with a high probability of late payment and automatically notify for approvers and finance team. This would allow proactive intervention before invoices become overdue. <br>

*AP performance dashboard:* <br>

- A centralized dashboard could track key metrics as approval time by department to improve visibility into AP operations and support better financial decision-making.

## Assumptions
- Missing `paid_date` indicates invoices **not yet paid**.
- Negative invoice amounts represent **credit notes or refunds**

## Approximate time spent
Estimated time spent on this assignment:

| Task        | Time |
|-----------------|-------------|
| Data modeling & schema design       | ~ 2 hours |
| Data import & validation  | ~ 1 hour |
| AP metrics      | ~ 1 hour |
| Dashboard      | ~ 8 hours |
| Analytical Thinking           | ~ 6 hours |
| Documentation         | ~ 1 hour |
| Review        | ~ 2 hour |

**Total: ~21 hours**

## Improvements
If the dataset grows to hundreds of millions of rows:
- Indexes could be added to frequently queried columns in the `invoices` table
- Partition `invoices` table by month to improve query performance and analytical processing.
- Build materialized views for dashboard metrics

## Conclusion

This project provided practical experience in SQL analysis and dashboard development. As my first time using Power BI, I gained hands-on experience in dashboard design and data visualization while exploring Accounts Payable workflows and financial concepts such as credit notes and vendor payment processes.
