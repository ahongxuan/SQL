USE mavenfuzzyfactory;

SELECT 
	MIN(DATE(created_at)),
    COUNT(DISTINCT CASE WHEN utm_source = "gsearch" AND device_type = "desktop" THEN website_session_id ELSE NULL END) AS g_desk_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = "bsearch" AND device_type = "desktop" THEN website_session_id ELSE NULL END) AS b_desk_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = "bsearch" AND device_type = "desktop" THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source = "gsearch" AND device_type = "desktop" THEN website_session_id ELSE NULL END) AS g_b_desk,
	COUNT(DISTINCT CASE WHEN utm_source = "gsearch" AND device_type = "mobile" THEN website_session_id ELSE NULL END) AS g_mobile_sessions,
	COUNT(DISTINCT CASE WHEN utm_source = "bsearch" AND device_type = "mobile" THEN website_session_id ELSE NULL END) AS b_mobile_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = "bsearch" AND device_type = "mobile" THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source = "gsearch" AND device_type = "mobile" THEN website_session_id ELSE NULL END) AS g_b_mobile

FROM website_sessions

WHERE created_at BETWEEN "2012-11-04" AND "2012-12-22"
	AND utm_campaign = "nonbrand"

GROUP BY YEARWEEK(created_at)
;
