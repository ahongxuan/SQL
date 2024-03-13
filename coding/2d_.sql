USE mavenfuzzyfactory;
DROP TEMPORARY TABLE IF EXISTS first_pageview;

CREATE TEMPORARY TABLE first_pageview
SELECT 
	website_session_id,
	MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at <'2012-06-14'
GROUP BY website_session_id
;

DROP TEMPORARY TABLE IF EXISTS session_w_landing_page;

CREATE TEMPORARY TABLE session_w_landing_page

SELECT 
	first_pageview.website_session_id,
	website_pageviews.pageview_url as landing_page
FROM first_pageview
	LEFT JOIN website_pageviews
		ON first_pageview.min_pageview_id = website_pageviews.website_pageview_id 
WHERE website_pageviews.pageview_url = '/home';





DROP TEMPORARY TABLE IF EXISTS bounced_sessions_only;

CREATE TEMPORARY TABLE bounced_sessions_only
SELECT 
	sl.website_session_id, 
	sl.landing_page,
	COUNT(wp.website_pageview_id) AS count_of_pageviewed
FROM session_w_landing_page sl
LEFT JOIN website_pageviews wp
    ON wp.website_session_id = sl.website_session_id 
GROUP BY sl.website_session_id
HAVING count_of_pageviewed =1
;





SELECT
	sl.website_session_id,
    b.website_session_id AS bounced_website_session
FROM session_w_landing_page sl
LEFT JOIN bounced_sessions_only b
	ON b.website_session_id = sl.website_session_id
ORDER BY sl.website_session_id;

SELECT
	COUNT(DISTINCT sl.website_session_id) AS total_session,
    COUNT(DISTINCT b.website_session_id) AS bounced_session,
    COUNT(DISTINCT b.website_session_id)/COUNT(DISTINCT sl.website_session_id) AS bounced_rate
FROM session_w_landing_page sl
	LEFT JOIN bounced_sessions_only b
		ON sl.website_session_id = b.website_session_id;