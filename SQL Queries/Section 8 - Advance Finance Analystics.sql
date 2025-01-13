-- parameters: 
-- Goal: top 3 markets by net sales
-- Output: 
select market, round(SUM(net_sales)/1000000,2) AS net_sales_mln
from net_sales
where fiscal_year = 2021
group by market
order by net_sales_mln DESC
limit 5;

-- market share by global net sales per customer
with cte1 as (
	select c.customer, round(SUM(ns.net_sales)/1000000,2) AS net_sales_mln
	from net_sales ns
    join dim_customer c using (customer_code)
	where fiscal_year = 2021
	group by c.customer)
select *, net_sales_mln*100/sum(net_sales_mln) over() as market_pct
from cte1 
order by net_sales_mln DESC;

-- market share by regional net sales per customer
with cte1 as (
	select c.customer, c.region,
		   round(SUM(ns.net_sales)/1000000,2) AS net_sales_mln
	from net_sales ns
    join dim_customer c using (customer_code)
	where fiscal_year = 2021
	group by c.customer, c.region)
select *, 
	   net_sales_mln*100/sum(net_sales_mln) over(partition by region) as pct_share_region
from cte1 
order by region, net_sales_mln DESC;

-- top products in each division by qty sold per year
with cte1 as (
		select p.division, p.product, sum(sold_quantity) AS total_qty
		from fact_sales_monthly
		join dim_product p using (product_code)
		where fiscal_year = 2021
		group by p.division, p.product),
	 cte2 as (
		select *, 
			   dense_rank() over(partition by division order by total_qty desc) AS drnk
		from cte1)
select * from cte2 where drnk <= 3;

-- top 2 markets in every region by their gross sales amount in FY=2021 
with cte1 as (		
        select c.market, c.region, round(sum(total_gross_price)/1000000,2) AS gross_sales_mln
		from gross_sales s
		join dim_customer c using (customer_code)
		where fiscal_year = 2021
		group by c.market
        order by gross_sales_mln desc),
	 cte2 as (
		select *, 
			   dense_rank() over(partition by region order by gross_sales_mln desc) AS drnk
		from cte1)
select * from cte2 where drnk <= 2;