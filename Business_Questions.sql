-- Using DataBase 
USE BikeStores;
-- We Have two schema production and sales
-- production schema contains information about products , brands and categories
-- sales schema contains information about customers , staffs and stores
--------------------------------------------------------
--Explore Data
SELECT * FROM production.categories;
SELECT * FROM production.brands;
SELECT * FROM production.products;
--SELECT * FROM production.stocks;

SELECT * FROM sales.customers;
SELECT * FROM sales.orders;
SELECT * FROM sales.staffs;
 SELECT * FROM sales.stores;
SELECT * FROM sales.order_items
WHERE product_id=259
---------------------------------------------------------
--Questions and Their Answers
-- 1- Which bike is most expensive? What could be the motive behind pricing this bike at the high price?
select product_name , MAX(list_price) max_price from production.products
GROUP by product_name
ORDER BY MAX(list_price) DESC
--Answer : Trek Domane SLR 9 Disc -2018 , price  is 11999.99
-- I Think because it is the most expensive bike and  people want to buy it and its has  high quality
-- and its brand is Trek 
--------------------------------------------------------
--2-How many total customers does BikeStore have? Would you consider people with order status 3 as customers substantiate your answer?
SELECT count( customer_id) total_customers from sales.customers
--Answer : total customers is 1445
--Maybe the product you ordered is not available,
-- or the address was entered incorrectly, or they were not contacted correctly, 
-- or maybe the phone is off,and there are many other reasonsو
-- so they are considered customers.
--------------------------------------------------------
-- 3- How many stores does BikeStore have?
select count (store_id) total_stores from sales.stores
-- Answer : total stores is 3
--------------------------------------------------------
--4 What is the total price spent per order?
-- Hint: total price = [list_price] *[quantity]*(1-[discount])
select order_id , sum(list_price*quantity*(1-discount)) total_price from sales.order_items
GROUP by order_id
ORDER BY order_id 
--------------------------------------------------------
--5- What’s the sales/revenue per store?
-- Hint: Sales revenue = ([list_price] *[quantity]*(1-[discount]))
select store_id , sum (list_price*quantity*(1-discount)) sales_revenue 
from sales.order_items INNER JOIN sales.orders
ON sales.order_items.order_id = sales.orders.order_id and sales.orders.order_status = 4 -- status = 4 is completed
GROUP by store_id
ORDER BY sales_revenue DESC
-- Answer : Store 2 has the highest sales revenue , 
-- Store 1 has the second highest sales revenue
-- Store 3 has the lowest sales revenue
--------------------------------------------------------
-- 6) Which category is most sold?
select category_name , sum (sales.order_items.list_price*quantity*(1-discount)) total_sold from production.categories inner join production.products
on production.categories.category_id = production.products.category_id
INNER JOIN sales.order_items  ON sales.order_items.product_id = production.products.product_id
INNER JOIN sales.orders ON sales.orders.order_id = sales.order_items.order_id 
and sales.orders.order_status = 4
GROUP by category_name
order by total_sold DESC
-- Answer : Mountain Bikes is the most sold category
-- note : we used order_status = 4 because the order status = 3 is canceled
---------------------------------------------------------------------------
--7-Which category rejected more orders?
select categories.category_name , count(sales.orders.order_status) from production.categories inner JOIN 
production.products on  production.categories.category_id = production.products.category_id  inner JOIN
sales.order_items on production.products.product_id = sales.order_items.product_id INNER JOIN
sales.orders on sales.orders.order_id = sales.order_items.order_id and sales.orders.order_status = 3
GROUP by categories.category_name
ORDER BY count(sales.orders.order_status) DESC
-- Answer : Cruisers Bicycles is the category rejected more orders
---------------------------------------------------------------------------
--8-  Which bike is the least sold?
select product_name , sum(sales.order_items.quantity) total_quantity 
from production.products INNER JOIN sales.order_items
on production.products.product_id = sales.order_items.product_id
GROUP by rollup( product_name)
ORDER BY  sum(sales.order_items.quantity) ASC
-- Answer : Electra Amsterdam Royal 8i - 2017/2018
-- Electra Cruiser 7D - 2016/2017/2018
-- Electra Cruiser 1 Tall - 2016/2018
-- Electra Soft Serve 1 (16-inch) - Girl's - 2018
-- Electra Straight 8 1 (16-inch) - Boy's - 2018
-- Electra Straight 8 1 (20-inch) - Boy's - 2018
-- Electra Tiger Shark 3i (20-inch) - Boys' - 2018
-- Electra Superbolt 3i 20" - 2018
-- Electra Treasure 3i 20" - 2018
-- Surly ECR Frameset - 2018
-- Trek CrossRip 2 - 2018
-- Trek Domane ALR 3 - 2018
-- Trek Domane SL 5 Women's - 2018
-- Trek Domane SL Frameset Women's - 2018
-- Trek Domane SLR Disc Frameset - 2018
-- Trek Madone 9 Frameset - 2018
-- Trek Powerfly 5 - 2018
-- Trek Powerfly 5 FS - 2018
-- Trek MT 201 - 2018
-- Trek Precaliber 16 Boy's - 2018
-- Trek Precaliber 20 6-speed Girl's - 2018
-- Trek Precaliber 24 7-speed Girl's - 2018
-- Trek Superfly 20 - 2018
-- Trek Superfly 24 - 2017/2018
---------------------------------------------------------------------------
--9-  What’s the full name of a customer with ID 259?
select CONCAT(first_name, ' ' , last_name) name_of_customer_259 
from sales.customers where customer_id = 259
-- Answer :Johnathan Velazquez
---------------------------------------------------------------------------
--10  What did the customer on question 9 buy and when? What’s the status of this order?
select product_name,sales.order_items.product_id, sales.order_items.order_id , order_status , order_date from sales.orders
inner join sales.order_items on sales.orders.order_id = sales.order_items.order_id
INNER join production.products on sales.order_items.product_id = production.products.product_id
where customer_id = 259
-- Answer : Electra Townie Original 7D EQ - Women's - 2016
-- Trek Remedy 29 Carbon Frameset - 2016
-- Surly Straggler - 2016
-- Electra Townie Original 7D EQ - 2016
-- Trek Fuel EX 8 29 - 2016
---------------------------------------------------------------------------
--11 - Which staff processed the order of customer 259? And from which store?
select CONCAT(first_name, ' ' , last_name) name_of_staff , store_name from sales.staffs inner join sales.orders on sales.staffs.staff_id = sales.orders.staff_id
inner join sales.stores on sales.orders.store_id = sales.stores.store_id
WHere sales.orders.customer_id = 259
-- Answer :Mireya Copeland , Santa Cruz Bikes Store
---------------------------------------------------------------------------
--12) How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore?
select count(staff_id) total_staff from sales.staffs
select CONCAT(first_name, ' ' , last_name) name_of_staff , staff_id from sales.staffs
ORDER BY staff_id
-- Answer : total staff is 10
-- Select Staff managers
select CONCAT(first_name, ' ' , last_name) name_of_staff , staff_id from sales.staffs
where manager_id is not null and 
manager_id in (select staff_id from sales.staffs)
---------------------------------------------------------------------------
--13 - Which brand is the most liked ? (what is number of product quantity sold for each brand)
select brand_name ,sum (quantity) from production.brands inner join 
production.products on production.products.brand_id = production.brands.brand_id
INNER join sales.order_items 
on sales.order_items.product_id = production.products.product_id
GROUP by brand_name
ORDER BY sum(quantity) DESC
-- Answer : Electra is the most liked brand
---------------------------------------------------------------------------
--14- How many categories does BikeStore have, and which one is the least liked?

