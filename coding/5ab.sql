Use mavenfuzzyfactory;

SELECT 
	YEAR(created_at) AS yr,
    Month(created_at) As moth,
    COUNT(order_id) as number_of_sales,
    SUM(price_usd) as total_revenue,
    SUM(price_usd - cogs_usd) as total_margin
FROM orders
WHERE created_at < '2013-01-04'
GROUP BY 1,2
;

SELECT *
FROM orders; 

SELECT 
	YEAR(ws.created_at) AS yr,
    Month(ws.created_at) As moth,
    COUNT(o.order_id) as number_of_sales,
    COUNT(o.order_id)/COUNT(ws.website_session_id) AS cv_rate,
    SUM(price_usd)/COUNT(ws.website_session_id) as session_revenue,
    COUNT(CASE WHEN primary_product_id = 1 THEN order_id ELSE NULL END) AS product_one,
	COUNT(CASE WHEN primary_product_id = 2 THEN order_id ELSE NULL END) AS product_two
FROM website_sessions ws
	LEFT JOIN orders o
		USING(website_session_id)
WHERE ws.created_at BETWEEN  '2012-04-01' AND '2013-04-05'
GROUP BY 1,2
;

