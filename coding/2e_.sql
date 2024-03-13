USE mavenfuzzyfactory;

SELECT*
FROM website_pageviews
WHERE pageview_url = '/lander-1'
;


CREATE TEMPORARY TABLE first_test_pageviews
SELECT 
	wp.website_session_id,
    MIN(wp.website_pageview_id) AS min_pageview_id
FROM website_pageviews wp
	INNER JOIN website_sessions ws
		ON ws.website_session_id = wp.website_session_id
        AND ws.created_at <'2012-07-28'
        AND wp.website_pageview_id >23504
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY wp.website_session_id
;

CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_page

SELECT ft.website_session_id, wp.pageview_url AS landing_page
FROM first_test_pageviews ft
	LEFT JOIN website_pageviews wp
		ON ft.min_pageview_id = wp.website_pageview_id
;
CREATE TEMPORARY TABLE nonbrand_test_bounced_sessions
SELECT 
	sl.website_session_id, 
	sl.landing_page,
	COUNT(wp.website_pageview_id) AS count_of_pageviewed
FROM nonbrand_test_sessions_w_landing_page sl
LEFT JOIN website_pageviews wp
    ON wp.website_session_id = sl.website_session_id 
GROUP BY sl.website_session_id, sl.landing_page
HAVING count_of_pageviewed =1
;

SELECT
	sl.landing_page,
	sl.website_session_id,
    b.website_session_id AS bounced_website_session
FROM nonbrand_test_sessions_w_landing_page sl
LEFT JOIN nonbrand_test_bounced_sessions b
	ON b.website_session_id = sl.website_session_id
ORDER BY sl.website_session_id;

SELECT
	sl.landing_page,
	COUNT(DISTINCT sl.website_session_id) AS total_session,
    COUNT(DISTINCT b.website_session_id) AS bounced_session,
    COUNT(DISTINCT b.website_session_id)/COUNT(DISTINCT sl.website_session_id) AS bounced_rate
FROM nonbrand_test_sessions_w_landing_page sl
	LEFT JOIN nonbrand_test_bounced_sessions b
		ON sl.website_session_id = b.website_session_id
GROUP BY sl.landing_page;