select (category_name) 'total_categories'from production.categories
-- Answer : total categories is 7
select  category_name  , sum (quantity) '#of_products' from production.categories INNER join 
production.products on production.products.category_id = production.categories.category_id
inner join sales.order_items on production.products.product_id = sales.order_items.product_id
GROUP by  category_name 
ORDER BY sum(quantity) ASC
-- Answer Electric Bikes less liked because it sold less number of products quantites
-- Cruisers Bicycles Most liked because it sold most number of products
---------------------------------------------------------------------------
-- 15- Which store still have more products of the most liked brand?
-- First we should know most liked brand convert question 13 to view
-- create view most_liked_brand as
create view most_liked_brand as
select top 1 brand_name , sum (sales.order_items.quantity) '#of_products' from production.brands
inner join production.products on production.products.brand_id = production.brands.brand_id
inner join sales.order_items on sales.order_items.product_id = production.products.product_id
GROUP by brand_name
ORDER BY brand_name 
-- Answer : Electra is the most liked brand
-- run view
select * from most_liked_brand
-- run query
select store_name , count(quantity) from sales.stores inner join sales.orders on sales.orders.store_id = sales.stores.store_id
inner join sales.order_items on sales.order_items.order_id = sales.orders.order_id
inner join production.products on production.products.product_id = sales.order_items.product_id
inner join production.brands on production.brands.brand_id = production.products.brand_id
where brand_name = (select brand_name from most_liked_brand)  -- brand_name = Electra
 and order_status = 4
