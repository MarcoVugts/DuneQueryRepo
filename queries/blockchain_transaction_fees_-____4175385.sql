-- part of a query repo
-- query name: Blockchain Transaction Fees - Time Frame
-- query link: https://dune.com/queries/4175385


select date_trunc('{{aggregation}}',block_time) as time, 
blockchain,
approx_percentile((tx_fee_usd), 0.5) as median_fee_usd, 
avg(tx_fee_usd) as avg_fee_usd, 
sum(tx_fee_usd) as total_fee_usd
from gas.fees
where block_time >= date_trunc('day',NOW() - interval '{{interval_days}}' day)
group by 1,2
order by 5 desc, 1 desc