{{ config(
    materialized='table'
) }}


SELECT
    MD5 ( concat (COUNTRY, QUARTERLY_PERIODS) ) AS SK_COUNTRY_PERIOD,
    UNIQUE_ID,
    COUNTRY,
    QUARTERLY_PERIODS,
    FEATURE,
    BOOKING_CHANNEL,
    AGE_BREAKS,
    WEIGHT_PER_PERSON,
    SATISFACTION_WEIGHT,
    DISSATISFACTION_WEIGHT,
    ORDER_TYPE,
    CITY,
    RESERVATION_TYPE,
    CASE 
        WHEN SATISFACTION_WEIGHT > 0 THEN 'Satisfaction' 
        ELSE 'Dissatisfaction' 
    END AS METRIC_TYPE,
    RESTAURANT_BRAND

FROM {{ ref('stg_restaurant_data')}}
