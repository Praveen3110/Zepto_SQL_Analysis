use project;
drop table if exists zepto;
create table zepto(
sku_id serial primary key,
Category varchar(100),
name varchar(100) not null,
mrp numeric(8,2),
discountPercent numeric(8,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms numeric(8,2),
outOfStock varchar(100),
quantity integer
);

---------------------------------------------------------------------------
#DATA EXPLORATION
#sample data
select * from zepto;

----------------------------------------------------------------------------

#to find th no of rows in the dataset
select count(*) from zepto;

---------------------------------------------------------------------------

#as the csv file contain the outof stock column in varchar format ,i have added a column outstock and changed it into boolean formate
alter table zepto add column outstock boolean;
update zepto set outstock=case 
	when outofstock="FALSE" then false 
	when outofstock="TRUE" then true
    end;
 -----------------------------------------------------------------------------   
 
 #check for null values
 select * from zepto
 where category is null or
name is null or
mrp is null or
discountpercent is null or
availablequantity is null or
discountedSellingPrice is null or 
weightingms is null or 
quantity is null or 
outstock is null;

------------------------------------------------------------------------------
#different product category
select distinct category 
from zepto
order by category;

--------------------------------------------------------------------------------
#checking the no.of product in stock and no of product outofstock 
#0 - out of stock,1-in s
select count(sku_id),case 
									when outstock=false then "available"
									when outstock=true then "notavailable"
                                    end as stock_status
from zepto
group by outstock;

---------------------------------------------------------------------------------
#check for product names which are present more than ones
select name,count(sku_id)
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;
------------------------------------------------------------------------------------
#DATA CLEANING
#checking mrp products the price is zero
select * 
from zepto
where mrp=0 or discountedSellingPrice=0;

#deleting the rwo with mrp or discountedSellingPrice is zero
delete from zepto 
where  mrp=0 or discountedSellingPrice=0;

#converting the paisa into rupee
update zepto 
set mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

---------------------------------------------------------------------------------
#solving businees insights questions using the dataset
#Q1 find the top 10 best value products based on the discount percentage

select distinct *
from zepto
order by discountpercent desc
limit 10;


#Q2 what are products with high mrp but out of stock
select distinct name,mrp
from zepto
where outstock is true and mrp>300
order by mrp desc;

#Q3 calculate the estimated revenue for each category
select sum(discountedsellingprice * availablequantity) as total_revenue,category
from zepto
group by category
order by total_revenue desc;

#Q4  find all the products where MRP is greater than $500 and discount is less than 10%
select distinct name,mrp,discountpercent
from zepto
where mrp>500 and discountPercent<10
order by mrp desc,discountpercent desc;

#Q5 Identify the top 5 category offering the highest average discount percetage
select distinct round(avg(discountpercent),2) as avg_dis_price,category
from zepto
group by category
order by avg_dis_price desc
limit 5;

#Q6 find the price per gram for products above 100g and sort by best values
select distinct name,round((discountedsellingprice/weightInGms),2) as price_per_grams
from zepto
where weightInGms>=100
order by price_per_grams;

#Q7 group the products into category like low medium bulk
select name,weightInGms,
case when weightInGms<1000 then "low"
	when weightInGms<5000 then "medium"
    else "bulk"
    end  as category_quantity
from zepto;

#Q8 what is the total inventory weight per category
select sum(weightInGms * availablequantity) as total_weight,category
from zepto
group by category
order by total_weight desc;