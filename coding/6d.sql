Use mavenfuzzyfactory;

SELECT 
	is_repeat_session,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS crt,
	SUM(price_usd)/COUNT(DISTINCT website_session_id) AS rev_per_sessions
FROM(
SELECT 
	website_sessions.website_session_id,
    is_repeat_session,
    orders.order_id,
    orders.price_usd
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-08'
) AS order_sessions


GROUP BY 1
;

