{{ config(
    materialized='table'
) }}


WITH agg__all AS (
    SELECT
        country,
        order_type,
        drivers_of_satisfaction_x1,
        SUM(net_satisfaction_percentage_y1) AS satisfaction_percentage,
        SUM(net_satisfaction_percentage_y1) AS satisfaction_percentage_max,
        SUM(net_satisfaction_percentage_y1) AS satisfaction_percentage_min,
        VARIANCE(net_satisfaction_percentage_y1) AS satisfaction_variance,
        SK_COUNTRY_PERIOD,
        QUARTERLY_PERIODS,
        RESTAURANT_BRAND,
        BOOKING_CHANNEL,
        AGE_BREAKS,
        CITY,
        RESERVATION_TYPE,
        SAMPLE_SIZE,
        'all' AS aggregation_level
    FROM
        {{ ref('mart_satisfaction_metrics') }}
    GROUP BY
        SK_COUNTRY_PERIOD,
        COUNTRY,
        QUARTERLY_PERIODS,
        RESTAURANT_BRAND,
        BOOKING_CHANNEL,
        AGE_BREAKS,
        ORDER_TYPE,
        CITY,
        RESERVATION_TYPE,
        SAMPLE_SIZE,
        DRIVERS_OF_SATISFACTION_X1
),

-- for q4
agg__country_ordertype_features AS (
    SELECT
        country,
        order_type,
        drivers_of_satisfaction_x1,
        SUM(net_satisfaction_percentage_y1) AS satisfaction_percentage,
        SUM(net_satisfaction_percentage_y1) AS satisfaction_percentage_max,
        SUM(net_satisfaction_percentage_y1) AS satisfaction_percentage_min,
        VARIANCE(net_satisfaction_percentage_y1) AS satisfaction_variance,
        NULL AS SK_COUNTRY_PERIOD,
        NULL::DATE AS QUARTERLY_PERIODS,
        NULL AS RESTAURANT_BRAND,
        NULL AS BOOKING_CHANNEL,
        NULL AS AGE_BREAKS,
        NULL AS CITY,
        NULL AS RESERVATION_TYPE,
        NULL AS SAMPLE_SIZE,
        'country_ordertype_features' AS aggregation_level
    FROM
        {{ ref('mart_satisfaction_metrics') }}
    GROUP BY
        country,
        order_type,
        drivers_of_satisfaction_x1
),

--for q5
agg__city_bookingchannel_features AS (
    SELECT
        NULL AS country,
        NULL AS order_type,
        drivers_of_satisfaction_x1,
        SUM(net_satisfaction_percentage_y1) AS satisfaction_percentage,
        SUM(net_satisfaction_percentage_y1) AS satisfaction_percentage_max,
        SUM(net_satisfaction_percentage_y1) AS satisfaction_percentage_min,
        VARIANCE(net_satisfaction_percentage_y1) AS satisfaction_variance,
        NULL AS SK_COUNTRY_PERIOD,
        NULL::DATE AS QUARTERLY_PERIODS,
        NULL AS RESTAURANT_BRAND,
        BOOKING_CHANNEL,
        NULL AS AGE_BREAKS,
        CITY,
        NULL AS RESERVATION_TYPE,
        NULL AS SAMPLE_SIZE,
        'city_bookingchannel_features' AS aggregation_level
    FROM
        {{ ref('mart_satisfaction_metrics') }}
    GROUP BY
        city,
        booking_channel,
        drivers_of_satisfaction_x1
),

final AS (
    SELECT * FROM agg__all
    UNION
    SELECT * FROM agg__country_ordertype_features
    UNION
    SELECT * FROM agg__city_bookingchannel_features
)

SELECT * FROM final