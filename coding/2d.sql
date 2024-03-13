USE mavenfuzzyfactory;
CREATE TEMPORARY TABLE bounced_session
SELECT 
	website_session_id,
	pageview_url,
	MIN(website_pageview_id) AS sessions,
    COUNT(website_session_id) AS bounced_sessions
FROM website_pageviews
WHERE created_at <'2012-06-14'
GROUP BY website_session_id
HAVING bounced_sessions =1
;

CREATE TEMPORARY TABLE first_session

SELECT 
	website_session_id,
	pageview_url,
	MIN(website_pageview_id) AS sessions,
    COUNT(website_session_id) AS bounced_sessions
FROM website_pageviews
WHERE created_at <'2012-06-14'
GROUP BY website_session_id;


SELECT 
	COUNT(DISTINCT f.website_session_id) AS sessions,
    COUNT(DISTINCT b.website_session_id)AS bounced_sessions,
    COUNT(DISTINCT b.website_session_id)/COUNT(DISTINCT f.website_session_id) AS bounced_rate
FROM first_session f
LEFT JOIN bounced_session b
	ON (f.website_session_id = b.website_session_id)
    
GROUP BY f.pageview_url
;

