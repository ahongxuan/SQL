USE mavenfuzzyfactory;

SELECT 
    COUNT(DISTINCT w.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS CVR
FROM website_sessions as w
LEFT JOIN orders AS o 
	USING (website_session_id)

WHERE w.created_at < '2012-04-12' 
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
;