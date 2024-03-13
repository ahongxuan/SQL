USE mavenfuzzyfactory;

SELECT min(website_pageview_id), min(created_at)
FROM website_pageviews
WHERE pageview_url = '/lander-1'
;
-- 23504 MIN pageview_id
DROP TEMPORARY TABLE IF EXISTS first_page;
CREATE TEMPORARY TABLE first_page

SELECT 
	website_session_id,
	pageview_url,
	MIN(website_pageview_id) AS sessions,
    COUNT(website_session_id) AS bounced_sessions
FROM website_pageviews wp
LEFT JOIN  website_sessions ws
	USING(website_session_id)
WHERE wp.created_at <'2012-07-28' 
	AND website_pageview_id > 23504
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY website_session_id
-- HAVING bounced_sessions =1
;


DROP TEMPORARY TABLE IF EXISTS second_page;
CREATE TEMPORARY TABLE second_page

SELECT *
FROM first_page
WHERE  bounced_sessions = 1
;


SELECT 
	f.pageview_url,
    f.website_session_id AS total_sessions,
	s.website_session_id As bounced_sessions
FROM first_page f
LEFT JOIN second_page s
	USING (website_session_id)
;


SELECT 
	f.pageview_url,
	COUNT(DISTINCT s.website_session_id) As bounced_sessions,
	COUNT(DISTINCT f.website_session_id) AS total_sessions,
    COUNT(DISTINCT s.website_session_id)/COUNT(DISTINCT f.website_session_id) AS bounced_rate
FROM first_page f
LEFT JOIN second_page s
	ON f.website_session_id = s.website_session_id
GROUP BY f.pageview_url
;