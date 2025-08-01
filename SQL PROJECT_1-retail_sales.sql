-- SQL Retail Sales Analysis - P1
-- Create a Table 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,	
				customer_id INT,
				gender VARCHAR(15),	
				age	INT,
				category VARCHAR(15),	
				quantiy	INT,
				price_per_unit FLOAT,
				cogs FLOAT,	
	            total_sale FLOAT
			);

SELECT * FROM retail_sales
LIMIT 10;

-- 1. Date Cleaning

SELECT 
	COUNT(*) 
FROM retail_sales;

SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR 
	  sale_time IS NULL 
	  OR 
	  customer_id IS NULL 
	  OR 
	  gender IS NULL
	  OR
	  category IS NULL
	  OR 
	  quantiy IS NULL 
	  OR 
	  price_per_unit IS NULL 
	  OR 
	  cogs IS NULL;

DELETE FROM retail_sales
WHERE transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR 
	  sale_time IS NULL 
	  OR 
	  customer_id IS NULL 
	  OR 
	  gender IS NULL
	  OR
	  category IS NULL
	  OR 
	  quantiy IS NULL 
	  OR 
	  price_per_unit IS NULL 
	  OR 
	  cogs IS NULL;

-- 2. Data Exploration 

--How many sales we have ? 

SELECT 
	COUNT(*) as total_num
FROM retail_sales;

-- How many customers we have ?

SELECT 
	COUNT (DISTINCT customer_id) as total_customers
FROM retail_sales;

-- How many categories we have ?

SELECT 
	DISTINCT category 
FROM retail_sales;

-- 3. Data Analysis and Business Key problems

-- 1. Write a SQL query to retrive all the columns for sales made on "2022-11-05"

SELECT 
	*
FROM retail_sales 
	WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all the transactions where the category = clothing , and quantity sold is more than 4
-- and in the month of Nov-2022?

SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
	AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantiy >= 4;

-- 3. Write a sql query to calculate the total sales (total_sale) for each category.

SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales 
GROUP BY 1;

-- 4. Write a query to find out the average age of customers who purchased items from the 'beauty' category ?

SELECT 
	category,
	ROUND(AVG(age),2) as avg_age
FROM retail_sales 
	WHERE category = 'Beauty'
	GROUP BY category;

-- 5. Write a SQL query to find all the trasactions where the total_sale is greater than 1000.

SELECT 
	*
FROM retail_sales 
WHERE total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category?

SELECT 
	category,
	gender,
	COUNT(transactions_id)
FROM retail_sales 
GROUP BY 1,2 
ORDER BY 1;
	
-- 7. Write a SQL query to find the average sale for each month . Find out the best selling month in each year 

SELECT 
	Year,
	Month,
	AVG_sales
	FROM 
		(SELECT 
			EXTRACT(YEAR FROM sale_date) as Year,
			EXTRACT(MONTH FROM sale_date) as Month,
			AVG(total_sale) as AVG_sales,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) as RNK
		FROM retail_sales 
		GROUP BY 1,2) as t1
	WHERE RNK = 1;

--8. Write a sql query to find the top 5 customers based on highest total sales 

With highest_sale as (
	SELECT 
		customer_id,
		sum(total_sale) as total_sales,
		RANK() OVER (ORDER BY sum(total_sale)DESC) AS rnk
	FROM retail_sales
	GROUP BY customer_id
)
select 
	customer_id,
	total_sales
FROM highest_sale  
WHERE rnk <=5;

-- 9.Write a SQL query to fnd the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT(customer_id)) as customer_numbers
FROM retail_sales
group by 1;

-- 10. Write a SQL query to create shift and number od orders (morning <=12, Afternoon Between 12 & 17, Evening >17)
	
WITH hourly_sales AS (
SELECT 
	CASE WHEN EXTRACT(hour from sale_time) < 12 THEN 'Morning'
		 WHEN EXTRACT(hour from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'EVENING'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
	count(*) as total_orders
FROM hourly_sales
GROUP BY shift

--- END OF PROJECT ---
	

