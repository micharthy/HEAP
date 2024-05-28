with 

exchanges as (

    select * from {{ ref('stg_exchanges')}}

),

--- filtering out exchanges where the creator is the not the guest as this would only be the case for reciprocal exchanges (where multiple rows are created for 1 exchange)
stripped as (
    
    select *
    from exchanges
    where creator_id = guest_user_id

)

select 
    *,
    case 
        when finalized_at is null then 'FAIL' --- meaning the exchange failed, the host refused the exchange
        when finalized_at is not null then 'SUCCESS' --- meaning the exchange was successfull 
        else 'unknown'
    end as exg_status
from stripped