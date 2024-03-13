Use mavenfuzzyfactory;
-- cross-product

SELECT 
	o.primary_product_id,
    oi.product_id,
	COUNT(DISTINCT o.order_id) AS cross_sell_product
FROM orders o
LEFT JOIN order_items oi
	ON o.order_id = oi.order_id
    AND oi.is_primary_item = 0
WHERE o.order_id BETWEEN 10000 AND 15000
GROUP BY 1,2
;


SELECT 
	o.primary_product_id,
	COUNT(DISTINCT o.order_id) AS cross_sell_product,
	COUNT(DISTINCT CASE WHEN oi.product_id = 1 THEN o.order_id ELSE NULL END) AS product1,
	COUNT(DISTINCT CASE WHEN oi.product_id = 2 THEN o.order_id ELSE NULL END) AS product2,
    COUNT(DISTINCT CASE WHEN oi.product_id = 3 THEN o.order_id ELSE NULL END) AS product3

FROM orders o
LEFT JOIN order_items oi
	ON o.order_id = oi.order_id
    AND oi.is_primary_item = 0
WHERE o.order_id BETWEEN 10000 AND 15000
GROUP BY 1
;
