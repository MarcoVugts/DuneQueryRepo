-- part of a query repo
-- query name: Blockchain Transaction Fees - Median Table
-- query link: https://dune.com/queries/4175533


with totals as (
select 
blockchain,
    approx_percentile((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '1' day) AND block_time < date_trunc('day', current_timestamp) THEN tx_fee_usd END), 0.5) 
    AS day1_median_fee_usd,
     approx_percentile((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '2' day) AND block_time < date_trunc('day', current_timestamp - interval '1' day) THEN tx_fee_usd end), 0.5) 
     AS day1_before_median_fee_usd,
   approx_percentile((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '7' day) AND block_time < date_trunc('day', current_timestamp) THEN tx_fee_usd END), 0.5) 
    AS day7_median_fee_usd,
     approx_percentile((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '14' day) AND block_time < date_trunc('day', current_timestamp - interval '7' day) THEN tx_fee_usd end), 0.5) 
     AS day7_before_median_fee_usd,
 approx_percentile((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '30' day) AND block_time < date_trunc('day', current_timestamp) THEN tx_fee_usd END), 0.5) 
    AS day30_median_fee_usd,
     approx_percentile((CASE WHEN block_time >= date_trunc('day', current_timestamp - interval '60' day) AND block_time < date_trunc('day', current_timestamp - interval '30' day) THEN tx_fee_usd end), 0.5) 
     AS day30_before_median_fee_usd,
avg(tx_fee_usd) as avg_fee_usd, 
approx_percentile((tx_fee_usd), 0.5) as median_fee_usd, 
sum(tx_fee_usd) as total_fee_usd
from gas.fees 
group by 1) 

select 
blockchain,
day1_median_fee_usd,
day1_before_median_fee_usd,
((day1_median_fee_usd-day1_before_median_fee_usd)/day1_before_median_fee_usd) as day1_median_fee_usd_perc ,
day7_median_fee_usd,
day7_before_median_fee_usd,
((day7_median_fee_usd-day7_before_median_fee_usd)/day7_before_median_fee_usd) as day7_median_fee_usd_perc, 
day30_median_fee_usd,
day30_before_median_fee_usd,
((day30_median_fee_usd-day30_before_median_fee_usd)/day30_before_median_fee_usd) as day30_median_fee_usd_perc
from totals
order by day1_median_fee_usd asc