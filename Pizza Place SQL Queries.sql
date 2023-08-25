--Question 1
--How many Customers are there in each day

select 
	*
from PortfolioProject..orders

-- How many Customers each day
select 
	date 
	,count(date) as NumberofOrders
from PortfolioProject..orders
group by date
order by date

-- Separating the Hour part from the time stamp
select  
	time
	, DATEPART(hour, time) as Hour
from PortfolioProject..orders

--Adding the hour row into the table
Alter Table orders
Add Hours int;

Update orders
set Hours = DATEPART(hour, time)

-- Calculating the number of orders pleced in each hour 

select 
	distinct(hours)
	,COUNT(hours) as NumberofOrders
from PortfolioProject..orders
group by hours
order by hours



/* 
Question 2
How many Pizzas are typically in an order?
*/


select 
	*
from PortfolioProject..OrderDetails


--Average Number of Pizzas in an order

select 
	count(order_details_id) /  COUNT(distinct order_id) 
from PortfolioProject..OrderDetails



--What is the best seller pizza

select 
	pizza_id
	,COUNT(pizza_id) as QuantityOrdered
from PortfolioProject..OrderDetails
group by pizza_id 
order by 2 desc

--Most profiting best sellers of the year
select 
	OrderDetails.pizza_id
	,SUM(price) AS AnnualRevenue
from PortfolioProject..OrderDetails 
JOIN PortfolioProject..Pizzas 
	ON OrderDetails.pizza_id = Pizzas.pizza_id
Group by OrderDetails.pizza_id
order by 2 desc


/*
Question 3
What is the Annuual sale?
*/
select 
	*
from PortfolioProject..Pizzas

--Annual revenue

select  
	SUM(price) AS AnnualRevenue
from PortfolioProject..OrderDetails o
JOIN PortfolioProject..Pizzas p
	ON o.pizza_id = p.pizza_id



/*
Question 4
Whixh pizzas which should be taken of the menu?
*/

select 
	pizza_id
	,COUNT(pizza_id) as QuantityOrdered
from PortfolioProject..OrderDetails
group by pizza_id 
order by 2 





