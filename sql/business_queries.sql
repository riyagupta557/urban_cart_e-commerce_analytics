-- ============================================================
-- URBANCART -- E-Commerce Sales Analytics
-- 18 Business Queries | MySQL 8+
-- Ordered basic -> intermediate. No complex/nested CTEs.
-- ============================================================

-- 1. Core business measures: Total Sales, Profit, Quantity, AOV, Margin %, Avg Discount
SELECT
    ROUND(SUM(sales), 2)              AS total_sales,
    ROUND(SUM(profit), 2)             AS total_profit,
    SUM(quantity)                     AS total_quantity,
    ROUND(AVG(sales), 2)              AS avg_order_value,
    ROUND(100 * SUM(profit) / SUM(sales), 2) AS profit_margin_pct,
    ROUND(AVG(discount) * 100, 2)     AS avg_discount_pct
FROM Fact_Orders;

-- 2. Sales and profit by category
SELECT
    p.category,
    ROUND(SUM(f.sales), 2)  AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND(100 * SUM(f.profit) / SUM(f.sales), 2) AS margin_pct
FROM Fact_Orders f
JOIN Dim_Product p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- 3. Sales by region
SELECT
    l.region,
    ROUND(SUM(f.sales), 2) AS total_sales,
    COUNT(*)               AS total_orders
FROM Fact_Orders f
JOIN Dim_Location l ON f.location_id = l.location_id
GROUP BY l.region
ORDER BY total_sales DESC;

-- 4. Top 10 customers by sales
SELECT
    c.customer_name,
    c.segment,
    ROUND(SUM(f.sales), 2) AS total_sales
FROM Fact_Orders f
JOIN Dim_Customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY total_sales DESC
LIMIT 10;

-- 5. Top 10 products by sales
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(f.sales), 2) AS total_sales
FROM Fact_Orders f
JOIN Dim_Product p ON f.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_sales DESC
LIMIT 10;

-- 6. Sales and margin by customer segment
SELECT
    c.segment,
    ROUND(SUM(f.sales), 2)  AS total_sales,
    ROUND(100 * SUM(f.profit) / SUM(f.sales), 2) AS margin_pct
FROM Fact_Orders f
JOIN Dim_Customer c ON f.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_sales DESC;

-- 7. Monthly sales trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    ROUND(SUM(sales), 2) AS total_sales
FROM Fact_Orders
GROUP BY order_month
ORDER BY order_month;

-- 8. Order status breakdown (count and %)
SELECT
    s.order_status,
    COUNT(*) AS order_count,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM Fact_Orders), 2) AS pct_of_orders
FROM Fact_Orders f
JOIN Dim_Shipping s ON f.shipping_id = s.shipping_id
GROUP BY s.order_status;

-- 9. Sales by ship mode
SELECT
    s.ship_mode,
    ROUND(SUM(f.sales), 2) AS total_sales,
    COUNT(*) AS orders
FROM Fact_Orders f
JOIN Dim_Shipping s ON f.shipping_id = s.shipping_id
GROUP BY s.ship_mode
ORDER BY total_sales DESC;

-- 10. Cancellation rate by payment method
SELECT
    s.payment_method,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN s.order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(100 * SUM(CASE WHEN s.order_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancel_rate_pct
FROM Fact_Orders f
JOIN Dim_Shipping s ON f.shipping_id = s.shipping_id
GROUP BY s.payment_method
ORDER BY cancel_rate_pct DESC;

-- 11. Average discount by category
SELECT
    p.category,
    ROUND(AVG(f.discount) * 100, 2) AS avg_discount_pct
FROM Fact_Orders f
JOIN Dim_Product p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_discount_pct DESC;

-- 12. Customers with more than 15 orders (GROUP BY + HAVING)
SELECT
    c.customer_name,
    COUNT(*) AS order_count
FROM Fact_Orders f
JOIN Dim_Customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(*) > 15
ORDER BY order_count DESC;

-- 13. Products that have never been ordered (LEFT JOIN + IS NULL)
SELECT
    p.product_id,
    p.product_name,
    p.category
FROM Dim_Product p
LEFT JOIN Fact_Orders f ON p.product_id = f.product_id
WHERE f.order_id IS NULL;

-- 14. Region-wise cancellation rate
SELECT
    l.region,
    COUNT(*) AS total_orders,
    ROUND(100 * SUM(CASE WHEN s.order_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancel_rate_pct
FROM Fact_Orders f
JOIN Dim_Location l  ON f.location_id = l.location_id
JOIN Dim_Shipping s  ON f.shipping_id = s.shipping_id
GROUP BY l.region
ORDER BY cancel_rate_pct DESC;

-- 15. Top 5 states by total sales
SELECT
    l.state,
    ROUND(SUM(f.sales), 2) AS total_sales
FROM Fact_Orders f
JOIN Dim_Location l ON f.location_id = l.location_id
GROUP BY l.state
ORDER BY total_sales DESC
LIMIT 5;

-- 16. Customers who spent above the overall average order value (subquery)
SELECT
    c.customer_name,
    ROUND(AVG(f.sales), 2) AS avg_order_value
FROM Fact_Orders f
JOIN Dim_Customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING AVG(f.sales) > (SELECT AVG(sales) FROM Fact_Orders)
ORDER BY avg_order_value DESC;

-- 17. Highest single sales transaction, with customer and product context
SELECT
    f.order_id,
    c.customer_name,
    p.product_name,
    f.sales,
    f.order_date
FROM Fact_Orders f
JOIN Dim_Customer c ON f.customer_id = c.customer_id
JOIN Dim_Product p  ON f.product_id  = p.product_id
ORDER BY f.sales DESC
LIMIT 1;

-- 18. Rank products within each category by total sales (window function)
SELECT
    category,
    product_name,
    total_sales,
    RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rank_in_category
FROM (
    SELECT p.category, p.product_name, SUM(f.sales) AS total_sales
    FROM Fact_Orders f
    JOIN Dim_Product p ON f.product_id = p.product_id
    GROUP BY p.product_id, p.category, p.product_name
) product_sales
ORDER BY category, rank_in_category;
