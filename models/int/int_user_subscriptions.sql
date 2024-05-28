with 

subscriptions as (

    select * from {{ ref('int_subscriptions')}}

)

select
    user_id as user_id,
    country as country,
    sum(renew) as nb_renewals,
    date_trunc(min(first_subscription_date), YEAR) as first_year,
    date_diff('2021-10-31', min(first_subscription_date), YEAR) as account_age,
    max(subscription_date) as latest_year,
    if(date_diff('2021-10-31', max(subscription_date), YEAR) > 0, 'CHURNED', 'ACTIVE') as account_status,
    if(max(payment3x)>0, 'INSTALLMENT', 'LUMP') as payment_type,
    max(referral) as referral 
from subscriptions
group by user_id
