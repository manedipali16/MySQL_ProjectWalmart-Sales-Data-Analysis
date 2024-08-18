--first we have to import data file using Right-click on the table you want to insert data into from the left sidebar and select "Table Data Import Wizard"
--Retrive the data using select Statement.

select * from WalmartSalesdata;

drop table WalmartSalesdata;

--Generic Question
--Q1. How many unique cities does the data have?
      SELECT COUNT(DISTINCT City) AS unique_city_count FROM WalmartSalesdata; 

--2. In which city is each branch?
	SELECT Branch, City FROM WalmartSalesdata;
    
--Product
--Q1. How many unique product lines does the data have?
      SELECT COUNT(DISTINCT product_line) AS unique_product_lines FROM WalmartSalesdata;

--Q2. What is the most common payment method?
      SELECT payment, COUNT(*) AS payment_method_count FROM WalmartSalesdata
	  GROUP BY payment ORDER BY payment_method_count DESC LIMIT 1;
      
 --Q3. What is the most selling product line?
       SELECT PRODUCT_LINE, SUM(Quantity) AS most_selling_product_line from WalmartSalesdata
       GROUP BY PRODUCT_LINE ORDER BY most_selling_product_line DESC LIMIT 1;

--Q4. What is the total revenue by month?*******
SELECT MONTH, SUM(TOTAL) AS total_revenue FROM WalmartSalesdata GROUP BY MONTH;

--Q5. What month had the largest COGS?
SELECT month, SUM(cogs) AS largest_cogs FROM WalmartSalesdata GROUP BY MONTH ORDER BY largest_cogs DESC
LIMIT 1;

--Q6. What product line had the largest revenue?
      SELECT product_line, SUM(TOTAL) AS largest_revenue
FROM WalmartSalesdata GROUP BY product_line ORDER BY largest_revenue DESC LIMIT 1;

--Q7. What is the city with the largest revenue?
       SELECT city, SUM(TOTAL) AS largest_revenue
FROM WalmartSalesdata GROUP BY city ORDER BY largest_revenue DESC LIMIT 1;    
   
--Q8. What product line had the largest VAT?
SELECT product_line, SUM(VAT) AS largest_VAT
FROM WalmartSalesdata GROUP BY product_line ORDER BY largest_VAT DESC LIMIT 1;

--Q9. Fetch each product line and add a column to those product line showing "Good", "Bad". 
Good if its greater than average sales
SELECT product_line, 
CASE 
     WHEN AVG (Quantity) > (Quantity)
     THEN 'GOOD' 
ELSE 'BAD' 
END AS 'COMMENT' FROM WalmartSalesdata GROUP BY product_line;
   
--Q10. Which branch sold more products than average product sold?
SELECT branch, total_products_sold FROM 
    (SELECT branch, SUM(quantity) AS total_products_sold
    FROM WalmartSalesdata GROUP BY branch) AS branch_sales
WHERE 
    total_products_sold > (SELECT AVG(total_products_sold) 
                           FROM 
                               (SELECT SUM(quantity) AS total_products_sold 
                                FROM WalmartSalesdata 
                                GROUP BY branch) AS avg_sales);

--Q11. What is the most common product line by gender?
SELECT gender, product_line, COUNT(*) AS product_count
FROM WalmartSalesdata GROUP BY  gender, product_line;

12. What is the average rating of each product line?    
  SELECT product_line, AVG(RATING) AS AVG_RATING
FROM WalmartSalesdata GROUP BY product_line;

--Sales
--Q1. Number of sales made in each time of the day per weekday
SELECT time_of_day, week_day, COUNT(*) AS number_of_sales FROM WalmartSalesdata
GROUP BY time_of_day, week_day ORDER BY number_of_sales DESC;
--Most sales are done in the afternoon, especially on Saturday and wednesday.

--Q2. Which of the customer types brings the most revenue?
SELECT customer_type, sum(total) AS most_revenue FROM WalmartSalesdata
GROUP BY customer_type ORDER BY most_revenue DESC;
--The bulk of revenue comes from member customer types. However, the margin between it and normal customers is not wide

--Q3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT city, sum(VAT) AS largest_VAT FROM WalmartSalesdata
GROUP BY city ORDER BY largest_VAT DESC;
--Naypyitaw has the highest tax rate followed by Mandalay

--Q4. Which customer type pays the most in VAT?
SELECT customer_type, sum(VAT) AS most_VAT FROM WalmartSalesdata
GROUP BY customer_type ORDER BY most_VAT DESC;
--Customers who are members pay the most VAT

--Customer

--Q1. How many unique customer types does the data have?
SELECT count(distinct customer_type) AS Unique_customer_type FROM WalmartSalesdata;
--There are two (2) distinct customers in the dataset.

--Q2. How many unique payment methods does the data have?
SELECT count(distinct payment) AS Unique_payment_method FROM WalmartSalesdata;
--There are three (3) distinct payment methods in the dataset.

--Q3. What is the most common customer type?
SELECT customer_type, count(customer_type) AS common_customer_type FROM WalmartSalesdata
GROUP BY customer_type ORDER BY common_customer_type DESC;
--Member is the most common customer type as it has a total of 501 customers.

