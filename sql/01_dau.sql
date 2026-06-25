-- DAU (Daily Active Users): number of unique registered users who placed
-- an order on a given day, for the city of Saransk (city_id = 6).
SELECT
    log_date,
    COUNT(DISTINCT user_id) AS dau
FROM rest_analytics.analytics_events AS a
JOIN rest_analytics.cities AS c ON c.city_id = a.city_id
WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
    AND c.city_id = 6
    AND event = 'order'
GROUP BY log_date
ORDER BY log_date;
