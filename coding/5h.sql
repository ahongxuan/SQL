Use mavenfuzzyfactory;

SELECT
	YEAR(oi.created_at) AS yr,
    MONTH(oi.created_at) As mo,
    COUNT(DISTINCT CASE WHEN product_id = 1 THEN oi.order_item_id ELSE NULL END) AS product_1,
    COUNT(DISTINCT CASE WHEN product_id = 1 THEN ir.order_item_refund_id ELSE NULL END) AS p1_refund,
    COUNT(DISTINCT CASE WHEN product_id = 1 THEN ir.order_item_id ELSE NULL END) /COUNT(DISTINCT CASE WHEN product_id = 1 THEN oi.order_item_id ELSE NULL END) AS p1_rt,
    COUNT(DISTINCT CASE WHEN product_id = 2 THEN oi.order_item_id ELSE NULL END) AS product_2,
    COUNT(DISTINCT CASE WHEN product_id = 2 THEN ir.order_item_refund_id ELSE NULL END) AS p2_refund,
    COUNT(DISTINCT CASE WHEN product_id = 2 THEN ir.order_item_refund_id ELSE NULL END) /    COUNT(DISTINCT CASE WHEN product_id = 2 THEN oi.order_item_id ELSE NULL END) AS p2_rt,

    COUNT(DISTINCT CASE WHEN product_id = 3 THEN oi.order_item_id ELSE NULL END) AS product_3,
    COUNT(DISTINCT CASE WHEN product_id = 3 THEN ir.order_item_refund_id ELSE NULL END) AS p3_refund,
	COUNT(DISTINCT CASE WHEN product_id = 3 THEN ir.order_item_refund_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN product_id = 3 THEN oi.order_item_id ELSE NULL END) AS p3_rt,

    COUNT(DISTINCT CASE WHEN product_id = 4 THEN oi.order_item_id ELSE NULL END) AS product_4,
    COUNT(DISTINCT CASE WHEN product_id = 4 THEN ir.order_item_refund_id ELSE NULL END) AS p4_refund,
	COUNT(DISTINCT CASE WHEN product_id = 4 THEN ir.order_item_refund_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN product_id = 4 THEN oi.order_item_id ELSE NULL END) AS p4_rt

    
FROM order_items oi
	LEFT JOIN order_item_refunds ir
		USING(order_item_id)
WHERE oi.created_at < '2014-10-16'
GROUP BY 1,2
;