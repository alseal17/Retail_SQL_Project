-- 1). Monthly Revenue

SELECT 
	DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
	ROUND(SUM(p.payment_value),2) AS total_revenue
FROM orders o 
JOIN order_payments p
	ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;

-- 2). Monthly Orders + Revenue 

SELECT 
	DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month, 
	COUNT(DISTINCT o.order_id) AS total_orders, 
	ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders o
JOIN order_payments p 
	ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;

-- 3). Average Order Value 

SELECT 
	ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value 
FROM orders o 
JOIN order_payments p 
	ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';

-- 4). Revenue by Order Status 

SELECT 
	o.order_status, 
	COUNT(DISTINCT o.order_id) AS total_orders, 
	ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM orders o
JOIN order_payments p 
	ON o.order_id = p.order_id
GROUP BY o.order_status
ORDER BY total_revenue DESC;