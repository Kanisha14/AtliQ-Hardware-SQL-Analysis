--  Create table fact_act_est
drop table if exists fact_act_est;
create table fact_act_est
(
	select  s.date as date,
			s.fiscal_year as fiscal_year,
			s.product_code as product_code,
			s.customer_code as customer_code,
			s.sold_quantity as sold_quantity,
			f.forecast_quantity as forecast_quantity
	from fact_sales_monthly s
	left join fact_forecast_monthly f 
	using (date, customer_code, product_code)
union
	select  f.date as date,
			f.fiscal_year as fiscal_year,
			f.product_code as product_code,
			f.customer_code as customer_code,
			s.sold_quantity as sold_quantity,
			f.forecast_quantity as forecast_quantity
	from fact_forecast_monthly  f
	left join fact_sales_monthly s 
	using (date, customer_code, product_code)
);


update fact_act_est
set sold_quantity = 0
where sold_quantity is null;

update fact_act_est
set forecast_quantity = 0
where forecast_quantity is null;

with forecast_err_table_2020 as (
		 select
			  s.customer_code as customer_code,
			  c.customer as customer_name,
			  c.market as market,
			  sum(s.forecast_quantity-s.sold_quantity) as net_error,
			  round(sum(s.forecast_quantity-s.sold_quantity)*100/sum(s.forecast_quantity),1) as net_error_pct,
			  sum(abs(s.forecast_quantity-s.sold_quantity)) as abs_error,
			  round(sum(abs(s.forecast_quantity-sold_quantity))*100/sum(s.forecast_quantity),2) as abs_error_pct
		 from fact_act_est s
		 join dim_customer c
		 on s.customer_code = c.customer_code
		 where s.fiscal_year=2020
		 group by customer_code),
     forecast_err_table_2021 as 
		(select s.customer_code as customer_code,
			  c.customer as customer_name,
			  c.market as market,
			  sum(s.forecast_quantity-s.sold_quantity) as net_error,
			  round(sum(s.forecast_quantity-s.sold_quantity)*100/sum(s.forecast_quantity),1) as net_error_pct,
			  sum(abs(s.forecast_quantity-s.sold_quantity)) as abs_error,
			  round(sum(abs(s.forecast_quantity-sold_quantity))*100/sum(s.forecast_quantity),2) as abs_error_pct
		 from fact_act_est s
		 join dim_customer c
		 on s.customer_code = c.customer_code
		 where s.fiscal_year=2021
		 group by customer_code)
select f20.customer_code, f20.customer_name, f20.market, 
	if (f20.abs_error_pct > 100, 0, 100.0 - f20.abs_error_pct) as forecast_accuracy_2020,
	if (f21.abs_error_pct > 100, 0, 100.0 - f21.abs_error_pct) as forecast_accuracy_2021
from forecast_err_table_2020 f20
join forecast_err_table_2021 f21 using(customer_code)
order by forecast_accuracy_2021 desc;

Error Code: 1064. You have an error in your SQL syntax; 
check the manual that corresponds to your MySQL server 
version for the right syntax to use near 
'if (f21.abs_error_pct > 100, 0, 100.0 - f21.abs_error_pct) 
as forecast_accuracy_' at line 30




