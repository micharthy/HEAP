with 

source as (

    select * from {{ source('source', 'subscriptions') }}

),

dropped as (

    select
        subscription_date,
        user_id,
        renew,
        first_subscription_date,
        first_subscription,
        referral,
        promotion,
        payment3x,
        payment2,
        payment3,
        country,
        region,
        department,
        city

    from source

),

renamed as (

    select
        subscription_date,
        user_id,
        renew,
        first_subscription_date,
        first_subscription,
        referral,
        promotion,
        payment3x,
        payment2,
        payment3,
        country,
        region,
        department,
        city

    from dropped

)

select * from renamed
