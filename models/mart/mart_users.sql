with 

subscriptions as (

    select * from {{ ref('int_user')}}

)

select 
    *
from subscriptions