USE mavenfuzzyfactory;
CREATE TEMPorary TABLE temp_landing
SELECT MIN(website_pageview_id) AS pageview_id,
	pageview_url AS landing_page

FROM website_pageviews

WHERE created_at <'2012-06-12'

GROUP BY website_session_id

;

SELECT COUNT(DISTINCT pageview_id), landing_page
FROM temp_landing
GROUP BY landing_page;