GROUP by store_name 
ORDER BY count(store_name) DESC
---------------------------------------------------------------------------
--16- Which state is doing better in terms of sales?
select state  , sum (sales.order_items.list_price*quantity*(1-discount)) total_sold from sales.customers inner join 
sales.orders on sales.orders.customer_id = sales.customers.customer_id
INNER join sales.order_items on 
sales.order_items.order_id = sales.orders.order_id 
where order_status = 4
group by state
ORDER BY total_sold DESC
-- Answer : NY is doing better in terms of sales
---------------------------------------------------------------------------
-- 17 - What’s the discounted price of product id 259?
SELECT product_name, sales.order_items.product_id ,sum (sales.order_items.list_price*quantity*(1-discount)) FROM sales.order_items
inner join production.products on sales.order_items.product_id = production.products.product_id
WHERE sales.order_items.product_id = 259
GROUP by product_name , sales.order_items.product_id
-- Answer : 3035.9747 is discounted price is 3035.9747
---------------------------------------------------------------------------
-- 18 - What’s the product name, quantity, price, category, model year and brand
-- name of product number 44?
select product_name , sum (quantity) '#of_products' , i.list_price , category_id , model_year , brand_id 
from production.products p
inner join sales.order_items i
on p.product_id = i.product_id
where i.product_id = 44
group by product_name , i.list_price , category_id , model_year , brand_id
-- Answer : Road-150 Red, 44 , 3035.9747 , Mountain , 1998 , Road-150 Red
---------------------------------------------------------------------------
-- 19-  What’s the zip code of CA?
select distinct zip_code from sales.customers
where state = 'CA'
---------------------------------------------------------------------------
-- 20- How many states does BikeStore operate in?
select state from sales.stores
-- Answer : 3
---------------------------------------------------------------------------
-- 21- How many bikes under the children category (Children Bicycles) were sold in the last 8 months?
select sum (quantity) '#of_products' from production.products
inner join sales.order_items on sales.order_items.product_id = production.products.product_id
inner join sales.orders on sales.orders.order_id = sales.order_items.order_id
where category_id = 1  and order_date between '2017-05-01' and '2017-12-31' -- last 8 months , category_id = 1 (Children Bicycles)
GROUP by category_id
-- Answer : 365
---------------------------------------------------------------------------
-- 22-  What’s the shipped date for the order from customer 523
select sales.customers.first_name,shipped_date from sales.orders
inner join sales.customers on sales.customers.customer_id = sales.orders.customer_id
where sales.customers.customer_id=  523
---------------------------------------------------------------------------
-- 23- How many orders are still pending?
select count(order_status) '#of_orders pending' from sales.orders
where order_status = 3 -- pending
---------------------------------------------------------------------------
-- 24- What’s the names of category and brand does "Electra white water 3i -
-- 2018" fall under?
select brand_name , category_name from production.products
INNER join production.brands on production.brands.brand_id = production.products.brand_id
INNER join production.categories on production.categories.category_id = production.products.category_id
where product_name = 'Electra white water 3i - 2018'
-- Answer : Electra , Cruisers Bicycles
-----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- Analysis By : Fares Ashraf --------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
