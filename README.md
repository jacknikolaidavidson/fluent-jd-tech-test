# fluent-jd-tech-test
 
## Notion documentation
- https://meteor-cat-d24.notion.site/Fluent-Tech-Test-161ad99d93388070b42bcb979e535e6b

## setting up environment
virtualenv venv
source ./venv/bin/activate
pip install -r requirements.txt

replace CWD with cloned directory location
- export DBT_PROFILES_DIR=/CWD/fluent-jd-tech-test/fluent_restaurant/
<!-- export DBT_PROFILES_DIR=/Users/jackn/Documents/GitHub/fluent-jd-tech-test/fluent_restaurant/ -->

## Run dbt
- dbt debug
- dbt deps
- dbt build

## Commands to run MetricFlow queries
### 1.
mf query \
--metrics satisfaction_percentage \
--group-by sk_country_period__restaurant_brand,sk_country_period__drivers_of_satisfaction_x1 \
--where "{{ Dimension('sk_country_period__restaurant_brand') }} = 'KFC' or {{ Dimension('sk_country_period__restaurant_brand') }} like 'McDonald%' and {{ Dimension('sk_country_period__aggregation_level') }} = 'all'" \
--order sk_country_period__restaurant_brand,-satisfaction_percentage

### 2.
mf query \
--metrics satisfaction_percentage \
--group-by sk_country_period__booking_channel,sk_country_period__country,sk_country_period__drivers_of_satisfaction_x1 \
--where "{{ Dimension('sk_country_period__booking_channel') }} IN ('UberEats', 'JustEat') and {{ Dimension('sk_country_period__country') }} = 'IT' and {{ Dimension('sk_country_period__aggregation_level') }} = 'all'" \
--order sk_country_period__booking_channel,-satisfaction_percentage

### 3.
-- query for 18-65
mf query \
--metrics satisfaction_percentage \
--group-by sk_country_period__age_breaks,sk_country_period__country,sk_country_period__drivers_of_satisfaction_x1 \
--where "{{ Dimension('sk_country_period__age_breaks') }} IN ('18-24') and sk_country_period__country = 'US' and {{ Dimension('sk_country_period__aggregation_level') }} = 'all'" \
--order sk_country_period__age_breaks,-satisfaction_percentage \
--limit 3

-- query for 65+
mf query \
--metrics satisfaction_percentage \
--group-by sk_country_period__age_breaks,sk_country_period__country,sk_country_period__drivers_of_satisfaction_x1 \
--where "{{ Dimension('sk_country_period__age_breaks') }} IN ('65+') and sk_country_period__country = 'US' and {{ Dimension('sk_country_period__aggregation_level') }} = 'all'" \
--order sk_country_period__age_breaks,-satisfaction_percentage \
--limit 3

### 4.
“Among Eat In versus Delivery orders in the UK, which features stand out as having significantly different net satisfaction scores?”

mf query \
--metrics net_satisfaction_diff \
--group-by sk_country_period__drivers_of_satisfaction_x1 \
--where "{{ Dimension('sk_country_period__order_type') }} IN ('Eat In','Delivery') and {{ Dimension('sk_country_period__country') }} = 'UK' and {{ Dimension('sk_country_period__aggregation_level') }} = 'country_ordertype_features'" \
--order -net_satisfaction_diff 

### 5.
“Which satisfaction drivers vary the most across different cities (e.g., Madrid vs. Berlin) when looking at customers who booked through OpenTable?”

mf query \
--metrics net_satisfaction_diff \
--group-by sk_country_period__drivers_of_satisfaction_x1 \
--where "{{ Dimension('sk_country_period__city') }} IN ('Madrid','Berlin') and {{ Dimension('sk_country_period__booking_channel') }} = 'OpenTable' and {{ Dimension('sk_country_period__aggregation_level') }} = 'city_bookingchannel_features'" \
--order -net_satisfaction_diff 

### 6.
mf query \
--metrics satisfaction_percentage \
--group-by sk_country_period__drivers_of_satisfaction_x1,sk_country_period__restaurant_brand,sk_country_period__country,sk_country_period__age_breaks \
--where "sk_country_period__drivers_of_satisfaction_x1 IN ('Reservation System', 'Customer Service') and sk_country_period__country = 'DE' and sk_country_period__age_breaks = '35-45' and {{ Dimension('sk_country_period__aggregation_level') }} = 'all'" \
--order -satisfaction_percentage,sk_country_period__restaurant_brand,sk_country_period__drivers_of_satisfaction_x1
