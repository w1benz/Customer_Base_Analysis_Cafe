-- LTV by restaurant chain: top 3 restaurant chains in Saransk by total
-- commission revenue generated.
WITH orders AS (
    SELECT
        analytics_events.rest_id,
        analytics_events.city_id,
        revenue * commission AS commission_revenue
    FROM rest_analytics.analytics_events
    JOIN rest_analytics.cities ON analytics_events.city_id = cities.city_id
    WHERE revenue IS NOT NULL
        AND log_date BETWEEN '2021-05-01' AND '2021-06-30'
        AND city_name = 'Saransk'
)
SELECT
    o.rest_id,
    chain AS chain_name,
    type AS kitchen_type,
    ROUND(SUM(commission_revenue)::numeric, 2) AS ltv
FROM orders AS o
JOIN rest_analytics.partners AS p
    ON o.rest_id = p.rest_id AND o.city_id = p.city_id
GROUP BY 1, 2, 3
ORDER BY ltv DESC
LIMIT 3;
