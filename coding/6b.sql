Use mavenfuzzyfactory;

CREATE TEMPORARY TABLE first_session_time

SELECT
	limit_session.created_at As first_time,
	limit_session.website_session_id AS new_session_id,
    limit_session.user_id,
    MIN(website_sessions.website_session_id) As come_back_session
FROM(
SELECT 
	website_session_id,
	user_id,
    created_at
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-03'
	AND is_repeat_session = 0
) AS limit_session 
	LEFT JOIN website_sessions 
		ON  website_sessions.user_id = limit_session.user_id 
		AND website_sessions.website_session_id > limit_session.website_session_id
		AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-01'	
GROUP BY 2
;
SELECT
	AVG(DATEDIFF(comeback_time,first_time)) As avg_time,
    MAX(DATEDIFF(comeback_time,first_time)) As max_time,
    min(DATEDIFF(comeback_time,first_time)) As min_time
FROM(
SELECT 
	first_session_time.user_id,
	first_session_time.first_time,
	first_session_time.new_session_id,
    come_back_session,
    website_sessions.created_at AS comeback_time
FROM first_session_time
	inner JOIN website_sessions
		ON first_session_time.come_back_session = website_sessions.website_session_id
) AS time_table

;

