with 

exchanges as (

    select * from {{ ref('int_exchanges')}}

),

--- filtering out exchanges where the creator is the not the guest as this would only be the case for reciprocal exchanges (where multiple rows are created for 1 exchange)
guest_creator as (
    
    select *
    from exchanges
    where creator_id = guest_user_id

)


select
  distinct(guest_user_id) as guest_id,
  min(created_at) as first_guest_reqst,
  max(created_at) as last_guest_reqst,
  count(*) as nb_reqst,
  sum(night_count) as nb_nights_reqst,
  CAST(round(avg(night_count),0) AS INT) as avg_night_count,
  countif(exg_status = 'SUCCESS') as nb_success_exg,
  sum(if(exg_status = 'SUCCESS', night_count, 0)) as sum_nights_success_reqst,
  countif(exg_status = 'FAIL') as nb_failed_exg,
  countif(exchange_type = 'NON_RECIPROCAL') as nb_non_reciprocal_exg,
  countif(exchange_type = 'RECIPROCAL') as nb_reciprocal_exg,
  min(capacity) as min_capacity,
  max(capacity) as max_capacity,
  CAST(round(avg(capacity),0) AS INT) as avg_capactiy,
  count(distinct country) as nb_countries,
  count(distinct city) as nb_cities
from guest_creator
group by guest_id