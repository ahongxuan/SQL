Use mavenfuzzyfactory;

CREATE TEMPORARY TABLE channel_sessions
SELECT 
	website_session_id,
    is_repeat_session,
    CASE WHEN utm_campaign = 'nonbrand'  THEN 'paid_nonbrand'
		 WHEN utm_campaign = 'socialbook'  THEN 'paid_social'
		 WHEN utm_campaign = 'brand'  THEN 'paid_brand'
		 WHEN utm_campaign IS NULL AND  http_referer IS NULL THEN 'direct_type_in'
         WHEN utm_campaign IS NULL AND http_referer IN("https://www.gsearch.com", "https://www.bsearch.com") THEN  'organic_search'
	ELSE 'dont know the path'
    END AS channel_group
FROM (
SELECT 
	website_session_id,
    utm_source,
    utm_campaign,
    user_id,
    is_repeat_session,
    http_referer
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-05'
) AS channel_sessions

;

SELECT
	channel_group,
    COUNT(DISTINCT CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
	COUNT(DISTINCT CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM channel_sessions
GROUP BY 1
Order BY  2,3 DESC
;