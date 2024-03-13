USE mavenfuzzyfactory;
CREATE TEMPORARY TABLE first_pv_per_session
SELECT 
	website_session_id,
	MIN(website_pageview_id) AS first_pv

FROM website_pageviews

WHERE created_at <'2012-06-12'

GROUP BY website_session_id

;

SELECT 
	wp.pageview_url AS landing_page_url,
	COUNT(DISTINCT pv.website_session_id) AS session_hitting_page
FROM first_pv_per_session pv
	LEFT JOIN website_pageviews  wp
		ON pv.first_pv = wp.website_pageview_id
GROUP BY wp.pageview_url
;
