-- OLIST E-COMMERCE BUSINESS PERFORMANCE ANALYSIS
------------------------------------------------------
-- 1: CORE EXECUTIVE KPIs (POWER BI OVERVIEW)
------------------------------------------------------

-- Target Visual: Top Summary KPI Cards (Executive Banner)
-- Metrics calculated:
--   1. Total Revenue (Gross payments)
--   2. Total Volume (Unique orders)
--   3. Average Order Value (AOV)
--   4. On-Time Delivery Performance (%)

SELECT 
	ROUND(CAST(SUM(o_p.payment_value) AS NUMERIC),2) AS total_revenue,
	COUNT(DISTINCT o.order_id ) AS total_orders,
	ROUND(CAST(SUM(o_p.payment_value) / COUNT(DISTINCT o.order_id) AS NUMERIC),2) AS average_order_value,
	ROUND((COUNT(DISTINCT CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN o.order_id END) * 100.0 / 
    	NULLIF(COUNT(DISTINCT CASE WHEN o.order_status = 'delivered' THEN o.order_id END), 0))::numeric, 2) AS on_time_delivery
FROM orders AS o 
LEFT JOIN order_payments AS o_p
ON o.order_id = o_p.order_id
WHERE o.order_status != 'canceled';

------------------------------------------------------
-- 2: MONTHLY REVENUE & ORDER TRENDS
------------------------------------------------------

-- Aggregate monthly dynamics: Total Orders, Monthly Revenue, and Monthly AOV

SELECT
	CAST(EXTRACT(YEAR FROM o.order_purchase_timestamp) AS VARCHAR(4)) || '-' || 
    LPAD(CAST(EXTRACT(MONTH FROM o.order_purchase_timestamp) AS VARCHAR(2)), 2, '0') AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(CAST(SUM(o_p.payment_value) AS NUMERIC), 2) AS monthly_revenue,
    ROUND(CAST(SUM(o_p.payment_value) / COUNT(DISTINCT o.order_id) AS NUMERIC), 2) AS monthly_aov	
FROM orders AS o 
LEFT JOIN order_payments AS o_p
ON o.order_id = o_p.order_id
WHERE o.order_status != 'canceled'
GROUP BY EXTRACT(YEAR FROM o.order_purchase_timestamp),
    EXTRACT(MONTH FROM o.order_purchase_timestamp)
ORDER BY order_month ASC;