-- DUPLICATE CHECKS
------------------------------------------------------

-- Method 1: Use COUNT(DISTINCT ...) to count unique values 
SELECT 'orders' as t_name,
	COUNT(*) as k_rows,
	COUNT(DISTINCT order_id) as u_rows
FROM orders; ---- The same check is performed for the other tables

-- Method 2: Use GROUP BY and HAVING COUNT(*) > 1 to identify duplicates
SELECT 'orders' AS table_name,
	COUNT(*) AS duplicate
FROM(
	SELECT order_id, COUNT(*) 
	FROM orders 
	GROUP BY order_id
	HAVING COUNT(*) > 1
	) AS duplicates	
UNION ALL
SELECT 'customers' AS table_name,
	COUNT(*) AS duplicate
FROM(
	SELECT customer_id, COUNT(*) 
	FROM customers 
	GROUP BY customer_id	
	HAVING COUNT(*) > 1
	) AS duplicates	
UNION ALL
SELECT 'sellers' AS table_name,
	COUNT(*) AS duplicate
FROM (
	SELECT seller_id, COUNT(*) 
	FROM sellers 
	GROUP BY seller_id	
	HAVING COUNT(*) > 1
	) AS duplicates
UNION ALL 
SELECT 'products' AS table_name,
	COUNT(*) AS duplicate
FROM (
	SELECT product_id, COUNT(*) 
	FROM products 
	GROUP BY product_id	
	HAVING COUNT(*) > 1
	) AS duplicates 
UNION ALL 
SELECT 'order_payments' AS table_name,
	COUNT(*) AS duplicate
FROM (
	SELECT order_id,
    payment_sequential,
    COUNT(*)
	FROM order_payments
	GROUP BY order_id, payment_sequential
	HAVING COUNT(*) > 1
	) AS duplicates
UNION ALL 
SELECT 'order_reviews' AS table_name,
	COUNT(*) AS duplicate
FROM (
	SELECT order_id,
    review_id,
    COUNT(*)
	FROM order_reviews
	GROUP BY order_id, review_id
	HAVING COUNT(*) > 1
	) AS duplicates
UNION ALL 
SELECT 'geolocation' AS table_name,
	COUNT(*) AS duplicate
FROM ( 
	SELECT geolocation_zip_code_prefix,
	geolocation_lat,
	geolocation_lng,
	COUNT(*)
	FROM geolocation
	GROUP BY geolocation_zip_code_prefix, geolocation_lat, geolocation_lng
	HAVING COUNT(*) > 1
	) AS duplicates
-- NOTE ON GEOLOCATION TABLE
-- The 'geolocation' table natively contains multiple coordinate entries per ZIP code prefix
-- High duplicate counts for (zip_code, lat, lng) are part of the raw Olist dataset structure
-- representing multiple spatial measurements for a single area, not an ETL/import error
UNION ALL 
SELECT 'order_items' AS table_name,
	COUNT(*) AS duplicate
FROM ( 
	SELECT order_id,
	order_item_id,
	product_id,
	seller_id,
	COUNT(*)
	FROM order_items
	GROUP BY order_id, order_item_id, product_id, seller_id
	HAVING COUNT(*) > 1
	) AS duplicate
UNION ALL 
SELECT 'category_name' AS table_name,
	COUNT(*) AS duplicate
FROM (
	SELECT product_category_name, 
	COUNT(*)
	FROM product_category_name_translation
	GROUP BY product_category_name
	HAVING COUNT(*) > 1
	) AS duplicate;

