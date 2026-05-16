use retail_store ;

-- Level 1: Basics
-- 1.1 Retrieve customer names and emails for email marketing

select name,email from customers;

-- 1.2 View complete product catalog with all available details 

select*from products ;

-- 1.3 List all unique product categories

select distinct category from products ;

-- 1.4 Show all products priced above ₹1,000

select*from products where price>1000;

-- 1.5 Display products within a mid-range price bracket (₹2,000 to ₹5,000)

select*from products where price>2000 and price<5000;

-- 1.6 Fetch data for specific customer IDs (e.g., from loyalty program list)

-- proceeding by assuming that customer (1-4 & 7,9) belongs to this loyalty program 

select*from customers where customer_id in (1,2,3,4,7,9);

-- 1.7 Identify customers whose names start with the letter ‘A’

select*from customers where name like "A%" ;

-- 1.8 List electronics products priced under ₹3,000

select*from products where category="Electronics"and price<3000;

-- 1.9 Display product names and prices in descending order of price

select name,price
from products
order by price desc;

-- 1.10 Display product names and prices, sorted by price and then by name

select name,price 
from products
order by price desc ,name asc ;

-- Level 2: Filtering and Formatting

-- 1.2 Retrieve orders where customer information is missing (possibly due to data migration or deletion)

select*from orders where customer_id is null ;

-- 2.2 Display customer names and emails using column aliases for frontend readability

select name as customer_name,email as customer_email from customers ; 

-- 3.2 Calculate total value per item ordered by multiplying quantity and item price

select*, stock_quantity*price as total_value from products;

-- 4.2 Combine customer name and phone number in a single column

select concat(name ,"-",phone) as contact_information from customers ;

-- 5.2 Extract only the date part from order timestamps for date-wise reporting

select*, date(order_date) as date from orders ;

select*from orders ;

-- 6.2 List products that do not have any stock left

select*from products where stock_quantity=0;

select*from products ;
 

 -- Level 3: Aggregations


-- 3.1 Count the total number of orders placed

select count(order_id) as tolal_orders from orders ;

-- 3.2 Calculate the total revenue collected from all orders

select sum(total_amount) as total_revenue from orders ;

-- 3.3 Calculate the average order value

select avg(total_amount)as avg_order_value from orders ;

-- 3.4 Count the number of customers who have placed at least one order 

select  count(distinct customer_id) as count_of_customers from orders ;

--  3.5 Find the number of orders placed by each customer

select customer_id, count(customer_id) as count_of_orders from orders group by customer_id;

-- 3.6  Find total sales amount made by each customer

select customer_id , sum(total_amount) total_sales_amount_per_customer from orders group by customer_id ;

-- 3.7 List the number of products sold per category

select category ,count(product_id)as product_sold from products group by category;

-- 3.8 Find the average item price per category

select category, avg(price) avg_of_per_items from products group by category;

-- 3.9 Show number of orders placed per day

select date(order_date),count(order_id)as orders_placed_per_day from orders group by date(order_date);

-- 3.10 List total payments received per payment method

select method, sum(amount_paid) tolal_amount_paid from payments group by method ;

-- Level 4: Multi-Table Queries (JOINS)

-- 1.4 Retrieve order details along with the customer name (INNER JOIN)

select c.name,o.order_id,o.order_date,o.total_amount
from  customers c
inner join orders o
on o.customer_id=c.customer_id;

select*from customers;
select order_id,customer_id from orders;

-- 2.4 Get list of products that have been sold (INNER JOIN with order_items)

select distinct p.name as product_name
from products p
inner join order_items oi
on  p.product_id=oi.product_id;

-- 3.4 List all orders with their payment method (INNER JOIN) 

select o.order_id,py.method as payment_method
from orders o 
inner join payments py 
on o.order_id=py.order_id;

-- 4.4 Get list of customers and their orders (LEFT JOIN)

select c.name as customer_name,c.customer_id ,o.order_id,o.order_date,o.status
from customers c
left join  orders o
on c.customer_id=o.customer_id;

select*from orders;
select*from customers;

-- 5.4 List all products along with order item quantity (LEFT JOIN)

select p.name as product,oi.quantity as quantity
from products p 
left join order_items oi 
on p.product_id=oi.product_id ;


select*from products;
 
 -- 6.4 List all payments including those with no matching orders (RIGHT JOIN)
 
 select pay.*,o.order_date,o.status
 from orders o
 right join payments pay
 on pay.order_id=o.order_id;
 
 -- 7.4 Combine data from three tables: customer, order, and payment
 -- multi-join 
 -- here i have taken order table is the  central table  because it connects both the tables customer & payment.

 select o.*,c.*,pay.*
 from orders o
 inner join customers c 
 on o.customer_id=c.customer_id
 inner join payments pay
 on o.order_id=pay.order_id;
 
 -- Level 5: Subqueries (Inner Queries)
 

 -- 1.5 List all products priced above the average product price
 
 select*from products where price>
 (select avg(price)from products);
 

 -- 2.5 Find customers who have placed at least one order
 
 select customer_id,count(order_id)as count_of_orders from orders group by customer_id having count(order_id)>1;
 

-- 3.5 Show orders whose total amount is above the average for that customer
 -- first way-
 
 select *from orders o where total_amount>
 (select avg(total_amount)from orders where o.customer_id=customer_id);
 
 -- second was -
 
 select*from 
 (select*,avg(total_amount)over(partition by customer_id)as avg_amount from orders)t
 where total_amount>avg_amount;
 
 
 -- 4.5 Display customers who haven’t placed any orders
 
 select name from customers where customer_id not in
 (select customer_id from orders);
 
 -- 5.5 Show products that were never ordered
 
 select name from products where product_id not in
 (select product_id from order_items);
 
  -- 6.5 Show highest value order per customer
 
 select customer_id, max(total_amount) as highest_value_per_customer from orders group by  customer_id;
 
 -- 7.5 Highest Order Per Customer (Including Names)

 -- frist way
 
 select c.name,max(o.total_amount)as Highest_order_per_customers
 from customers c 
 join orders o 
 on c.customer_id=o.customer_id
 group by c.name;
 
 -- second way - with order_id that give max values per order_id of customers.
 
select c.name,o.order_id,max(o.total_amount)as Highest_order_per_customers
 from customers c 
 join orders o 
 on c.customer_id=o.customer_id
 group by c.name,o.order_id;



-- Level 6: Set Operations 

-- 1.6 List all customers who have either placed an order or written a product review
 
 select customer_id from orders
 union 
 select customer_id from product_reviews;
 
 -- 2.6 List all customers who have placed an order as well as reviewed a product
 
 select distinct customer_id from orders
 where customer_id in
 (select customer_id from product_reviews);