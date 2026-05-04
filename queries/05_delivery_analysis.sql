-- 1). Average Delivery Time

SELECT 
	ROUND(AVG(
		EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp))
	), 2) AS avg_delivery_days
FROM orders 
WHERE order_status = 'delivered'; 

-- 2). Delivery Delay (Actual vs Estimated)

SELECT 
	ROUND(AVG(
		EXTRACT(DAY FROM (order_delivered_customer_date - order_estimated_delivery_date))
	), 2) AS avg_delay_days 
FROM orders 
WHERE order_status = 'delivered'; 

-- 3). On-Time vs Late Deliveries 

SELECT 
	CASE
		WHEN order_delivered_customer_date <= order_estimated_delivery_date
			THEN 'On Time'
		ELSE 'Late'
	END AS delivery_status, 
	COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'delivered'
GROUP BY delivery_status; 

-- 4). Delivery Time by State

SELECT 
    c.customer_state,
    ROUND(AVG(
        EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))
    ), 2) AS avg_delivery_days,
    COUNT(*) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;

-- 5). Does Delay Affect Reviews?

SELECT 
	CASE
		WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
			THEN 'On Time'
		ELSE 'Late'
	END AS delivery_status, 
	ROUND(AVG(r.review_score), 2) AS avg_review_score, 
	COUNT(*) AS total_reviews
FROM orders o 
JOIN order_reviews r 
	ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_status; 