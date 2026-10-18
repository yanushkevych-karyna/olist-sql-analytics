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
	ROUND(SUM(o_p.payment_value)::numeric,2) AS total_revenue,
	COUNT(DISTINCT o.order_id ) AS total_orders,
	ROUND(ROUND(SUM(o_p.payment_value)::numeric,2)/COUNT(DISTINCT o.order_id ),2) AS average_order_value,
	ROUND((COUNT(DISTINCT CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN o.order_id END) * 100.0 / 
    	NULLIF(COUNT(DISTINCT CASE WHEN o.order_status = 'delivered' THEN o.order_id END), 0))::numeric, 2) AS on_time_delivery
FROM orders AS o 
LEFT JOIN order_payments AS o_p
ON o.order_id = o_p.order_id;
