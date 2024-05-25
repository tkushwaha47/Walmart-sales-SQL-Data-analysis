Select * from SalesDataWalmart.sales;

-- Data cleaning
Select * 
	from 
sales;

-- Add the time_of_day column
Select time
from sales;
Select 
	time,
    (CASE
		WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
			ELSE 'Evening'
        END
        ) AS Time_of_date
from sales;
-- OR We can Use below query to get solution
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = 
	(CASE
		WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
        END);
        
-- DAY NAME ------------
Select 
	date,
    DAYNAME(date) AS DAY_NAME
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);

UPDATE sales
SET day_name = DAYNAME(date);

-- Month Name -----------------------------------------------
Select date,
	monthname(date) as Month_Name
from sales;

ALTER TABLE sales add column Month_name VARCHAR(20);
update Sales
SET Month_name = monthname(date);

-- How many unique cities does the data have? ---
Select distinct(city)
from sales;

-- In which city is each branch?----
Select distinct city,
	branch
from sales;

-- How many unique product lines does the data have?-----
select distinct(product_line)
from sales;

-- What is the most common payment method? --
Select
	payment_method,
	Count(payment_method) as Common_payment
from sales
group by payment_method order by Common_payment desc
;

-- What is the most selling product line-----
select 
	product_line, 
    count(product_line) as Most_Selling_product
from sales
group by product_line order by Most_Selling_product desc;

-- What is the total revenue by month----
Select Month_name, sum(total) as Total_Reveune
from sales
group by Month_name order by Total_Reveune desc;

-- What month had the largest COGS?
select Month_name, sum(cogs) as Total_COGS
from sales
group by Month_name order by Total_COGS desc;

-- What product line had the largest revenue?
select product_line , sum(total) as Total_Revenue
from sales
group by product_line order by Total_Revenue Desc;

-- What is the city with the largest revenue?
select branch ,city, sum(total) as Total_Revenue
from sales
group by city,branch order by Total_Revenue Desc;

-- What product line had the largest VAT?
select product_line, sum(VAT) as Total_VAT_Revenue
from sales
group by product_line order by Total_VAT_Revenue Desc;

-- Fetch each product line and add a column to those product line 
-- showing "Good", "Bad". Good if its greater than average sales-----



-- Which branch sold more products than average product sold?
select branch, SUM(quantity) as Qty
from sales
group by branch 
having sum(quantity) > (Select avg(quantity) from sales);

-- What is the most common product line by gender
select gender, product_line,
count(gender) as Total_gender
from sales
group by gender,product_line order by Total_gender desc;

-- What is the average rating of each product line
select product_line, avg(rating) as Average_Rating
from sales
group by product_line order by Average_Rating desc;

-- How many unique customer types does the data have?
select distinct(customer_type) as Unique_Customer_Type
from sales;

-- How many unique payment methods does the data have?
select payment_method, count(distinct(payment_method)) as Unique_payment_method
from sales
GROUP BY payment_method;

-- What is the most common customer type?
select customer_type , count(customer_type)
from sales
group by customer_type order by customer_type desc;

-- Which customer type buys the most?
select customer_type, count(total) as Total_Revenue
from sales
group by customer_type order by Total_Revenue;

-- What is the gender of most of the customers?
select gender,count(gender) as gender
from sales
group by gender order by gender desc;

-- What is the gender distribution per branch?
SELECT
    branch,
    SUM(CASE 
    WHEN gender = 'Male' THEN 1 
    ELSE 0 
    END) AS male_count,
    SUM(CASE WHEN gender = 'Female' THEN 1 
    ELSE 0 
    END) AS female_count
FROM
    sales
GROUP BY
    branch;
-- Gender per branch is more or less the same hence, 
-- I don't think has an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
select time_of_day , avg(Rating) as Avg_Rating
from sales
group by time_of_day order by Avg_Rating desc;

-- Looks like time of the day does not really affect the rating, 
-- its more or less the same rating each time of the day.alter

-- Which time of the day do customers give most ratings per branch?
select time_of_day , avg(Rating) as Avg_Rating
from sales
where branch = 'A'
group by time_of_day order by Avg_Rating desc;

-- Branch A and C are doing well in ratings, 
-- branch B needs to do a little more to get better ratings.

-- Which day fo the week has the best avg ratings?
select day_name , avg(Rating) as Avg_Rating
from sales
group by day_name order by Avg_Rating desc;
-- Mon, Tue and Friday are the top best days for good ratings 
-- why is that the case, how many sales are made on these days?

-- Which day of the week has the best average ratings per branch?
select day_name, avg(rating) as Average_Rating
from sales
where branch = 'A'
group by day_name order by Average_Rating Desc;

-- Number of sales made in each time of the day per weekday.
select
time_of_day,
count(*) as total_sales
from sales
Where day_name = "sunday"
group by time_of_day order by total_sales desc;

-- Evenings experience most sales, the stores are filled during the evening hours
select time_of_day, sum(total) as Total_Sales
from sales
Where time_of_day = "Evening"
group by time_of_day order by Total_Sales desc;

-- Which of the customer types brings the most revenue?
select customer_type , sum(total) as Total_Revenue
from sales
group by customer_type order by Total_Revenue Desc;

-- Which city has the largest tax/VAT percent?
Select sales.city , avg(VAT) as VAT
from sales
GROUP BY city order by VAT DESC Limit 1;

-- Which customer type pays the most in VAT?
Select customer_type, avg(VAT) as VAT
from sales
group by customer_type order by VAT DESC;