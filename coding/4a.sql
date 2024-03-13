USE mavenfuzzyfactory;

SELECT 
	YEAR(ws.created_at) as year,
    month(ws.created_at) as mo,
    COUNT(DISTINCT ws.website_session_id) as toatl_sessions,
    COUNT(DISTINCT o.order_id) as order_sessions
FROM website_sessions ws
	LEFT JOIN orders o
		USING(website_session_id)
WHERE ws.created_at < "2013-01-02"
GROUP BY 1,2
;

SELECT 
	MIN(DATE(ws.created_at)) as weak_start,
    COUNT(DISTINCT ws.website_session_id) as toatl_sessions,
    COUNT(DISTINCT o.order_id) as order_sessions
FROM website_sessions ws
	LEFT JOIN orders o
		USING(website_session_id)
WHERE ws.created_at < "2013-01-02"
GROUP BY year(ws.created_at), WEEK(ws.created_at)
;