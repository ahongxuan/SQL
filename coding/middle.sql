USE mavenfuzzyfactory;
-- pull monthly trends for gsearch sessions and orders
SELECT
	YEAR(ws.created_at) as yr,
	MONTH(ws.created_at),
	COUNT(ws.website_session_id),
    COUNT(o.order_id),
    COUNT(o.order_id)/COUNT(ws.website_session_id)
FROM website_sessions ws
LEFT JOIN orders o
	USING(website_session_id)
WHERE ws.created_at < '2012-11-27' 
	AND utm_source = 'gsearch'
GROUP BY 1,2
;
-- 2

SELECT 
	YEAR(ws.created_at) as yr,
    MONTH(ws.created_at) as mo,
    COUNT(CASE WHEN utm_campaign ="nonbrand" THEN ws.website_session_id ELSE NULL END) as nonbrand_sessions,
	COUNT(CASE WHEN utm_campaign ="brand" THEN ws.website_session_id ELSE NULL END) as brand_sessions,
    COUNT(CASE WHEN utm_campaign ="nonbrand" THEN order_id ELSE NULL END) as nonbrand_order,
    COUNT(CASE WHEN utm_campaign ="brand" THEN order_id ELSE NULL END) as brand_order,
	COUNT(CASE WHEN utm_campaign ="nonbrand" THEN ws.website_session_id ELSE NULL END)/COUNT(CASE WHEN utm_campaign ="nonbrand" THEN order_id ELSE NULL END) as nonbrand_convert_rate,
	COUNT(CASE WHEN utm_campaign ="brand" THEN ws.website_session_id ELSE NULL END)/COUNT(CASE WHEN utm_campaign ="brand" THEN order_id ELSE NULL END) as brand_convert_rate

FROM website_sessions ws
LEFT JOIN orders o
	USING(website_session_id)
WHERE ws.created_at < '2012-11-27'
	AND utm_source = 'gsearch'
GROUP BY 1,2

;
-- 3

SELECT 
	YEAR(ws.created_at) as yr,
    MONTH(ws.created_at) as mo,
    COUNT(CASE WHEN device_type ="desktop" THEN ws.website_session_id ELSE NULL END) as desktop_sessions,
	COUNT(CASE WHEN device_type ="mobile" THEN ws.website_session_id ELSE NULL END) as mobile_sessions,
    COUNT(CASE WHEN device_type ="desktop" THEN order_id ELSE NULL END) as desktop_order,
    COUNT(CASE WHEN device_type ="mobile" THEN order_id ELSE NULL END) as mobile_order,
	COUNT(CASE WHEN device_type ="desktop" THEN ws.website_session_id ELSE NULL END)/COUNT(CASE WHEN device_type ="desktop" THEN order_id ELSE NULL END) as desktop_convert_rate,
	COUNT(CASE WHEN device_type ="mobile" THEN ws.website_session_id ELSE NULL END)/COUNT(CASE WHEN device_type ="mobile" THEN order_id ELSE NULL END) as mobile_convert_rate

FROM website_sessions ws
LEFT JOIN orders o
	USING(website_session_id)
WHERE ws.created_at < '2012-11-27'
	AND utm_source = 'gsearch'
    AND utm_campaign ="nonbrand"
GROUP BY 1,2
;


-- 4
SELECT 
	YEAR(ws.created_at) as yr,
    MONTH(ws.created_at) as mo,
    COUNT(CASE WHEN utm_source ="gsearch" THEN ws.website_session_id ELSE NULL END) as gsearch_sessions,
	COUNT(CASE WHEN utm_source ="bsearch" THEN ws.website_session_id ELSE NULL END) as bsearch_sessions,
   	COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN ws.website_session_id ELSE NULL END) as organic_search_sessions,
    COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN ws.website_session_id ELSE NULL END) as direct_tpye_sessions

FROM website_sessions ws
LEFT JOIN orders o
	USING(website_session_id)
WHERE ws.created_at < '2012-11-27'
GROUP BY 1,2
;
-- 5

SELECT 
	MIN(website_pageview_id)
FROM website_pageviews
WHERE pageview_url = '/lander-1'
;
--  '23504'
DROP TEMPORARY TABLE IF EXISTS fist_test_pageview;
CREATE TEMPORARY TABLE fist_test_pageview
SELECT 
	wp.website_session_id,
	MIN(wp.website_pageview_id) AS first_page_view
FROM  website_pageviews wp
INNER JOIN website_sessions ws
	USING(website_session_id)
WHERE wp.website_pageview_id >= 23504
    AND ws.created_at <'2012-07-28'
	AND utm_source = 'gsearch'
    AND utm_campaign ="nonbrand"
