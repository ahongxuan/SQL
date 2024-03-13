Use mavenfuzzyfactory;

SELECT 
	CASE WHEN ws.created_at < '2013-12-12' THEN 'A.Pre_Birthday_Bear'
		 WHEN  ws.created_at >= '2013-12-12' THEN 'B.Post_Birthday_Bear'
	ELSE 'check'
    END AS time_period,
	COUNT(DISTINCT ws.website_session_id) AS total_sessions,
	COUNT(DISTINCT order_id) AS place_order,
	COUNT(DISTINCT order_id)/COUNT(DISTINCT ws.website_session_id) AS session_to_order_crt,
    SUM(price_usd)/COUNT(DISTINCT order_id)  AS aov,
    SUM(items_purchased)/COUNT(DISTINCT order_id) AS products_per_order,
    SUM(price_usd)/COUNT(DISTINCT ws.website_session_id) AS revenue_per_sessions
FROM website_sessions ws
LEFT JOIN orders o
	USING(website_session_id)
WHERE ws.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY time_period
;