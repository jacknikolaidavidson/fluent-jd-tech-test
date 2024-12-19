{{ config(
    materialized='table'
) }}

SELECT
    *
FROM {{ ref('raw_restaurant_data')}}

