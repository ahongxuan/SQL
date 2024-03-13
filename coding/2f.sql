USE mavenfuzzyfactory;

DROP TEMPORARY TABLE IF EXISTS session_w_landing;
CREATE TEMPORARY TABLE session_w_landing
SELECT 
	ws.website_session_id,
	MIN(wp.website_pageview_id) AS first_pageview_id,
    COUNT(DISTINCT wp.website_pageview_id) AS count_pageview,
    DATE(wp.created_at) AS date_of_first_pageview,
    pageview_url As landing_page
FROM website_sessions ws
LEFT JOIN website_pageviews wp
	ON ws.website_session_id = wp.website_session_id 
WHERE wp.created_at BETWEEN '2012-06-01' AND '2012-08-31'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY ws.website_session_id
;

SELECT 
    MIN(date_of_first_pageview) AS week_start_date,
	COUNT(DISTINCT website_session_id) AS total_session,
	COUNT(DISTINCT CASE WHEN count_pageview = 1 THEN website_session_id ELSE NULL END) AS bounced_session,
	COUNT(DISTINCT CASE WHEN count_pageview = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS bounced_session,
	COUNT(DISTINCT CASE WHEN landing_page =  '/home' THEN website_session_id ELSE NULL END) AS home_session,
	COUNT(DISTINCT CASE WHEN landing_page =  '/lander-1'  THEN website_session_id ELSE NULL END) AS lander_session

FROM session_w_landing 
GROUP BY WEEK(date_of_first_pageview)
;

