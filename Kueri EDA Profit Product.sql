SELECT *
FROM dm.fact_sales

SELECT *
FROM dm.dim_product

-- Kategori dengan profit tertinggi
-- Kategori teknologi sub-kategori 'Copiers' memiliki profit tertinggi (55617.90)
SELECT
	p.category,
	p.sub_category,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit
FROM dm.dim_product AS p
JOIN dm.fact_sales AS fss
ON p.product_id = fss.product_id
GROUP BY 1,2
ORDER BY 4 DESC;

-- Kategori produk dengan profit terendah
-- Kategori Furniture sub-kategori 'Tables' memiliki profit terendah (-17725.59)
SELECT
	p.category,
	p.sub_category,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit
FROM dm.dim_product AS p
JOIN dm.fact_sales AS fss
ON p.product_id = fss.product_id
GROUP BY 1,2
ORDER BY 4;

-- Produk Furniture Tables dengan profit terendah
-- Produk meja “Chromcraft Bull-Nose…” memiliki profit terendah
SELECT
	p.product_name,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit
FROM dm.dim_product AS p
JOIN dm.fact_sales AS fss
ON p.product_id = fss.product_id
WHERE p.category = 'Furniture'
AND p.sub_category = 'Tables'
GROUP BY 1
ORDER BY 3
LIMIT 10;

-- Tren Penjualan Kategori Furniture Sub Kategori Tables
SELECT
	DATE_TRUNC('month', fss.order_date) AS "month",
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit
FROM dm.fact_sales AS fss
JOIN dm.dim_product AS p
ON fss.product_id = p.product_id
WHERE p.category = 'Furniture'
AND p.sub_category = 'Tables'
GROUP BY 1
ORDER BY 1;

-- Produk Furniture dengan profit tertinggi
SELECT
	p.product_name,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit
FROM dm.dim_product AS p
JOIN dm.fact_sales AS fss
ON p.product_id = fss.product_id
WHERE p.category = 'Furniture'
AND p.sub_category = 'Tables'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- Profit produk 'Chromcraft Bull-Nose...' di berbagai lokasi
SELECT
	l.region,
	l.state,
	l.city,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit
FROM dm.dim_location AS l
JOIN dm.fact_sales AS fss
ON l.postal_code = fss.postal_code
JOIN dm.dim_product AS p
ON p.product_id = fss.product_id
WHERE p.product_name = 'Chromcraft Bull-Nose Wood Oval Conference Tables & Bases'
GROUP BY 1,2,3
ORDER BY 5;

-- Penjualan produk kategori furniture sub kategori tables di berbagai daerah
SELECT
	l.region,
	l.state,
	l.city,
	p.product_name,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit
FROM dm.dim_location AS l
JOIN dm.fact_sales AS fss
ON l.postal_code = fss.postal_code
JOIN dm.dim_product AS p
ON p.product_id = fss.product_id
WHERE p.category = 'Furniture'
AND p.sub_category = 'Tables'
GROUP BY 1,2,3,4
ORDER BY 6;

-- Analisa faktor diskon terkait produk dengan profit rendah di south region
SELECT
	l.region,
	l.state,
	l.city,
	AVG(fss.discount) AS avg_discount,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit
FROM dm.dim_location AS l
JOIN dm.fact_sales AS fss
ON l.postal_code = fss.postal_code
JOIN dm.dim_product AS p
ON p.product_id = fss.product_id
WHERE p.product_name = 'Chromcraft Bull-Nose Wood Oval Conference Tables & Bases'
GROUP BY 1,2,3
ORDER BY 6;

-- Total transaksi dari produk Chromcraft Bull-Nose Wood Oval Conference Tables & Bases
SELECT
    fss.order_id,
	fss.customer_id,
    AVG(fss.discount) AS avg_discount,
    SUM(fss.sales) AS total_sales,
    SUM(fss.profit) AS total_profit
FROM dm.fact_sales AS fss
JOIN dm.dim_product AS p
    ON p.product_id = fss.product_id
JOIN dm.dim_location AS l
    ON l.postal_code = fss.postal_code
WHERE p.product_name = 'Chromcraft Bull-Nose Wood Oval Conference Tables & Bases'
GROUP BY 1,2
ORDER BY 5;


-- Cek range diskon dari seluruh produk superstore
SELECT
	CASE
		WHEN discount = 0 THEN 'No discount'
		WHEN discount > 0 AND discount <= 0.2 THEN '1% - 20%'
		WHEN discount > 0.2 AND discount <= 0.4 THEN '20% - 40%'
		WHEN discount > 0.4 THEN 'Above 40%'
		ELSE 'Others'
	END AS discount_range,
	SUM(sales) AS total_sales,
	SUM(profit) AS total_profit,
	COUNT(order_id) AS total_orders,
	AVG(profit) AS avg_profit_per_order
FROM dm.fact_sales
GROUP BY discount_range
ORDER BY discount_range;

