 -- total order , total revenue , profit , margin percent , avg order values,
 -- total return order . 
 SELECT 
    COUNT(order_id) AS total_orders,
    SUM(selling_price) AS total_revenue,
    SUM(selling_price) / COUNT(order_id) AS avg_order_value,
    SUM(selling_price - cost_price) AS total_profit,

    (
        SUM(selling_price - cost_price)
        / SUM(selling_price)
    ) * 100 AS profit_margin_percent

FROM orders;
-- converstion rate 
SELECT
    COUNT(DISTINCT wp.website_session_id) AS total_website_visitors,
    COUNT(DISTINCT o.order_id) AS total_purchases,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0
        / COUNT(DISTINCT wp.website_session_id),
        2
    ) AS conversion_rate
FROM website_pageviews wp
LEFT JOIN orders o
    ON wp.website_session_id = o.website_session_id;
    
-- funnel where customer we lose on which stage
SELECT
    COUNT(DISTINCT CASE 
        WHEN pageview_url like '%home%' 
        THEN website_session_id 
    END) AS home_visit,

    COUNT(DISTINCT CASE 
        WHEN pageview_url like '%product%' 
        THEN website_session_id 
    END) AS product_visit,

    COUNT(DISTINCT CASE 
        WHEN pageview_url like '%cart%' 
        THEN website_session_id 
    END) AS cart_visit,
COUNT(DISTINCT CASE 
        WHEN pageview_url like '%billing%' 
        THEN website_session_id 
    END) AS billing_visit,
    COUNT(DISTINCT CASE 
        WHEN pageview_url like '%billing-2%' 
        THEN website_session_id 
    END) AS billingnext_visit,

    COUNT(DISTINCT CASE 
        WHEN pageview_url like '%shipping%' 
        THEN website_session_id 
    END) AS shipping_visit,

    COUNT(DISTINCT CASE 
        WHEN pageview_url like '%thank-you-for-your-order%' 
        THEN website_session_id 
    END) AS order_placed_visit

FROM website_pageviews;

    SELECT DISTINCT pageview_url
FROM website_pageviews;

SELECT
    COUNT(*) AS total_rows,
    COUNT(website_session_id) AS session_ids
FROM website_pageviews;

-- product url which compaign

    select count(wp.pageview_url) as total ,wp.pageview_url,
w.utm_campaign from website_pageviews wp
left join website_sessions w on w.website_session_id = wp.website_session_id
group by w.utm_campaign,wp.pageview_url
 order by total desc;
 
 -- funnel check 
 
 SELECT
    website_session_id,
    created_at,
    pageview_url
FROM website_pageviews
ORDER BY website_session_id, created_at;

SELECT
    count(wp.website_session_id) as total_home,
    GROUP_CONCAT(
        wp.pageview_url
        ORDER BY wp.created_at
        SEPARATOR ' --- '
    ) AS journey
FROM website_pageviews wp
WHERE (wp.pageview_url LIKE '%home%'
       or wp.pageview_url LIKE '%product%') and wp.website_session_id not in (
    SELECT website_session_id
    FROM orders
)
GROUP BY wp.website_session_id;

-- these repeat customer percent 
select count(case when is_repeat_session = 0 then 0 end) as one_session,
count(case when is_repeat_session = 1 then 1 end) as repeat_session,
round(count(case when is_repeat_session = 1 then 1 end)*100.0/count(*),2) as repeat_session_percent,
round(count(case when is_repeat_session = 0 then 0 end)*100.0/count(*),2) as one_session_percent
 from website_sessions;
 -- traficc,compaign and ads
 select utm_campaign ,utm_source,utm_content
 from website_sessions where  website_session_id in (
 select website_session_id from orders 
 ) ;
 
 SELECT 
    journey,
    COUNT(*) AS total_sessions
FROM (
    SELECT
        wp.website_session_id,
        GROUP_CONCAT(
            wp.pageview_url
            ORDER BY wp.created_at
            SEPARATOR ' → '
        ) AS journey
    FROM website_pageviews wp
    WHERE (wp.pageview_url LIKE '%home%'
           OR wp.pageview_url LIKE '%product%' or
            wp.pageview_url LIKE '%cart%' or
			wp.pageview_url LIKE '%billing%' or
            wp.pageview_url LIKE '%billing-2%' or 
            wp.pageview_url like '%shipping%')
      AND wp.website_session_id NOT IN (
        SELECT website_session_id
        FROM orders
    )
    GROUP BY wp.website_session_id
) AS journeys
GROUP BY journey;

