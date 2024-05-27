with 

exchanges as (

    select * from {{ ref('stg_exchanges')}}

)

select 
    *
from exchanges