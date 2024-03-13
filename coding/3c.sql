USE mavenfuzzyfactory;

SELECT 
	ws.utm_source,
    ws.device_type,
	COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) As orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) As cvr
FROM website_sessions ws
	LEFT JOIN orders o
		USING(website_session_id)
WHERE ws.created_at BETWEEN "2012-08-22" AND "2012-09-19"
	AND ws.utm_campaign = "nonbrand"
GROUP BY ws.utm_source, ws.device_type
;
