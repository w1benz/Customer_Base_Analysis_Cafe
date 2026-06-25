-- Weekly Retention Rate, split into two cohorts by the month of first
-- visit (May vs. June), for new users in Saransk.
WITH new_users AS (
    SELECT DISTINCT first_date, user_id
    FROM rest_analytics.analytics_events
    JOIN rest_analytics.cities ON analytics_events.city_id = cities.city_id
    WHERE first_date BETWEEN '2021-05-01' AND '2021-06-24'
        AND city_name = 'Saransk'
),
active_users AS (
    SELECT DISTINCT log_date, user_id
    FROM rest_analytics.analytics_events
    JOIN rest_analytics.cities ON analytics_events.city_id = cities.city_id
    WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
        AND city_name = 'Saransk'
),
daily_retention AS (
    SELECT
        new_users.user_id,
        first_date,
        log_date::date - first_date::date AS day_since_install
    FROM new_users
    JOIN active_users ON new_users.user_id = active_users.user_id
        AND log_date >= first_date
)
SELECT
    DATE_TRUNC('month', first_date)::date AS month,
    day_since_install,
    COUNT(DISTINCT user_id) AS retained_users,
    ROUND(
        1.0 * COUNT(DISTINCT user_id)
        / MAX(COUNT(DISTINCT user_id)) OVER (
            PARTITION BY DATE_TRUNC('month', first_date)::date
            ORDER BY day_since_install
        ),
        2
    ) AS retention_rate
FROM daily_retention
WHERE day_since_install < 8
GROUP BY month, day_since_install
ORDER BY month, day_since_install;
