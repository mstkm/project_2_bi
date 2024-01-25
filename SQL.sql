-- Create Schema
create table fact_tansaction (
	bill_id integer not null,
	user_id integer,
	line_item_amount float,
	bill_discount float,
	transaction_date date,
	description text,
	inventory_category varchar(225),
	color text,
	size varchar(225),
	zone_name varchar(225),
	store_name varchar(225),
	year integer
);

create table dim_date (
	transaction_date date not null,
	transaction_date_day integer,
	transaction_date_month integer,
	transaction_date_year integer
);

create table dim_year (
	transaction_date_year integer not null,
	transaction_date_year_information text
);

create table dim_zone (
	zone_name varchar(225),
	zone_information text
);


-- Create Data Mart
create view vw_mart_metrik as
select distinct 
	ft.year as tahun,
	count(distinct ft.user_id) as user,
	count(ft.bill_id) as transaksi,
	round(sum(ft.line_item_amount)::numeric, 2) as penjualan,
	count(distinct ft.description) as barang,
	round(sum(ft.bill_discount)::numeric, 2) as diskon
from fact_transaction ft
group by ft.year

create view vw_mart_zone as
select
	ft.year as tahun,
	ft.zone_name as zona,
	round(sum(ft.line_item_amount)::numeric, 2) as penjualan
from fact_transaction ft
group by ft.year, ft.zone_name;

create view vw_mart_rata_penjualan_per_zona as
select
	ft.zone_name as zona,
	round((sum(ft.line_item_amount)/count(ft.line_item_amount))::numeric, 2) as rata_penjualan
from fact_transaction ft
group by ft.zone_name;

create view vw_mart_rata_penjualan_per_tahun as
select
	ft.year as tahun,
	round((sum(ft.line_item_amount)/count(ft.line_item_amount))::numeric, 2) as rata_penjualan
from fact_transaction ft
group by ft.year;
