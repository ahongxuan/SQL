Use mavenfuzzyfactory;

CREATE TEMPORARY TABLE sessions_seen_cart
SELECT 
	website_pageview_id,
	website_session_id,
	CASE
		WHEN created_at < '2013-09-25' THEN 'A.Pre_Cross_Sell'
        WHEN created_at >= '2013-09-25' THEN 'B.Post_Cross_Sell'
	ELSE 'need to check'
    END AS time_period
FROM website_pageviews
WHERE created_at BETWEEN '2013-08-25' AND '2013-10-25'
	AND pageview_url = '/cart'
;

CREATE TEMPORARY TABLE after_sessions_seen_cart
SELECT
	sc.website_session_id,
    sc.time_period,
    MIN(wp.website_pageview_id) AS min_pv_after_cart
FROM sessions_seen_cart sc
LEFT JOIN website_pageviews wp
	ON sc.website_session_id = wp.website_session_id
    AND wp.website_pageview_id > sc.website_pageview_id
GROUP BY 1,2
HAVING min_pv_after_cart IS NOT NULL
;

CREATE TEMPORARY TABLE cart_have_orders

SELECT 
	sc.website_session_id,
	time_period,
	order_id,
    items_purchased,
    price_usd
FROM sessions_seen_cart sc
INNER JOIN orders o
	ON sc.website_session_id = o.website_session_id
;

-- emportant
SELECT 
	sc.time_period,
    sc.website_session_id,
    CASE WHEN ac.website_session_id IS NULL THEN 0 ELSE 1 END AS click_to_next_page,
    CASE WHEN co.order_id IS NULL THEN 0 ELSE 1 END AS place_order,
    co.items_purchased,
    co.price_usd
FROM sessions_seen_cart sc
	LEFT JOIN after_sessions_seen_cart ac
		USING(website_session_id)
	LEFT JOIN cart_have_orders co
		USING(website_session_id)
ORder BY website_session_id
;


SELECT 
	time_period,
    COUNT(DISTINCT website_session_id)AS cart_sessions,
    SUM(click_to_next_page) AS click_next,
    SUM(click_to_next_page)/COUNT(website_session_id) AS cart_next_ctr,
    SUM(place_order) AS order_placed,
    SUM(items_purchased) AS product_purchase,
    SUM(items_purchased)/SUM(place_order) AS product_per_order,
    SUM(price_usd) AS revenee,
    SUM(price_usd)/SUM(place_order) AS aov,
    SUM(price_usd)/COUNT(DISTINCT website_session_id) AS rev_per_cart
FROM (SELECT 
	sc.time_period,
    sc.website_session_id,
    CASE WHEN ac.website_session_id IS NULL THEN 0 ELSE 1 END AS click_to_next_page,
    CASE WHEN co.order_id IS NULL THEN 0 ELSE 1 END AS place_order,
    co.items_purchased,
    co.price_usd
FROM sessions_seen_cart sc
	LEFT JOIN after_sessions_seen_cart ac
		USING(website_session_id)
	LEFT JOIN cart_have_orders co
		USING(website_session_id)
ORder BY website_session_id
) AS sub
GROUP BY 1
;