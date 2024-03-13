USE mavenfuzzyfactory;

SELECT 
	w.device_type,
	COUNT(DISTINCT w.website_session_id) as sessions,
    COUNT(DISTINCT o.order_id) as orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) as CVR
	
FROM website_sessions w
	LEFT JOIN orders o 
		USING(website_session_id)
        
WHERE w.created_at < '2012-05-11' 
	AND w.utm_source = 'gsearch'
    AND w.utm_campaign = 'nonbrand'
    
GROUP BY w.device_type
;