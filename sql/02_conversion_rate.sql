-- Conversion Rate (CR): share of registered users who placed an order,
-- out of all registered users active that day, for Saransk (city_id = 6).
SELECT
    log_date,
    ROUND(
        COUNT(DISTINCT user_id) FILTER (WHERE event = 'order')
        / COUNT(DISTINCT user_id)::numeric,
        2
    ) AS cr
FROM rest_analytics.analytics_events
WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
    AND city_id = 6
GROUP BY log_date
ORDER BY log_date;
