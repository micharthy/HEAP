with 

subscriptions as (

    select * from {{ ref('int_exchanges')}}

)

select 
    *
from subscriptions