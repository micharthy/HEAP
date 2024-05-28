with 

exchanges as (

    select * from {{ ref('stg_exchanges')}}

)


select
  distinct(guest_user_id) as guest_id,
  count(*) as nb_reqst,
  min(created_at) as first_reqst,
  max(created_at) as last_reqst,
  sum(night_count) as nb_nights_reqst,
  avg(night_count) as avg_night_count,
  countif(finalized_at IS NULL) as nb_exg_not_finalized,
  countif(finalized_at IS NOT NULL AND canceled_at IS NULL) as nb_exg_finalized_not_cancelled,
  countif(finalized_at IS NOT NULL AND canceled_at IS NOT NULL) as nb_exg_finalized_cancelled,
  countif(exchange_type = 'NON_RECIPROCAL') as nb_non_reciprocal_exg,
  countif(exchange_type = 'RECIPROCAL') as nb_reciprocal_exg,
  min(capacity) as min_capacity,
  max(capacity) as max_capacity,
  avg(capacity) as avg_capactiy,
  countif(distinct city IS NOT NULL) as nb_cities
from exchanges
group by guest_id