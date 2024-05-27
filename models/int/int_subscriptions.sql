with 

subscriptions as (

    select * from {{ ref('stg_subscriptions')}}

)

select 
    *
from subscriptions