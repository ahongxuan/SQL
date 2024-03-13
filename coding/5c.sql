Use mavenfuzzyfactory;


CREATE temporary table product_pageview
SELECT website_session_id,
	website_pageview_id,
    created_at,
    CASE 
		WHEN created_at < '2013-01-06' THEN 'A.pre_product'
        WHEN created_at >= '2013-01-06' THEN 'B.post_product'
        ELSE 'check date'
	END AS time_period
FROM website_pageviews
WHERE created_at BETWEEN '2012-10-06' AND '2013-04-06'
	AND pageview_url = '/products'
;    

CREATE temporary table next_page_pageview
SELECT 
	pp.time_period,
	pp.website_session_id,
    MIN(wp.website_pageview_id) AS min_page
FROM product_pageview pp 
LEFT JOIN website_pageviews wp
	ON pp.website_session_id = wp.website_session_id
    AND wp.website_pageview_id > pp.website_pageview_id
GROUP BY 1,2
;  

CREATE temporary table next_page_pageview_url
SELECT 
	np.time_period,
	np.website_session_id,
    wp.pageview_url
FROM next_page_pageview np 
LEFT JOIN website_pageviews wp
	ON np.min_page = wp.website_pageview_id
;  


SELECT 
	time_period,
	COUNT(DISTINCT website_session_id) As sessions,
    COUNT(DISTINCT CASE WHEN pageview_url IS NOT NULL THEN website_session_id ELSE NULL END) As next_page_session,
    COUNT(DISTINCT CASE WHEN pageview_url IS NOT NULL THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS next_page_rate,
    COUNT(CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS to_fuzzy,
	COUNT(CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS to_fuzzy_rate,
	COUNT(CASE WHEN pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS to_lover,
	COUNT(CASE WHEN pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id)  AS to_lover_rate

FROM next_page_pageview_url 
GROUP BY 1
;