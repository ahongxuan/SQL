USE mavenfuzzyfactory;

SELECT ws.website_session_id,
	wp.pageview_url,
    wp.created_at
FROM website_sessions ws
LEFT JOIN website_pageviews wp
	ON ws.website_session_id = wp.website_session_id
WHERE wp.created_at between '2012-08-05' AND '2012-09-05'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY pageview_url
;


SELECT ws.website_session_id,
	wp.pageview_url,
    wp.created_at,
	CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_session,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS fuzzy_session,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_session,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_session,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_session,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS order_session
FROM website_sessions ws
LEFT JOIN website_pageviews wp
	ON ws.website_session_id = wp.website_session_id
WHERE wp.created_at between '2012-08-05' AND '2012-09-05'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
ORDER BY ws.website_session_id
;

SELECT ws.website_session_id,
	wp.pageview_url,
    wp.created_at,
	CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_session,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS fuzzy_session,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_session,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_session,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_session,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS order_session
FROM website_sessions ws
LEFT JOIN website_pageviews wp
	ON ws.website_session_id = wp.website_session_id
WHERE wp.created_at between '2012-08-05' AND '2012-09-05'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
ORDER BY ws.website_session_id
;


DROP TEMPORARY TABLE IF EXISTS session_level;

CREATE TEMPORARY TABLE session_level   
SELECT website_session_id, 
	MAX(product_session) AS max_product,
	MAX(fuzzy_session) AS max_fuzzy,
    MAX(cart_session) AS max_cart,
	MAX(shipping_session) AS max_shipping,
	MAX(billing_session) AS max_billing,
    MAX(order_session) AS max_order
FROM (

SELECT ws.website_session_id,
	wp.pageview_url,
    wp.created_at,
	CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_session,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS fuzzy_session,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_session,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_session,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_session,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS order_session

FROM website_sessions ws
LEFT JOIN website_pageviews wp
	ON ws.website_session_id = wp.website_session_id
WHERE wp.created_at between '2012-08-05' AND '2012-09-05'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
ORDER BY ws.website_session_id

) AS conversion
GROUP BY website_session_id
;

SELECT 
	COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(DISTINCT CASE WHEN max_product = 1 THEN website_session_id ELSE NULL END) AS count_product,
	COUNT(DISTINCT CASE WHEN max_fuzzy = 1 THEN website_session_id ELSE NULL END) AS count_fuzzy,
	COUNT(DISTINCT CASE WHEN max_cart = 1 THEN website_session_id ELSE NULL END) AS count_cart,
	COUNT(DISTINCT CASE WHEN max_shipping = 1 THEN website_session_id ELSE NULL END) AS count_shipping,
	COUNT(DISTINCT CASE WHEN max_billing = 1 THEN website_session_id ELSE NULL END) AS count_billing,
	COUNT(DISTINCT CASE WHEN max_order = 1 THEN website_session_id ELSE NULL END) AS count_order

FROM session_level
;


SELECT 
	COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(DISTINCT CASE WHEN max_product = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id)  AS rate_product,
	COUNT(DISTINCT CASE WHEN max_fuzzy = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN max_product = 1 THEN website_session_id ELSE NULL END)  AS rate_fuzzy,
	COUNT(DISTINCT CASE WHEN max_cart = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN max_fuzzy = 1 THEN website_session_id ELSE NULL END)  AS rate_cart,
	COUNT(DISTINCT CASE WHEN max_shipping = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN max_cart = 1 THEN website_session_id ELSE NULL END)  AS rate_shipping,
	COUNT(DISTINCT CASE WHEN max_billing = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN max_shipping = 1 THEN website_session_id ELSE NULL END) AS rate_billing,
	COUNT(DISTINCT CASE WHEN max_order = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN max_billing = 1 THEN website_session_id ELSE NULL END)  AS rate_order

FROM session_level
;