GROUP BY wp.website_session_id;
    
DROP TEMPORARY TABLE IF EXISTS test_session_w_landing;
CREATE TEMPORARY TABLE test_session_w_landing
SELECT 
	fp.website_session_id,
	wp.pageview_url as landing_page
FROM fist_test_pageview fp
LEFT JOIN website_pageviews wp
	ON fp.first_page_view = wp.website_pageview_id
WHERE wp.pageview_url IN('/home', '/lander-1')
; 

SELECT 
	tl.landing_page,
    COUNT(DISTINCT tl.website_session_id) as total_sessions,
    COUNT(DISTINCT o.order_id) as order_sessions,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT tl.website_session_id) as convert_rate
FROM test_session_w_landing tl
LEFT JOIN orders o
	USING(website_session_id)
GROUP BY tl.landing_page;

SELECT 
	MAX(ws.website_session_id)
FROM  website_sessions ws
INNER JOIN website_pageviews wp
	USING(website_session_id)
WHERE wp.pageview_url ='/home'
    AND ws.created_at <'2012-11-27'
	AND utm_source = 'gsearch'
    AND utm_campaign ="nonbrand"
;
    
SELECT
	COUNT(website_session_id)
FROM website_sessions
WHERE created_at <'2012-11-27'
	AND website_session_id>17145
	AND utm_source = 'gsearch'
    AND utm_campaign ="nonbrand";
    
-- 6

DROP TEMPORARY TABLE IF EXISTS pageview_session;
CREATE TEMPORARY TABLE pageview_session
SELECT website_session_id, 
	MAX(home_session) AS max_home,
    MAX(lander1_session) AS max_lander1,
	MAX(product_session) AS max_product,
	MAX(fuzzy_session) AS max_fuzzy,
    MAX(cart_session) AS max_cart,
	MAX(shipping_session) AS max_shipping,
	MAX(billing_session) AS max_billing,
    MAX(order_session) AS max_order
FROM (

SELECT ws.website_session_id,
	wp.pageview_url,
	CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS home_session,
	CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS lander1_session,
	CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_session,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS fuzzy_session,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_session,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_session,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_session,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS order_session

FROM website_sessions ws
LEFT JOIN website_pageviews wp
	ON ws.website_session_id = wp.website_session_id
WHERE wp.created_at between '2012-06-19' AND '2012-07-28'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
ORDER BY ws.website_session_id, wp.created_at

) AS pageview
GROUP BY website_session_id
;

SELECT 
	CASE WHEN max_home = 1 THEN 'saw_homepage'
		WHEN max_lander1 = 1 THEN 'saw_lander1'
		ELSE 'check logic'
	END AS segment,
	COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(DISTINCT CASE WHEN max_product = 1 THEN website_session_id ELSE NULL END) AS count_product,
	COUNT(DISTINCT CASE WHEN max_fuzzy = 1 THEN website_session_id ELSE NULL END) AS count_fuzzy,
	COUNT(DISTINCT CASE WHEN max_cart = 1 THEN website_session_id ELSE NULL END) AS count_cart,
	COUNT(DISTINCT CASE WHEN max_shipping = 1 THEN website_session_id ELSE NULL END) AS count_shipping,
	COUNT(DISTINCT CASE WHEN max_billing = 1 THEN website_session_id ELSE NULL END) AS count_billing,
	COUNT(DISTINCT CASE WHEN max_order = 1 THEN website_session_id ELSE NULL END) AS count_order
FROM pageview_session
GROUP BY 1;

-- 8
SELECT 
	wp.website_session_id,
    wp.pageview_url,
    o.order_id,
    o.price_usd
FROM  website_pageviews wp
	LEFT JOIN orders o
		USING(website_session_id)
WHERE wp.pageview_url IN('/billing','/billing-2')
	AND wp.created_at BETWEEN '2012-09-10' AND '2012-11-10'

;


SELECT 
	pageview_url,
    COUNT(DISTINCT website_session_id),
    SUM(price_usd)/COUNT(DISTINCT website_session_id)
FROM (
SELECT 
	wp.website_session_id,
    wp.pageview_url,
    o.order_id,
    o.price_usd
FROM  website_pageviews wp
	LEFT JOIN orders o
		USING(website_session_id)
WHERE wp.pageview_url IN('/billing','/billing-2')
	AND wp.created_at BETWEEN '2012-09-10' AND '2012-11-10'

) As bill
GROUP BY 1;


SELECT COUNT(website_session_id)
FROM website_pageviews
WHERE pageview_url IN('/billing','/billing-2')
	AND created_at BETWEEN '2012-10-27' AND '2012-11-27';