-- droff percent and funnel
WITH funnel AS (
    SELECT
        COUNT(DISTINCT CASE WHEN pageview_url LIKE '%home%' OR pageview_url LIKE '%lander%' THEN website_session_id END) AS landing,
        COUNT(DISTINCT CASE WHEN pageview_url LIKE '%product%' OR pageview_url LIKE '%bear%' THEN website_session_id END) AS product,
        COUNT(DISTINCT CASE WHEN pageview_url LIKE '%cart%' THEN website_session_id END) AS cart,
        COUNT(DISTINCT CASE WHEN pageview_url LIKE '%shipping%' THEN website_session_id END) AS shipping,
        COUNT(DISTINCT CASE WHEN pageview_url LIKE '%billing%' THEN website_session_id END) AS billing,
        COUNT(DISTINCT CASE WHEN pageview_url LIKE '%thank-you%' THEN website_session_id END) AS orders
    FROM website_pageviews
)
SELECT
    landing,
    product,
    cart,
    shipping,
    billing,
    orders,

    ROUND((landing - product) * 100.0 / landing, 2) AS landing_to_product_dropoff,

    ROUND((product - cart) * 100.0 / product, 2) AS product_to_cart_dropoff,

    ROUND((cart - shipping) * 100.0 / cart, 2) AS cart_to_shipping_dropoff,

    ROUND((shipping - billing) * 100.0 / shipping, 2) AS shipping_to_billing_dropoff,

    ROUND((billing - orders) * 100.0 / billing, 2) AS billing_to_order_dropoff

FROM funnel;

-- timeline funnel
WITH yearly_funnel AS (
    SELECT
        year(created_at) AS year,
                month(created_at) AS month,

        COUNT(DISTINCT CASE
            WHEN pageview_url LIKE '%home%'
              OR pageview_url LIKE '%lander%'
            THEN website_session_id END) AS landing,

        COUNT(DISTINCT CASE
            WHEN pageview_url LIKE '%product%'
            THEN website_session_id END) AS product,

        COUNT(DISTINCT CASE
            WHEN pageview_url LIKE '%cart%'
            THEN website_session_id END) AS cart,

        COUNT(DISTINCT CASE
            WHEN pageview_url LIKE '%shipping%'
            THEN website_session_id END) AS shipping,

        COUNT(DISTINCT CASE
            WHEN pageview_url LIKE '%billing%'
            THEN website_session_id END) AS billing,

        COUNT(DISTINCT CASE
            WHEN pageview_url LIKE '%thank-you%'
            THEN website_session_id END) AS orders

    FROM website_pageviews
    GROUP BY YEAR(created_at),month(created_at) 
)

SELECT
    year,
    month,

    ROUND((landing - product) * 100.0 / landing, 2)
        AS landing_product_dropoff,

    ROUND((product - cart) * 100.0 / product, 2)
        AS product_cart_dropoff,

    ROUND((cart - shipping) * 100.0 / cart, 2)
        AS cart_shipping_dropoff,

    ROUND((shipping - billing) * 100.0 / shipping, 2)
        AS shipping_billing_dropoff,

    ROUND((billing - orders) * 100.0 / billing, 2)
        AS billing_order_dropoff

FROM yearly_funnel
ORDER BY year;

-- order sucessfull are return or not 
select count(*) as total_refund from order_item_refunds where order_id in
(select order_id from orders where website_session_id in 
(select website_session_id from website_pageviews where pageview_url like '%thank%'));

-- which product most sale 
select count(wp.website_session_id), p.product_name from website_pageviews wp
inner join orders o on o.website_session_id = wp.website_session_id
inner join order_items ot on ot.order_id = o.order_id
inner join products p on p.product_id = ot.product_id
where pageview_url like "%thank%" group by p.product_name;

-- refund item 
select count(wp.website_session_id), p.product_name from website_pageviews wp
inner join orders o on o.website_session_id = wp.website_session_id
inner join order_items ot on ot.order_id = o.order_id
inner join order_item_refunds rf on rf.order_item_id = ot.order_id
inner join products p on p.product_id = ot.product_id
where pageview_url like "%thank%" group by p.product_name;

-- which campaign 
select count(wp.utm_campaign),count(wp.utm_source), wp.utm_campaign,wp.utm_source from website_sessions wp where wp.website_session_id in (
select website_session_id from website_pageviews where pageview_url like '%thank%'
) group by  wp.utm_campaign,wp.utm_source;

SELECT
    ws.utm_source,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0
        / SUM(COUNT(DISTINCT o.order_id)) OVER (),
        2
    ) AS order_percentage
FROM orders o
JOIN website_sessions ws
    ON o.website_session_id = ws.website_session_id
GROUP BY ws.utm_source
ORDER BY total_orders DESC;

