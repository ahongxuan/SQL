USE mavenfuzzyfactory;

SELECT 
	wp.website_session_id,
	MIN(wp.website_pageview_id) AS min_pageview_id,
	ws.created_at
FROM website_pageviews wp

	Inner JOIN website_sessions ws 
		ON ws.website_session_id = wp.website_session_id
	AND ws.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY wp.website_session_id
;

SELECT *
FROM website_pageviews
WHERE website_session_id = 175252;

DROP TEMPORARY TABLE IF EXISTS first_pageviews_demo;
CREATE TEMPORARY TABLE first_pageviews_demo
SELECT 
	wp.website_session_id,
	MIN(wp.website_pageview_id) AS min_pageview_id
FROM website_pageviews wp

	Inner JOIN website_sessions ws 
		ON ws.website_session_id = wp.website_session_id
	AND ws.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY wp.website_session_id
;
SELECT * FROM first_pageviews_demo;



DROP TEMPORARY TABLE IF EXISTS sessions_w_landing_page_demo;
CREATE TEMPORARY TABLE sessions_w_landing_page_demo
SELECT 
	first_pageviews_demo.website_session_id,
	-- min_pageview_id,
    pageview_url As landing_page
FROM first_pageviews_demo 
	LEFT JOIN website_pageviews
		ON first_pageviews_demo.min_pageview_id  = website_pageviews.website_pageview_id
	 
;
SELECT * FROM sessions_w_landing_page_demo;
CREATE TEMPORARY TABLE bounced_sessions_only
SELECT sl.website_session_id, sl.landing_page,
	COUNT(wp.website_pageview_id) AS count_of_pageviewed
FROM sessions_w_landing_page_demo sl
LEFT JOIN website_pageviews wp
    USING(website_session_id)
GROUP BY sl.website_session_id
HAVING count_of_pageviewed =1
;
SELECT * FROM bounced_sessions_only;
SELECT 
	sl.website_session_id,
    sl.landing_page,
    bs.website_session_id
FROM sessions_w_landing_page_demo sl
LEFT JOIN bounced_sessions_only bs
	ON sl.website_session_id = bs.website_session_id
ORDER BY sl.website_session_id
;
SELECT 
	sl.landing_page,
    COUNT(DISTINCT sl.website_session_id) AS sessions,
    COUNT(DISTINCT bs.website_session_id) AS bounced_session,
    COUNT(DISTINCT bs.website_session_id)/COUNT(DISTINCT sl.website_session_id) As bounced_rate
FROM sessions_w_landing_page_demo sl
LEFT JOIN bounced_sessions_only bs
	ON sl.website_session_id = bs.website_session_id
GROUP BY sl.landing_page
;