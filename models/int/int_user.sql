with 

subscriptions as (

    select * from {{ ref('int_subscriptions')}}

),

exchanges as (
    select * from {{ ref('int_exchanges')}}
)

select 
    sub.user_id as user_id,
    sum(sub.renew) as nb_years_cust,
    year(min(sub.first_subscription_date)) as start_year,
    sub.referral as referral,
    --- combining data from exchanges when user is creator
    count(ex.creator_id) as nb_ex_init_creator,
    countif(ex.canceled_at != NULL) as nb_ex_cancel_creator,
    sum(ex.night_count) as nb_nights_reqst
    
from subscriptions as sub
left join exchanges as ex
ON sub.user_id = ex.host_user_id