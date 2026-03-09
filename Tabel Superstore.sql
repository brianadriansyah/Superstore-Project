CREATE TABLE stg.superstore_orders (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(255),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(255),
    customer_id VARCHAR(255),
    customer_name VARCHAR(255),
    segment VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    "state" VARCHAR(255),
    postal_code VARCHAR(255),
    region VARCHAR(255),
    product_id VARCHAR(255),
    category VARCHAR(255),
    sub_category VARCHAR(255),
    product_name VARCHAR(255),
    sales NUMERIC(10, 2),
    quantity INT,
    discount NUMERIC(4, 2),
    profit NUMERIC(10, 2)
);

-- Dimensi customer
CREATE TABLE dm.dim_customer AS
SELECT
    customer_id,
    customer_name,
    segment
FROM
    stg.superstore_orders
GROUP BY
    customer_id,
    customer_name,
    segment;

-- Dimensi Product
CREATE TABLE dm.dim_product AS
SELECT
    product_id,
    product_name,
    category,
    sub_category
FROM
    stg.superstore_orders
GROUP BY
    product_id,
    product_name,
    category,
    sub_category;

-- Dimensi Location
CREATE TABLE dm.dim_location AS
SELECT
    city,
    "state",
    region,
    country,
    postal_code
FROM
    stg.superstore_orders
GROUP BY
    city,
    state,
    region,
    country,
    postal_code;

-- Fact Tables
CREATE TABLE dm.fact_sales AS
SELECT
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    product_id,
    city,
    "state",
    postal_code,
    region,
    sales,
    quantity,
    discount,
    profit
FROM
    stg.superstore_orders;


-- Cek duplikat kolom tabel
SELECT
    product_id,
    COUNT(*)
FROM
    dm.dim_product_clean
GROUP BY
    1
HAVING
    COUNT(*) > 1;



-- Kolom tabel product bersih
CREATE TABLE dm.dim_product_clean AS
SELECT
    product_id,
    MIN(product_name) AS product_name,     -- Mengambil satu nama produk yang konsisten
    MIN(category) AS category,             -- Mengambil satu nama kategori yang konsisten
    MIN(sub_category) AS sub_category      -- Mengambil satu nama sub-kategori yang konsisten
FROM
    stg.superstore_orders 
GROUP BY
    product_id;

-- Kolom tabel location bersih
CREATE TABLE dm.dim_location_clean AS
SELECT
    postal_code,
    MIN(city) AS city,
    MIN("state") AS state,
    MIN(region) AS region,
    MIN(country) AS country
FROM
    stg.superstore_orders 
GROUP BY
    postal_code;


SELECT *
FROM dm.dim_location


DROP TABLE dm.dim_product_clean;