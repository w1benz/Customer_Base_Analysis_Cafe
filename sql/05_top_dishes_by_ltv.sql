-- Top 5 dishes by LTV among the two restaurant chains with the highest
-- overall LTV in Saransk.
WITH orders AS (
    SELECT
        a.rest_id,
        a.city_id,
        a.object_id,
        revenue * commission AS commission_revenue
    FROM rest_analytics.analytics_events AS a
    JOIN rest_analytics.cities AS c ON a.city_id = c.city_id
    WHERE revenue IS NOT NULL
        AND log_date BETWEEN '2021-05-01' AND '2021-06-30'
        AND city_name = 'Saransk'
),
top_ltv_restaurants AS (
    SELECT
        o.rest_id,
        chain,
        type,
        ROUND(SUM(commission_revenue)::numeric, 2) AS ltv
    FROM orders AS o
    JOIN rest_analytics.partners AS p
        ON o.rest_id = p.rest_id AND o.city_id = p.city_id
    GROUP BY 1, 2, 3
    ORDER BY ltv DESC
    LIMIT 2
)
SELECT
    t.chain AS chain_name,
    d.name AS dish_name,
    CASE WHEN d.spicy = 1 THEN 1 ELSE 0 END AS spicy,
    CASE WHEN d.fish = 1 THEN 1 ELSE 0 END AS fish,
    CASE WHEN d.meat = 1 THEN 1 ELSE 0 END AS meat,
    ROUND(SUM(o.commission_revenue)::numeric, 2) AS ltv
FROM top_ltv_restaurants AS t
JOIN orders AS o ON t.rest_id = o.rest_id
JOIN rest_analytics.dishes AS d ON o.rest_id = d.rest_id AND o.object_id = d.object_id
GROUP BY 1, 2, 3, 4, 5
ORDER BY ltv DESC
LIMIT 5;
