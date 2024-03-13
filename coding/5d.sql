Use mavenfuzzyfactory;
DROP TEMPORARY TABLE IF exists product_pageview1;
CREate temporary table product_pageview1
SELECT 	
	website_pageview_id,
    website_session_id,
    pageview_url As product_page_seen
FROM website_pageviews
WHERE created_at BETWEEN '2013-01-06' AND '2013-04-10'
	AND pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear')
;

SELECT DISTINCT
	wp.pageview_url
FROM product_pageview1 p1
LEFT JOIN website_pageviews wp
	ON p1.website_session_id = wp.website_session_id
    AND wp.website_pageview_id > p1.website_pageview_id
;



SELECT
	p1.website_session_id,
    p1.product_page_seen,
	CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END As to_cart,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END As to_shipping,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END As to_billing,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END As to_thankyou
FROM product_pageview1 p1
LEFT JOIN website_pageviews wp
	ON p1.website_session_id = wp.website_session_id
    AND wp.website_pageview_id > p1.website_pageview_id
order by 1, wp.created_at
;

CREate temporary table sessions_w_diff_page
SELECT 
	website_session_id,
    CASE WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
		 WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
	ELSE 'check'
    END AS product_seen,
    max(to_cart) AS cart_md,
    max(to_shipping) AS shipping_md,
    max(to_billing) AS billing_md,
    max(to_thankyou) AS thankyou_md
FROM (SELECT
	p1.website_session_id,
    p1.product_page_seen,
	CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END As to_cart,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END As to_shipping,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END As to_billing,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END As to_thankyou
FROM product_pageview1 p1
LEFT JOIN website_pageviews wp
	ON p1.website_session_id = wp.website_session_id
    AND wp.website_pageview_id > p1.website_pageview_id
order by 1, wp.created_at) as nextPage
GROUP BY 1,2
;
SELECT 
	product_seen,
    COUNT(DISTINCT website_session_id) AS totalsessions,
    COUNT(DISTINCT CASE WHEN cart_md = 1 THEN website_session_id ELSE NULL END) AS to_cart_sessions,
    COUNT(DISTINCT CASE WHEN shipping_md = 1 THEN website_session_id ELSE NULL END) AS to_shipping_sessions,
    COUNT(DISTINCT CASE WHEN billing_md = 1 THEN website_session_id ELSE NULL END) AS to_billing_sessions,
    COUNT(DISTINCT CASE WHEN thankyou_md = 1 THEN website_session_id ELSE NULL END) AS to_thankyou_sessions
FROM sessions_w_diff_page
GROUP BY product_seen
;
SELECT 
	product_seen,
    COUNT(DISTINCT CASE WHEN cart_md = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS to_cart_sessions,
    COUNT(DISTINCT CASE WHEN shipping_md = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart_md = 1 THEN website_session_id ELSE NULL END) AS to_shipping_sessions,
    COUNT(DISTINCT CASE WHEN billing_md = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_md = 1 THEN website_session_id ELSE NULL END) AS to_billing_sessions,
    COUNT(DISTINCT CASE WHEN thankyou_md = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing_md = 1 THEN website_session_id ELSE NULL END) AS to_thankyou_sessions
FROM sessions_w_diff_page
GROUP BY product_seen
;

