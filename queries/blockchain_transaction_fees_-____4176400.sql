-- part of a query repo
-- query name: Blockchain Transaction Fees - Average Table
-- query link: https://dune.com/queries/4176400


with totals as (
select 
blockchain,
    avg((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '1' day) AND block_time < date_trunc('day', current_timestamp) THEN tx_fee_usd END)) 
    AS day1_avg_fee_usd,
     avg((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '2' day) AND block_time < date_trunc('day', current_timestamp - interval '1' day) THEN tx_fee_usd end)) 
     AS day1_before_avg_fee_usd,
   avg((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '7' day) AND block_time < date_trunc('day', current_timestamp) THEN tx_fee_usd END)) 
    AS day7_avg_fee_usd,
     avg((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '14' day) AND block_time < date_trunc('day', current_timestamp - interval '7' day) THEN tx_fee_usd end)) 
     AS day7_before_avg_fee_usd,
 avg((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '30' day) AND block_time < date_trunc('day', current_timestamp) THEN tx_fee_usd END)) 
    AS day30_avg_fee_usd,
     avg((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '60' day) AND block_time < date_trunc('day', current_timestamp - interval '30' day) THEN tx_fee_usd end)) 
     AS day30_before_avg_fee_usd
from gas.fees 
group by 1) 

select 
blockchain,
day1_avg_fee_usd,
day1_before_avg_fee_usd,
((day1_avg_fee_usd-day1_before_avg_fee_usd)/day1_before_avg_fee_usd) as day1_avg_fee_usd_perc ,
day7_avg_fee_usd,
day7_before_avg_fee_usd,
((day7_avg_fee_usd-day7_before_avg_fee_usd)/day7_before_avg_fee_usd) as day7_avg_fee_usd_perc, 
day30_avg_fee_usd,
day30_before_avg_fee_usd,
((day30_avg_fee_usd-day30_before_avg_fee_usd)/day30_before_avg_fee_usd) as day30_avg_fee_usd_perc
from totals
order by day1_avg_fee_usd asc