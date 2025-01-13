-- parameters: product code, customer = croma,
--   		   region = India, FY = 2021
-- Goal: Aggregated monthly sales
-- Output: Month, Product Name, Variant, Sold Qty,
-- 		   Gross Price per item, Total Gross Price

-- customer code = 90002002

select month(Date_ADD(fs.date, INTERVAL 4 month)) AS fy_month, p.product AS product_name, 
	   p.variant AS variant, fs.sold_quantity, round(gp.gross_price,2) AS gross_price, 
       Round((gp.gross_price*fs.sold_quantity),2) AS total_gross_price
from fact_sales_monthly fs
join dim_product p using (product_code)
join fact_gross_price gp on fs.product_code=gp.product_code and 
							gp.fiscal_year = get_fiscal_year(fs.date)
where fs.customer_code = 90002002 and
	  get_fiscal_year(fs.date) =  2021;

-- parameters:  customer = croma, region = India
-- Goal: Aggregated monthly sales report
-- Output: Month, total gross sales amount

select fs.date, 
	   Round(SUM(gp.gross_price*fs.sold_quantity),2) AS total_gross_price
from fact_sales_monthly fs
join fact_gross_price gp on fs.product_code=gp.product_code and 
							gp.fiscal_year = get_fiscal_year(fs.date)
where fs.customer_code = 90002002
group by fs.date
order by fs.date;

-- parameters:  customer = croma, region = India
-- Goal: Aggregated yearly sales report
-- Output: Fiscal year, total gross sales amount

select get_fiscal_year(fs.date) AS fiscal_year, 
	   Round(SUM(gp.gross_price*fs.sold_quantity),2) AS total_gross_price
from fact_sales_monthly fs
join fact_gross_price gp on fs.product_code=gp.product_code and 
							gp.fiscal_year = get_fiscal_year(fs.date)
where fs.customer_code = 90002002
group by fiscal_year
order by fiscal_year;

-- parameters:  Gold = sold Qty> 5 million
-- Goal: Create Market Badge AS Gold, Silver
-- Output: Market, Fiscal year, Badge

select SUM(fs.sold_quantity) AS total_qty
from fact_sales_monthly fs
join dim_customer c using (customer_code)
where get_fiscal_year(fs.date) = 2021 and c.market="India"
group by c.market;

select SUM(sold_quantity) as sold_qty
	from fact_sales_monthly fs
	join dim_customer c 
	on fs.customer_code = c.customer_code
	where get_fiscal_year(fs.date) = 2020
		  and c.market = "India"   
	group by c.market;