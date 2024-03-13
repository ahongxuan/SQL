USE mavenfuzzyfactory;


SELECT 
	MIN(website_pageview_id),
	MIN(website_session_id)
FROM website_pageviews
WHERE pageview_url = '/billing-2'
;

SELECT pageview_url
FROM website_pageviews
WHERE website_pageview_id >=53550
	AND created_at < '2012-11-10' 
GROUP BY pageview_url
;
SELECT 
	wp.website_session_id,
    o.order_id,
	-- MIN(DATE(created_at)) AS first_created_at,
	-- MIN(website_pageview_id) AS min_pageview,
	wp.pageview_url
FROM website_pageviews wp
 LEFT JOIN orders o
	USING (website_session_id)
WHERE website_pageview_id >=53550
	AND wp.created_at < '2012-11-10'
    AND wp.pageview_url IN ('/billing','/billing-2')
-- GROUP BY website_session_id
;

SELECT 
	pageview_url,
	COUNT(website_session_id)As sessions_id,
    COUNT(order_id) As order_session,
    COUNT(order_id)/COUNT(website_session_id) As bconvert_rate
FROM 
(
SELECT 
	wp.website_session_id,
    o.order_id,
	wp.pageview_url
FROM website_pageviews wp
 LEFT JOIN orders o
	USING (website_session_id)
WHERE website_pageview_id >=53550
	AND wp.created_at < '2012-11-10'
    AND wp.pageview_url IN ('/billing','/billing-2')
) AS billing_session_w_orders
GROUP BY pageview_url

;