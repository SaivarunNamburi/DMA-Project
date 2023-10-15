use inventory;

-- Basic Analysis
-- 1 Finding all the suppliers whose company name starts with 'A'
Select *
From suppliers
Where company_name LIKE 'A%';

-- 2 Querying the orders table to find the count of orders placed in the year 2021 and 2022
select count(*) as orders_in_btw_2021_2022
from orders
where order_date between '2021-01-01' and '2022-12-31';

-- 3 Querying the orders table to get the order details which are more than 30000 and orders placed in 2022
select * from orders where total_amount>30000
and order_date>'2022-01-01'
order by total_amount desc;

-- 4 Querying table payment to find max,min and average of total amount customer paid for order
Select MAX(total_amount) as Max_Amount, MIN(total_amount)as Min_Total_Amount, AVG(total_amount) as AVG_Purchase
From orders;

-- 6 Querying orders table to find the count of online and offline orders
Select 
count(case when payment_type ='Online' then 1 end) as online_orders,
count(case when payment_type='Offline' then 1 end) as offline_orders
from orders; 

-- 6 Querying the orders table with total amount more than 45000 and orders which are placed before 2022
 select count(*) from orders where total_amount>45000 and order_date<'2021-12-31'
order by total_amount desc;

-- 7 Find the avg, min, max of the price of the drugs 
select Avg(mrp_price) as avg_price, min(mrp_price) as min_price, max(mrp_price) as max_price  
from drugs;

-- 8 Querying the stocks table to find which have minimum stocks
select * from stock_details where stock_left <200;

-- 9 Query to find more than 2 warehouses in same zipcode
Select zipcode, Count(*) as cnt from warehouse_details group by zipcode having cnt>2;

-- Intermediate Analysis
-- Join Operations
-- 10 Inner join with orders and order details table(Displays all the common orders from both tables)
select * from 
order_details od inner join orders o 
on od.order_id=o.order_id;

-- 11 Querying the warehouse and stocks table to get the warehousename and stocks left in warehouse by join operations
select wd.warehouse_id, wd.warehouse_name, sd.stock_left, sd.last_ordered_date
from warehouse_details wd join stock_details sd
on wd.warehouse_id=sd.warehouse_id
order by wd.warehouse_name;

-- 12 Querying for finding  order,pharmacy, payment type for each order that exceeds order quantity of 30
select o.order_id, o.payment_type, p.pharmacy_name, od.quantity
from orders o, pharmacy p, order_details od 
where o.order_id=od.order_id and o.pharmacy_id = p.pharmacy_id and
od.quantity >=30;

-- 13 Querying for finding  order,pharmacy, payment type which has the highest order amount in the month of sept 2022
select o.order_id, o.payment_type, p.pharmacy_name, o.total_amount
from orders o, pharmacy p
where  o.pharmacy_id = p.pharmacy_id
and o.order_id in (select order_id from orders
where order_date between '2022-09-01 00:00:00' and '2022-09-30 00:00:00')
order by o.total_amount Desc 
limit 1;

-- 14 Querying the drugs and suppliers to find the manufacturer and price of each drugs 
select d.drug_id,d.drug_name, d.manufacturer, d.mrp_price, s.supplier_id, s.company_name as supplier_name
from drugs d join suppliers s 
on d.supplier_id=s.supplier_id
order by drug_name;

-- 15 Joining the shipment table and warehouse table to retrieve shipment date and warehouse name
select sd.shipment_id,wd.warehouse_name,wd.phone_no, sd.shipment_start_date
from shipment_details sd, warehouse_details wd
where sd.warehouse_id=wd.warehouse_id
order by sd.warehouse_id;

/*16 Query to retrieve the names of the orders, pharmacy name  who
have the highest quantity ordered by pharmacy within 2022 (Using Any)*/
Select o.order_id,p.pharmacy_name ,od.quantity,o.payment_type
From orders o join order_details od on o.order_id=od.order_id join pharmacy p on o.pharmacy_id=p.pharmacy_id
Where p.pharmacy_id IN
(select pharmacy_id
From pharmacy
Where pharmacy_name in ('Rxtra','Wellfresh','Pharmanic','Kerr Drug')
and od.quantity>
Any
(select quantity from order_details group by order_id having quantity = max(quantity)));


-- Business Analysis
/* 17 Correlated Query to retrieve the order_id of all orders with at least one supplied drugs to pharmacies 
who placed an Offline Orders */
Select o.pharmacy_id
From orders o
Where 1 <=
(Select COUNT(*)
From pharmacy p
Where p.pharmacy_id = o.pharmacy_id  and o.payment_type='Offline');

/*18 Query for retrieving the names of thhe drugnames which have stock more than 800 (Using EXISTS)*/
select drug_name
from drugs 
Where EXISTS
(select  drug_id
from  stock_details
where stock_details.drug_id=drugs.drug_id
and stock_details.stock_left>800)
order by drug_name;

-- Extended RDBMS
-- Query for Triggers
-- 19 Query to update last updated date for that stockdetails to today when new order arrives
Create trigger `IsStockAvailable`
before insert on order_details
for each row
update stock_details
set last_updated_date=curdate() 
where drug_id= new.drug_id
;
Drop trigger IsStockAvailable;
-- Inserting data into order_details to check triggers
insert into order_details values (112, 30,20);
select * from stock_details where drug_id=30;

-- Query for Views
/* 20 Query for Viewing the expired stock*/
Create view `ExpiredStock` as
select * from Stock_details where exp_date<curdate();
-- Query to get records where stock+left is greater than 50 from the View ExpiredStock
Select * from ExpiredStock where stock_left>50;





select * from orders;
select * from order_details;
select * from drugs;
select * from pharmacy;
select * from suppliers;
select * from stock_details;
select * from warehouse_details;
select * from shipment_details;




