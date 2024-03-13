USE mavenfuzzyfactory;

SELECT 
	hr,
    ROUND(AVG(CASE WHEN wkday = 0 THEN website_session_count ELSE NULL END),1) as MON,
	ROUND(AVG(CASE WHEN wkday = 1 THEN website_session_count ELSE NULL END),1) as TUS,
    ROUND(AVG(CASE WHEN wkday = 2 THEN website_session_count ELSE NULL END),1) as WED,
    ROUND(AVG(CASE WHEN wkday = 3 THEN website_session_count ELSE NULL END),1) as THUR,
    ROUND(AVG(CASE WHEN wkday = 4 THEN website_session_count ELSE NULL END),1) as FRI,
    ROUND(AVG(CASE WHEN wkday = 5 THEN website_session_count ELSE NULL END),1) as SAT,
    ROUND(AVG(CASE WHEN wkday = 6 THEN website_session_count ELSE NULL END),1) as SUN

FROM (
SELECT 
	Date(created_at) AS dates,
    WEEKDAY(created_at) AS wkday,
    HOUR(created_at)as hr,
    COUNT(DISTINCT website_session_id) AS website_session_count
FROM website_sessions
WHERE created_at BETWEEN "2012-09-15" AND "2012-11-15"
GROUP BY 1,2,3 

) as session_by_date
GROUP BY 1
ORDER BY 1
;


