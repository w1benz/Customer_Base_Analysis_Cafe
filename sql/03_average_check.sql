-- Average check: average commission revenue per order (platform's own
-- revenue per transaction), calculated monthly for Saransk.
WITH orders AS (
    SELECT
        *,
        revenue * commission AS commission_revenue
    FROM rest_analytics.analytics_events
    JOIN rest_analytics.cities ON analytics_events.city_id = cities.city_id
    WHERE revenue IS NOT NULL
        AND log_date BETWEEN '2021-05-01' AND '2021-06-30'
        AND city_name = 'Saransk'
)
SELECT
    DATE_TRUNC('month', log_date)::date AS month,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(SUM(commission_revenue)::numeric, 2) AS commission_amount,
    ROUND(SUM(commission_revenue)::numeric / COUNT(DISTINCT order_id), 2) AS average_check
FROM orders
GROUP BY 1
ORDER BY 1
