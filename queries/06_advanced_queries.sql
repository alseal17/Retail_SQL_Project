-- 1). Monthly Revenue Running Total 

WITH monthly_revenue AS (
	SELECT 
		DATE_TRUNC('month', o.order_purchase_timestamp) AS month, 
		SUM(p.payment_value) AS revenue
	FROM orders o 
	JOIN order_payments p 
		ON o.order_id = p.order_id
	WHERE o.order_status = 'delivered'
	GROUP BY month
)

SELECT 
	month, 
	revenue, 
	SUM(revenue) OVER (ORDER by month) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month; 

-- 2). Top Customers By Spending (Ranking)

SELECT 
	c.customer_unique_id, 
	ROUND(SUM(p.payment_value), 2) AS total_spent, 
	RANK() OVER (ORDER BY SUM(p.payment_value) DESC) AS spending_rank
FROM customers c
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_payments p 
	ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
LIMIT 20;

-- 3) Monthly Order Growth Rate 

WITH monthly_orders AS (
	SELECT 
		DATE_TRUNC('month', order_purchase_timestamp) AS month, 
		COUNT(*) AS total_orders
	FROM orders 
	WHERE order_status = 'delivered'
	GROUP BY month
)

SELECT 
	month, 
	total_orders, 
	LAG(total_orders) OVER (ORDER BY month) AS previous_month_orders, 
	ROUND(
		(total_orders - LAG(total_orders) OVER (ORDER BY month)):: numeric
		/ NULLIF(LAG(total_orders) OVER (ORDER BY month), 0) * 100,
	2) AS percent_growth
FROM monthly_orders 
ORDER BY month;

-- 4). Most Valuable Product Categories 

SELECT 
	COALESCE(t.product_category_name_english, pr.product_category_name) AS category, 
	ROUND(SUM(oi.price), 2) AS total_revenue, 
	RANK() OVER (ORDER BY SUM(oi.price) DESC) AS category_rank
FROM order_items oi 
JOIN products pr
	ON oi.product_id = pr.product_id
LEFT JOIN product_category_translation t
	ON pr.product_category_name = t.product_category_name 
GROUP BY category
ORDER BY total_revenue DESC; 

-- 5). Customer Order Frequency 

SELECT 
	c.customer_unique_id, 
	o.order_id, 
	o.order_purchase_timestamp, 
	ROW_NUMBER() OVER (
		PARTITION BY c.customer_unique_id
		ORDER BY o.order_purchase_timestamp
	) AS order_number
FROM customers c 
JOIN orders o 
	ON c.customer_id = o.customer_id
ORDER BY c.customer_unique_id, order_purchase_timestamp;
	)