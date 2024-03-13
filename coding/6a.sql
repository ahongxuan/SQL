Use mavenfuzzyfactory;

CREATE TEMPORARY TABLE session_w_repeat
SELECT
	limit_session.website_session_id AS new_session_id,
    limit_session.user_id,
    website_sessions.website_session_id As repeat_session_id
FROM(
SELECT 
	website_session_id,
	user_id
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-01'
	AND is_repeat_session = 0
) AS limit_session 
	LEFT JOIN website_sessions 
		ON  website_sessions.user_id = limit_session.user_id 
		AND website_sessions.is_repeat_session = 1
		AND website_sessions.website_session_id > limit_session.website_session_id
		AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-01'	
;



SELECT 
	repeat_sessions,
	COUNT(DISTINCT user_id) as users
FROM(
SELECT
	user_id,
    COUNT(DISTINCT new_session_id) As new_sessions,
    COUNT(DISTINCT repeat_session_id) As repeat_sessions
FROM session_w_repeat
GROUP BY 1
) As user_level
GROUP By 1
ORDER BY 1
;