-- Cek range diskon dari seluruh produk superstore
SELECT
	CASE
		WHEN discount = 0 THEN 'No discount'
		WHEN discount > 0 AND discount <= 0.2 THEN '1% - 20%'
		WHEN discount > 0.2 AND discount <= 0.4 THEN '20% - 40%'
		WHEN discount > 0.4 THEN 'Above 40%'
		ELSE 'Others'
	END AS discount_range,
	SUM(sales) AS total_sales,
	SUM(profit) AS total_profit,
	COUNT(order_id) AS total_orders,
	AVG(profit) AS avg_profit_per_order
FROM dm.fact_sales
GROUP BY discount_range
ORDER BY discount_range;


-- range diskon kategori Furniture sub-kategori Tables
SELECT
	CASE
		WHEN fss.discount = 0 THEN 'No discount'
		WHEN fss.discount > 0 AND fss.discount <= 0.2 THEN '1% - 20%'
		WHEN fss.discount > 0.2 AND fss.discount <= 0.4 THEN '20% - 40%'
		WHEN fss.discount > 0.4 THEN 'Above 40%'
		ELSE 'Others'
	END AS discount_range,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit,
	COUNT(fss.order_id) AS total_orders,
	AVG(fss.profit) AS avg_profit_per_order
FROM dm.fact_sales AS fss
JOIN dm.dim_product AS p
ON fss.product_id = p.product_id
JOIN dm.dim_location AS l
ON fss.postal_code = l.postal_code
WHERE p.category = 'Furniture'
AND p.sub_category = 'Tables'
GROUP BY discount_range
ORDER BY discount_range;

-- range diskon kategori Technology sub-kategori Copiers
SELECT
	CASE
		WHEN fss.discount = 0 THEN 'No discount'
		WHEN fss.discount > 0 AND fss.discount <= 0.2 THEN '1% - 20%'
		WHEN fss.discount > 0.2 AND fss.discount <= 0.4 THEN '20% - 40%'
		WHEN fss.discount > 0.4 THEN 'Above 40%'
		ELSE 'Others'
	END AS discount_range,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit,
	COUNT(fss.order_id) AS total_orders,
	AVG(fss.profit) AS avg_profit_per_order
FROM dm.fact_sales AS fss
JOIN dm.dim_product AS p
ON fss.product_id = p.product_id
JOIN dm.dim_location AS l
ON fss.postal_code = l.postal_code
WHERE p.category = 'Technology'
AND p.sub_category = 'Copiers'
GROUP BY discount_range
ORDER BY discount_range;


-- Segmen pelanggan dan kategori dengan profit tertinggi
-- Segmen Consumer memiliki total sales dan profit tertinggi
SELECT
	c.segment,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit
FROM dm.fact_sales AS fss
JOIN dm.dim_customer AS c
ON fss.customer_id = c.customer_id
GROUP BY 1
ORDER BY 3 DESC;

-- Rata-rata profit per pelanggan tiap segmen
WITH customer_profit AS(
	SELECT
		c.segment,
		fss.customer_id,
		SUM(fss.profit) AS total_profit_per_customer
	FROM dm.fact_sales AS fss
	JOIN dm.dim_customer AS c
	ON fss.customer_id = c.customer_id
	GROUP BY 1,2
)
SELECT
	segment,
	AVG(total_profit_per_customer) AS avg_profit_per_customer
FROM customer_profit
GROUP BY 1
ORDER BY 2 DESC;

-- Profit Margin tiap segmen
SELECT
	c.segment,
	(SUM(fss.profit)/ NULLIF(SUM(fss.sales), 0)) * 100 AS profit_margin
FROM dm.fact_sales AS fss
JOIN dm.dim_customer AS c
ON fss.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2 DESC;


-- dari 3 kategori, mana yang menjadi mesin utama perusahaan?
-- Secara umum, kategori technology adalah yang paling superior
SELECT
	p.category,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit,
	(SUM(fss.profit) / NULLIF(SUM(fss.sales), 0)) * 100 AS profit_margin,
	COUNT(DISTINCT order_id) AS total_order
FROM dm.fact_sales AS fss
JOIN dm.dim_customer AS c
ON fss.customer_id = c.customer_id
JOIN dm.dim_product AS p
ON fss.product_id = p.product_id
GROUP BY 1
ORDER BY 3 DESC;

-- Breakdown sub-kategori Technology
-- sub kategori copiers memiliki total profit tertinggi dan profit margin yang sehat
SELECT
	p.sub_category,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit,
	(SUM(fss.profit) / NULLIF(SUM(fss.sales), 0)) * 100 AS profit_margin,
	COUNT(DISTINCT order_id) AS total_order
FROM dm.fact_sales AS fss
JOIN dm.dim_customer AS c
ON fss.customer_id = c.customer_id
JOIN dm.dim_product AS p
ON fss.product_id = p.product_id
WHERE p.category = 'Technology'
GROUP BY 1
ORDER BY 3 DESC;

-- Matriks penjualan
SELECT
	p.sub_category,
	SUM(fss.sales) AS total_sales,
	SUM(fss.profit) AS total_profit,
	(SUM(fss.profit) / NULLIF(SUM(fss.sales), 0)) * 100 AS profit_margin
FROM dm.fact_sales AS fss
JOIN dm.dim_customer AS c
ON fss.customer_id = c.customer_id
JOIN dm.dim_product AS p
ON fss.product_id = p.product_id
GROUP BY 1;
