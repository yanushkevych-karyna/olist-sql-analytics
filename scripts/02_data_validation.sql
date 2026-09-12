-- DATA VALIDATION & QUALITY AUDIT

------------------------------------------------------
-- DATA VALIDATION: DUPLICATES & NULL CHECKS
------------------------------------------------------

-- Method 1: Use COUNT(DISTINCT ...) to count unique values 

SELECT 'orders' as t_name,
	COUNT(*) as k_rows,
	COUNT(DISTINCT order_id) as u_rows
FROM orders; ---- The same check is performed for the other tables

-- Method 2: Use GROUP BY and HAVING COUNT(*) > 1 to identify duplicates and NULL values across all tables

-- NOTE ON GEOLOCATION TABLE
-- The 'geolocation' table natively contains multiple coordinate entries per ZIP code prefix
-- High duplicate counts for (zip_code, lat, lng) are part of the raw Olist dataset structure
-- representing multiple spatial measurements for a single area, not an ETL/import error

SELECT 'orders' AS table_name,
	(SELECT COUNT(*)
		FROM(
			SELECT order_id, COUNT(*) 
			FROM orders 
			GROUP BY order_id
			HAVING COUNT(*) > 1
			) AS duplicates) AS duplicates_count, 
	(SELECT COUNT(*)
		FROM orders 
		WHERE order_id IS NULL OR customer_id IS NULL OR order_status IS NULL) AS null_count
		
UNION ALL
SELECT 'customers' AS table_name,
	(SELECT COUNT(*) 
		FROM(
			SELECT customer_id, COUNT(*) 
			FROM customers 
			GROUP BY customer_id	
			HAVING COUNT(*) > 1
			) AS duplicates) AS duplicates_count,
	(SELECT COUNT(*) 
		FROM customers 
		WHERE customer_id IS NULL OR customer_unique_id IS NULL) AS null_count
		
UNION ALL
SELECT 'sellers' AS table_name,
	(SELECT COUNT(*) 
		FROM (
			SELECT seller_id, COUNT(*) 
			FROM sellers 
			GROUP BY seller_id	
			HAVING COUNT(*) > 1
			) AS duplicates) AS duplicates_count,
	(SELECT COUNT(*) 
		FROM sellers 
		WHERE seller_id IS NULL) AS null_count
		
UNION ALL 
SELECT 'products' AS table_name,
	(SELECT COUNT(*) 
		FROM (
			SELECT product_id, COUNT(*) 
			FROM products 
			GROUP BY product_id	
			HAVING COUNT(*) > 1
			) AS duplicates) AS duplicates_count,
	(SELECT COUNT(*)
		FROM products
		WHERE product_id IS NULL) AS  null_count
		
UNION ALL 
SELECT 'order_payments' AS table_name,
	(SELECT COUNT(*) 
		FROM (
			SELECT order_id, payment_sequential,
   			COUNT(*)
			FROM order_payments
			GROUP BY order_id, payment_sequential
			HAVING COUNT(*) > 1
			) AS duplicates) AS duplicates_count,
	(SELECT COUNT(*)
		FROM order_payments
		WHERE order_id IS NULL OR payment_type IS NULL) AS  null_count
		
UNION ALL 
SELECT 'order_reviews' AS table_name,
	(SELECT COUNT(*) 
		FROM (
			SELECT order_id, review_id,
    		COUNT(*)
			FROM order_reviews
			GROUP BY order_id, review_id
			HAVING COUNT(*) > 1
			) AS duplicates) AS duplicates_count,
	(SELECT COUNT(*)
		FROM order_reviews
		WHERE review_id IS NULL OR order_id IS NULL OR review_score IS NULL) AS  null_count
		
UNION ALL 
SELECT 'geolocation' AS table_name,
	(SELECT COUNT(*) 
		FROM ( 
			SELECT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, 
			COUNT(*)
			FROM geolocation
			GROUP BY geolocation_zip_code_prefix, geolocation_lat, geolocation_lng
			HAVING COUNT(*) > 1
			) AS duplicates) AS duplicates_count,
	(SELECT COUNT(*)
		FROM geolocation
		WHERE geolocation_zip_code_prefix IS NULL) AS  null_count
		
UNION ALL 
SELECT 'order_items' AS table_name,
	(SELECT COUNT(*) 
		FROM ( 
			SELECT order_id, order_item_id, product_id, seller_id,
			COUNT(*)
			FROM order_items
			GROUP BY order_id, order_item_id, product_id, seller_id
			HAVING COUNT(*) > 1
			) AS duplicates) AS duplicates_count,
	(SELECT COUNT(*)
		FROM order_items
		WHERE seller_id IS NULL OR product_id IS NULL OR order_item_id IS NULL OR order_id IS NULL) AS  null_count
		
UNION ALL 
SELECT 'category_name' AS table_name,
	(SELECT COUNT(*)  
		FROM (
			SELECT product_category_name, 
			COUNT(*)
			FROM product_category_name_translation
			GROUP BY product_category_name
			HAVING COUNT(*) > 1
			) AS duplicates) AS duplicates_count,
	(SELECT COUNT(*)
		FROM product_category_name_translation
		WHERE product_category_name_english IS NULL OR product_category_name IS NULL) AS null_count;
		
------------------------------------------------------
-- BUSINESS LOGIC & ANOMALY CHECKS
------------------------------------------------------

-- Check 1: Negative or zero prices and freight values

SELECT COUNT(*) AS price_errors
FROM order_items
WHERE price <= 0 OR freight_value < 0;

-- Check 2: Invalid delivery timelines (Delivery date before purchase)

SELECT COUNT(*) AS delivery_errors
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp; 

-- Check 3: Delivered orders missing a delivery timestamp
-- FINDING: 8 anomaly records found in raw data

SELECT COUNT(*) AS delivery_data_errors
FROM orders 
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL; 

-- Check 4: Zero or negative payment values
-- FINDING: 9 records identified with payment_value = 0

SELECT COUNT(*) AS payment_values_errors
FROM order_payments
WHERE payment_value <= 0;

-- Check 5: Review scores outside valid range (1-5)

SELECT COUNT(*) AS range_errors
FROM order_reviews
WHERE review_score < 1 OR review_score > 5;