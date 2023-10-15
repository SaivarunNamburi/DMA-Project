show databases;
create database inventory;
use inventory;

create table orders 
(order_id Int primary key, pharmacy_id int, shipment_id int, order_date datetime, payment_type varchar(100),total_amount int);

create table order_details 
(order_id INT, drug_id INT,quantity int);


create table stock_details 
(stock_id int primary key, drug_id int, warehouse_id int, stock_left int, last_ordered_date datetime, last_updated_date datetime,  mfg_date datetime, exp_date datetime);

create table shipment_details
(shipment_id int primary key, warehouse_id int, shipment_start_date datetime, order_id int, shipment_end_date datetime);

create table suppliers
(supplier_id int primary key, company_name varchar(30),phone_no bigint, address varchar(50));

create table drugs
(drug_id int primary key, drug_name varchar(50), manufacturer varchar(130), mrp_price int, supplier_id int);

create table warehouse_details
(warehouse_id int primary key, warehouse_name varchar(30), address varchar(50), phone_no bigint,zipcode int(10));

Create Table pharmacy
(pharmacy_id int primary key, pharmacy_name Varchar(100), address varchar(150), phone_no bigint);

ALTER TABLE drugs ADD FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);
ALTER TABLE shipment_details ADD FOREIGN KEY (warehouse_id) REFERENCES warehouse_details(warehouse_id);
ALTER TABLE stock_details ADD FOREIGN KEY (warehouse_id) REFERENCES warehouse_details(warehouse_id);
ALTER TABLE order_details ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);
ALTER TABLE shipment_details ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);
ALTER TABLE order_details ADD FOREIGN KEY (drug_id) REFERENCES drugs(drug_id);
ALTER TABLE stock_details ADD FOREIGN KEY (drug_id) REFERENCES drugs(drug_id);
ALTER TABLE orders ADD FOREIGN KEY (shipment_id) REFERENCES shipment_details(shipment_id);


select * from drugs; 
select * from pharmacy; 
select * from suppliers;
select * from warehouse_details;
select * from orders;
select * from stock_details;
select * from order_details;
select * from shipment_details;

select * from orders join order_details
on orders.order_id=order_details.order_id
where orders.total_amount>25000 and orders.order_date<'12/31/2021'
order by orders.total_amount desc;

select * from stock_details
where stock_left <200;