--Q4. Which customer type buys the most?
SELECT customer_type, SUM(quantity) AS total_quantity_buys
FROM WalmartSalesdata GROUP BY customer_type ORDER BY total_quantity_buys DESC;
--Customers who are members buy the most from the store is 2785.

--Q5. What is the gender of most of the customers?
SELECT gender, count(*) AS most_customers
FROM WalmartSalesdata GROUP BY gender ORDER BY most_customers DESC;
--Most of the customers are female is 501. 

--Q6. What is the gender distribution per branch?
SELECT branch, gender, count(gender) AS total_gender_dpb FROM WalmartSalesdata 
GROUP BY branch, gender ORDER BY branch;
--dpb stand for distribution per branch

**************************************************
SELECT * FROM WalmartSalesdata;

--WE HAVE SOME TASK PERFORM ON Time_of_day, Week_Day, Month SO WE HAVE TO POPULATING OUR 
TABLE WITH SOME NEW COLUMNS
--here, I AM CREATING and ADDING the following columns to our database:

Time_of_day
Week_Day
Month

— — CREATING THE COLUMN CALLED time_of_day, week_day, and month USING THE alter statment.

ALTER TABLE WalmartSalesdata
ADD COLUMN time_of_day VARCHAR(20),
ADD COLUMN week_day VARCHAR(20),
ADD COLUMN month VARCHAR(20);

--retriving the data using select statment.

select * from WalmartSalesdata;

--To create a new column called time_of_day based on the time of a transaction using the CASE statement in MySQL, you can use conditions to categorize the time into different parts of the day (e.g., Morning, Afternoon, Evening, Night).

Here's how you can do it:
 
UPDATE WalmartSalesdata
SET time_of_day = CASE 
    WHEN HOUR(Time) >= 5 AND HOUR(Time) < 12 THEN 'Morning'
    WHEN HOUR(Time) >= 12 AND HOUR(Time) < 17 THEN 'Afternoon'
    WHEN HOUR(Time) >= 17 AND HOUR(Time) < 21 THEN 'Evening'
    ELSE 'Night'
END;
/*
--Explanation
HOUR(transaction_time): This extracts the hour from the transaction_time column.
CASE Statement:
WHEN HOUR(transaction_time) >= 5 AND HOUR(transaction_time) < 12 THEN 'Morning': If the hour is between 5 AM and before 12 PM, categorize it as 'Morning'.
WHEN HOUR(transaction_time) >= 12 AND HOUR(transaction_time) < 17 THEN 'Afternoon': If the hour is between 12 PM and before 5 PM, categorize it as 'Afternoon'.
WHEN HOUR(transaction_time) >= 17 AND HOUR(transaction_time) < 21 THEN 'Evening': If the hour is between 5 PM and before 9 PM, categorize it as 'Evening'.
ELSE 'Night': If none of the above conditions are met, categorize it as 'Night'.

--We have two diff columns like date and time. we want weekday from tha database. 
so, Combine Date and Time Columns using concat function.
If your table has separate Date and Time columns, you can combine them into a datetime format and then extract the day of the week:

Explanation:
CONCAT(Date, ' ', Time): Combines the Date and Time columns into a single string in the format DD-MM-YYYY HH:MM:SS.
STR_TO_DATE(..., '%d-%m-%y %H:%i:%s'): Converts the combined string into a MySQL datetime format.
DAYNAME(): Extracts the day of the week from the datetime value
*/
UPDATE WalmartSalesdata
SET week_day = DAYNAME(STR_TO_DATE(CONCAT(Date, ' ', Time), '%d-%m-%Y %H:%i:%s'));

/*
--Convert the Date Format Using STR_TO_DATE()
--You can use the STR_TO_DATE() function to convert the string date format into a recognized MySQL date format before using the MONTHNAME() function.
--Explanation:
STR_TO_DATE(Date, '%d-%m-%Y'): This converts the string Date in the format DD-MM-YYYY to a MySQL date format.
MONTHNAME(): This then extracts the month name from the converted date. */

UPDATE WalmartSalesdata
SET month = MONTHNAME(STR_TO_DATE(Date, '%d-%m-%Y'));

******************
--Q7. Which time of the day do customers give most ratings?

SELECT time_of_day,
count(rating) AS most_rating
FROM WalmartSalesdata
GROUP BY time_of_day
ORDER BY most_rating DESC;

Most ratings are done in the Afternoon. 
This can be as a result that customers patronize the store more in the Afternoon.


--Q8. Which time of the day do customers give most ratings per branch?
SELECT  branch, time_of_day, COUNT(*) AS rating_count
FROM  WalmartSalesdata GROUP BY branch, time_of_day ORDER BY branch,  rating_count DESC;
Most of the ratings come in the afternoon time of the day with branch A.


--Q9. Which day fo the week has the best avg ratings?

SELECT week_day, AVG(rating) AS Best_Avg_rating
FROM WalmartSalesdata GROUP BY week_day ORDER BY Best_Avg_rating DESC;

Monday, Friday, and Sunday are the days of the week with the best average rating.

--Q10. Which day of the week has the best average ratings per branch?
SELECT week_day, branch, AVG(rating) AS Best_Avg_rating_pb
FROM WalmartSalesdata GROUP BY week_day, branch ORDER BY Best_Avg_rating_pb DESC, branch;

--pb stands form per branch



