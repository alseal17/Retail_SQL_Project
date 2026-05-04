-- 1). Top Product Categories by Revenue

SELECT 
	COALESCE(t.product_category_name_english, pr.product_category_name) AS product_category, 
	COUNT(DISTINCT oi.order_id) AS total_orders, 
	SUM(oi.order_item_id) AS total_items_sold, 
	ROUND(SUM(oi.price), 2) AS total_product_revenue
FROM order_items oi
JOIN products pr
	ON oi.product_id = pr.product_id
LEFT JOIN product_category_translation t 
	ON pr.product_category_name = t.product_category_name
GROUP BY product_category
ORDER BY total_product_revenue DESC 
LIMIT 10; 

-- 2). Top Product Categories by Items Sold 

SELECT 
	COALESCE(t.product_category_name_english, pr.product_category_name) AS product_category, 
	COUNT(*) AS total_items_sold 
FROM order_items OI
JOIN products pr
	ON oi.product_id = pr.product_id
LEFT JOIN product_category_translation t 
	ON pr.product_category_name = t.product_category_name
GROUP BY product_category
ORDER BY total_items_sold DESC 
LIMIT 10; 

-- 3). Average Price by Product Category 

SELECT 
    COALESCE(t.product_category_name_english, pr.product_category_name) AS product_category,
    ROUND(AVG(oi.price), 2) AS avg_price,
    COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products pr
    ON oi.product_id = pr.product_id
LEFT JOIN product_category_translation t
    ON pr.product_category_name = t.product_category_name
GROUP BY product_category
HAVING COUNT(*) >= 100
ORDER BY avg_price DESC
LIMIT 10;

-- 4). Top Individual Products by Revenue 

SELECT 
    oi.product_id,
    COALESCE(t.product_category_name_english, pr.product_category_name) AS product_category,
    COUNT(*) AS total_units_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products pr
    ON oi.product_id = pr.product_id
LEFT JOIN product_category_translation t
    ON pr.product_category_name = t.product_category_name
GROUP BY oi.product_id, product_category
ORDER BY total_revenue DESC
LIMIT 10;

-- 5). Categories with Highest Freight Cost 

SELECT 
	COALESCE(t.product_category_name_english, pr.product_category_name) AS product_category,
	ROUND(AVG(oi.freight_value), 2) AS avg_freight_cost,
	COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products pr
	ON oi.product_id = pr.product_id
LEFT JOIN product_category_translation t 
	ON pr.product_category_name = t.product_category_name
GROUP BY product_category
HAVING COUNT(*) >= 100
ORDER BY avg_freight_cost DESC
LIMIT 10; 