-- ============================================================
-- URBANCART -- E-Commerce Sales Analytics
-- ============================================================

-- 1. Core business measures: Total Sales, Profit, Quantity, AOV, Margin %, Avg Discount
SELECT
    ROUND(SUM(sales), 2)              AS total_sales,
    ROUND(SUM(profit), 2)             AS total_profit,
    SUM(quantity)                     AS total_quantity,
    ROUND(AVG(sales), 2)              AS avg_order_value,
    ROUND(100 * SUM(profit) / SUM(sales), 2) AS profit_margin_pct,
    ROUND(AVG(discount) * 100, 2)     AS avg_discount_pct
FROM orders;

-- 2. Sales and profit by category
SELECT
    p.category,
    ROUND(SUM(o.sales), 2)  AS total_sales,
    ROUND(SUM(o.profit), 2) AS total_profit,
    ROUND(100 * SUM(o.profit) / SUM(o.sales), 2) AS margin_pct
FROM orders o
JOIN product p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- 3. Sales by region
SELECT
    l.region,
    ROUND(SUM(o.sales), 2) AS total_sales,
    COUNT(*)               AS total_orders
FROM orders o
JOIN location l ON o.location_id = l.location_id
GROUP BY l.region
ORDER BY total_sales DESC;

-- 4. Top 10 customers by sales
SELECT
    c.customer_name,
    c.segment,
    ROUND(SUM(o.sales), 2) AS total_sales
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY total_sales DESC
LIMIT 10;

-- 5. Top 10 products by sales
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(o.sales), 2) AS total_sales
FROM orders o
JOIN product p ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_sales DESC
LIMIT 10;

-- 6. Sales and margin by customer segment
SELECT
    c.segment,
    ROUND(SUM(o.sales), 2)  AS total_sales,
    ROUND(100 * SUM(o.profit) / SUM(o.sales), 2) AS margin_pct
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_sales DESC;

-- 7. Monthly sales trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    ROUND(SUM(sales), 2) AS total_sales
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- 8. Order status breakdown (count and %)
SELECT
    s.order_status,
    COUNT(*) AS order_count,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM Fact_Orders), 2) AS pct_of_orders
FROM orders o
JOIN shipping s ON o.shipping_id = s.shipping_id
GROUP BY s.order_status;

-- 9. Sales by ship mode
SELECT
    s.ship_mode,
    ROUND(SUM(o.sales), 2) AS total_sales,
    COUNT(*) AS orders
FROM orders o
JOIN shipping s ON o.shipping_id = s.shipping_id
GROUP BY s.ship_mode
ORDER BY total_sales DESC;

-- 10. Cancellation rate by payment method
SELECT
    s.payment_method,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN s.order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(100 * SUM(CASE WHEN s.order_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancel_rate_pct
FROM orders o
JOIN shipping s ON o.shipping_id = s.shipping_id
GROUP BY s.payment_method
ORDER BY cancel_rate_pct DESC;

-- 11. Average discount by category
SELECT
    p.category,
    ROUND(AVG(o.discount) * 100, 2) AS avg_discount_pct
FROM orders o
JOIN product p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_discount_pct DESC;

-- 12. Customers and their total orders 
SELECT
    c.customer_name,
    COUNT(*) AS order_count
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY order_count DESC;

-- 13. Products that have never been ordered 
SELECT
    p.product_id,
    p.product_name,
    p.category
FROM product p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- 14. Region-wise cancellation rate
SELECT
    l.region,
    COUNT(*) AS total_orders,
    ROUND(100 * SUM(CASE WHEN s.order_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancel_rate_pct
FROM orders o
JOIN location l  ON o.location_id = l.location_id
JOIN shipping s  ON o.shipping_id = s.shipping_id
GROUP BY l.region
ORDER BY cancel_rate_pct DESC;

-- 15. Top 5 states by total sales
SELECT
    l.state,
    ROUND(SUM(o.sales), 2) AS total_sales
FROM orders o
JOIN location l ON o.location_id = l.location_id
GROUP BY l.state
ORDER BY total_sales DESC
LIMIT 5;

-- 16. Customers who spent above the overall average order value 
SELECT
    c.customer_name,
    ROUND(AVG(o.sales), 2) AS avg_order_value
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING AVG(o.sales) > (SELECT AVG(sales) FROM orders)
ORDER BY avg_order_value DESC;

-- 17. Highest single sales transaction, with customer and product context
SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    o.sales,
    o.order_date
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN product p  ON o.product_id  = p.product_id
ORDER BY o.sales DESC
LIMIT 1;

-- 18. Rank products within each category by total sales
SELECT
    category,
    product_name,
    total_sales,
    RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rank_in_category
FROM (
    SELECT p.category, p.product_name, SUM(o.sales) AS total_sales
    FROM orders o
    JOIN product p ON o.product_id = p.product_id
    GROUP BY p.product_id, p.category, p.product_name
) product_sales
ORDER BY category, rank_in_category;
