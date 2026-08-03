# UrbanCart -- E-Commerce Sales Analytics

## Project Overview
An end-to-end e-commerce sales analytics project covering the full
pipeline: raw data cleaning in Excel, business analysis in MySQL, and
an interactive dashboard in Tableau.

## Business Problem
UrbanCart is a mid-sized e-commerce retailer selling Electronics,
Furniture, and Clothing. Despite steady order volume, leadership wants
to know where profit is actually being made, which regions/payment
methods underperform, and where to focus next quarter.

## Project Objective
- Identify which categories are profitable, not just high-revenue
- Understand how payment method and discounting affect order reliability
- Compare regional and customer-segment performance
- Turn raw, messy order data into a decision-ready dashboard

## About the Dataset
A custom-generated dataset modeled on real e-commerce order data
(~7,000 order records, 2 years), with realistic data quality issues
(currency symbols, typos, missing values, duplicates, mixed date
formats) intentionally built in for the Excel cleaning step. Star
schema: one fact table (`orders`) + four dimensions (`customers`,
`products`, `location`, `shipping`).

## Tools & Technology
Excel (Power Query, formulas) · MySQL (schema design, joins,
aggregation, subqueries, window functions) · Tableau (dashboard,
calculated fields, KPIs)

## Project Workflow
Raw Data → Excel Cleaning → MySQL Schema & Queries → Tableau Dashboard → Insights

## Step-by-Step Breakdown

**Excel** -- Cleaned all 4 raw exports: trimmed/standardized text
fields, fixed currency symbols and mixed date formats, filled or
flagged missing values, and removed duplicate/blank rows. Full log in
`excel_cleaning/cleaning_steps.md`.

**MySQL** -- Modeled the cleaned data as a star schema
(`sql/schema.sql`) and wrote 18 business queries (`sql/business_queries.sql`)
covering joins, GROUP BY/HAVING, subqueries, and a window function --
all filtered to `order_status = 'Delivered'` for revenue/profit
measures, and using all orders for volume/status/cancellation metrics.

**Tableau** -- Built a dashboard with KPI cards (Total Sales, Total
Profit, Profit Margin %, Total Orders, Cancelled Orders, Cancellation
Rate), 7 visuals (sub-category sales vs. profit, discount vs. margin by
category, yearly sales vs. profit trend, sales vs. profit by segment,
cancellation rate by payment method, top products by sales, sales by
region), and filters for Year, Payment Method, Category, and Region.
Insights and recommendations documented in
`insights/insights_and_recommendations.md`.
