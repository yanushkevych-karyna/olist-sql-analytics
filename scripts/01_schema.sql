CREATE TABLE customers (
	customer_id VARCHAR(50) PRIMARY KEY,
	customer_unique_id VARCHAR(50),
	customer_zip_code_prefix INT,
	customer_city VARCHAR(100),
	customer_state VARCHAR(10)
);

CREATE TABLE geolocation (
	geolocation_zip_code_prefix INT,
	geolocation_lat NUMERIC ,
	geolocation_lng NUMERIC ,
	geolocation_city VARCHAR(100),
	geolocation_state VARCHAR(10)
);

CREATE TABLE order_items (
	order_id VARCHAR(50),
	order_item_id INT,
	product_id VARCHAR(50),
	seller_id VARCHAR(50),
	shipping_limit_date TIMESTAMP,
	price NUMERIC(10,2),
	freight_value NUMERIC(10,2)
);

CREATE TABLE order_payments (
	order_id VARCHAR(50),
	payment_sequential INT,
	payment_type VARCHAR(50),
	payment_installments INT,
	payment_value NUMERIC(10,2)
);

CREATE TABLE order_reviews (
	review_id VARCHAR(50),
	order_id VARCHAR(50),
	review_score INT,
	review_comment_title TEXT,
	review_comment_message TEXT,
	review_creation_date TIMESTAMP,
	review_answer_timestamp TIMESTAMP
);

CREATE TABLE orders (
	order_id VARCHAR (50) PRIMARY KEY,
	customer_id VARCHAR (50),
	order_status VARCHAR (50),
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE products (
	product_id VARCHAR(50) PRIMARY KEY,
	product_category_name VARCHAR(100),
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty INT,
	product_weight_g INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT
);

CREATE TABLE sellers (
	seller_id VARCHAR (50) PRIMARY KEY,
	seller_zip_code_prefix INT,
	seller_city VARCHAR (100),
	seller_state VARCHAR (10)
);

CREATE TABLE product_category_name_translation (
	product_category_name TEXT,
	product_category_name_english TEXT
);
