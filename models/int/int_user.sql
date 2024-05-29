with 

subscriptions as (

    select * from {{ ref('int_user_subscriptions')}}

),

host_exchanges as (
    select * from {{ ref('int_host_exg')}}
),

guest_exchanges as (
    select * from {{ ref('int_guest_exg')}}
)

select 

    sub.user_id as user_id,
    sub.country as country,
    sub.nb_renewals as nb_renewals,
    date_trunc(sub.first_year, YEAR) as start_year,
    sub.latest_year as latest_year,
    sub.account_age as account_age_years,
    sub.account_status as account_status,
    sub.payment_type as payment_type,
    sub.referral as referral,

    --- combining data from exchanges when user is host
    exg_host.nb_reqst as host_nb_exg,
    exg_host.nb_nights_reqst as host_nb_nights,
    exg_host.nb_success_exg as host_nb_success_exg,
    exg_host.nb_failed_exg as host_nb_failed_exg,

    ---- combining data from exchanges when user is guest
    exg_guest.nb_reqst as guest_nb_exg,
    exg_guest.nb_nights_reqst as guest_nb_nights,
    exg_guest.nb_success_exg as guest_nb_success_exg,
    exg_guest.nb_failed_exg as guest_nb_failed_exg,

    ---- classifying user based on activity as a host &/or as a guest
    case 
        when exg_host.nb_reqst > 0 AND exg_guest.nb_reqst > 0 then 'MIXED'
        when exg_host.nb_reqst > 0 THEN 'HOST'
        when exg_guest.nb_reqst > 0 THEN 'GUEST'
        else 'problem with rqst classifying'
    end as intent_type,

    case 
        when exg_host.nb_success_exg > 0 AND exg_guest.nb_success_exg > 0 then 'MIXED'
        when exg_host.nb_success_exg > 0 THEN 'HOST'
        when exg_guest.nb_success_exg > 0 THEN 'GUEST'
        else 'problem with success rqst classifying'
    end as actual_type


    
from subscriptions as sub

--- joining exchanges with user ID as host
left join host_exchanges as exg_host
on sub.user_id = exg_host.host_id

--- joining exchanges with user ID as guest
left join guest_exchanges as exg_guest
on sub.user_id = exg_guest.guest_id

