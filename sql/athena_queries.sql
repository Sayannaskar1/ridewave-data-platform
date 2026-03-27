-- Standard Query 1: Which city has most rides and revenue?
-- Business use: Operations team tracks city performance daily
SELECT
    city,
    COUNT(*)                   AS total_rides,
    ROUND(SUM(fare_amount), 2) AS total_revenue
FROM ridewave_raw_YOUR_NAME.rides
WHERE fare_amount IS NOT NULL
GROUP BY city
ORDER BY total_rides DESC;





-- Standard Query 2: What is the ride status breakdown?
-- Business use: Operations monitors cancellation rates
SELECT
    ride_status,
    COUNT(*) AS count
FROM ridewave_raw_YOUR_NAME.rides
GROUP BY ride_status
ORDER BY count DESC;



-- Standard Query 3: Top 5 earners (drivers)
-- Business use: Incentive and rewards programme
SELECT
    driver_id,
    COUNT(*)                   AS total_rides,
    ROUND(SUM(fare_amount), 2) AS total_earned
FROM ridewave_raw_YOUR_NAME.rides
WHERE fare_amount IS NOT NULL
GROUP BY driver_id
ORDER BY total_earned DESC
LIMIT 5;


-- S1a: RANK drivers by fare within each city
-- Business use: City-level leaderboard for driver rewards
SELECT
    driver_id,
    city,
    ROUND(SUM(fare_amount), 2) AS total_fare,
    RANK() OVER (
        PARTITION BY city
        ORDER BY SUM(fare_amount) DESC
    ) AS city_rank
FROM ridewave_raw_YOUR_NAME.rides
WHERE fare_amount IS NOT NULL
GROUP BY driver_id, city;




-- S1b: Month-over-month ride count using LAG
-- Business use: Growth tracking — are we growing month on month?
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', CAST(ride_date AS DATE)) AS month,
        COUNT(*) AS ride_count
    FROM ridewave_raw_YOUR_NAME.rides
    GROUP BY 1
)
SELECT
    month,
    ride_count,
    LAG(ride_count) OVER (ORDER BY month) AS prev_month_count,
    ride_count - LAG(ride_count)
        OVER (ORDER BY month)              AS change
FROM monthly
ORDER BY month;
