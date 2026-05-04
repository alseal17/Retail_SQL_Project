-- 1). Orders by Customer State

SELECT 
	c.customer_state, 
	COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o 
JOIN customers c
	ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_orders DESC; 

-- 2). Revenue by Customer State 

SELECT 
	c.customer_state, 
	COUNT(DISTINCT o.order_id) AS total_orders,
	ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders o 
JOIN customers c
	ON o.customer_id = c.customer_id 
JOIN order_payments p 
	ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- 3). Repeat vs One-Time Customers

WITH customer_orders AS (
	SELECT 
		c.customer_unique_id, 
		COUNT(DISTINCT o.order_id) AS total_orders
	FROM customers c 
	JOIN orders o 
		ON c.customer_id = o.customer_id
	WHERE o.order_status = 'delivered'
	GROUP BY c.customer_unique_id
)

SELECT 
	CASE
		WHEN total_orders = 1 THEN 'One-Time Customer'
		ELSE 'Repeat Customer'
	END AS customer_type, 
	COUNT(*) AS total_customers 
FROM customer_orders
GROUP BY customer_type
ORDER BY total_customers DESC; 
)

-- 4). Top Customers by Revenue 

SELECT 
	c.customer_unique_id,
	COUNT(DISTINCT o.order_id) AS total_orders, 
	ROUND(SUM(p.payment_value), 2) AS total_spent
FROM customers c 
JOIN orders o 
	ON c.customer_id = o.customer_id
JOIN order_payments p
	ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10; 