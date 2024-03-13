USE mavenfuzzyfactory;

SELECT 
	YEAR(created_at),
    MONTH(created_at),
	COUNT(CASE WHEN utm_campaign = "nonbrand" THEN website_session_id ELSE NULL END) AS nonbrand,
	COUNT(CASE WHEN utm_campaign = "brand" THEN website_session_id ELSE NULL END) AS brand,
    COUNT(CASE WHEN utm_campaign = "brand" THEN website_session_id ELSE NULL END)/COUNT(CASE WHEN utm_campaign = "nonbrand" THEN website_session_id ELSE NULL END) AS brand_pct_nonbrand,
    
    COUNT(CASE WHEN utm_campaign IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END) AS direct,
    COUNT(CASE WHEN utm_campaign IS NULL AND http_referer IS NULL THEN website_session_id ELSE NULL END)/COUNT(CASE WHEN utm_campaign = "nonbrand" THEN website_session_id ELSE NULL END) AS direct_pct_nonbrand,
    
    
	COUNT(CASE WHEN utm_campaign IS NULL AND http_referer IN("https://www.gsearch.com", "https://www.bsearch.com") THEN website_session_id ELSE NULL END)  AS organic,
    COUNT(CASE WHEN utm_campaign IS NULL AND http_referer IN("https://www.gsearch.com", "https://www.bsearch.com") THEN website_session_id ELSE NULL END) /COUNT(CASE WHEN utm_campaign = "nonbrand" THEN website_session_id ELSE NULL END) AS organic_pct_nonbrand
    
    

FROM website_sessions

WHERE created_at < "2012-12-23"
GROUP BY 1,2
;

