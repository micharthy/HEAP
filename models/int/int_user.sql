with 

subscriptions as (

    select * from {{ ref('int_subscriptions')}}

),

host_exchanges as (
    select * from {{ ref('int_host_exg')}}
),

guest_exchanges as (
    select * from {{ ref('int_guest_exg')}}
)

select 

    sub.user_id as s_user_id,
    sum(sub.renew) as nb_years_cust,
    date_trunc(min(sub.first_subscription_date), YEAR) as start_year,
    max(sub.referral) as referral,

    /*--- combining data from exchanges when user is host
    count(exg_host.creator_id) as nb_exg_init,
    countif(exg_host.canceled_at IS NOT NULL) as nb_exg_host_cancel,
    countif(exg_host.canceled_at IS NOT NULL AND exg_host.user_cancellation_id = exg_host.creator_id) as nb_exg_host_self_cancel,
    sum(exg_host.night_count) as nb_nights_reqst_received,

    ---- combining data from exchanges when user is guest
    count(exg_guest.guest_user_id) as nb_exg_received,
    countif(exg_guest.canceled_at IS NOT NULL) as nb_exg_guest_cancel,
    countif(exg_guest.canceled_at IS NOT NULL AND exg_guest.user_cancellation_id = exg_guest.guest_user_id ) as nb_exg_guest_self_cancel,
    sum(exg_guest.night_count) as nb_nights_reqst_sent,*/
    
from subscriptions as sub

--- joining exchanges with user ID as host
left join host_exchanges as exg_host
on sub.user_id = exg_host.host_id

--- joining exchanges with user ID as guest
left join guest_exchanges as exg_guest
on sub.user_id = exg_guest.guest_id

group by s_user_id
