with 

subscriptions as (

    select * from {{ ref('int_subscriptions')}}

)

select 
    *
from subscriptions