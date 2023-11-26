CREATE DATABASE IF NOT EXISTS WalmartData;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,	
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(25) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
	VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
	time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(10,9),
    gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT(2,1)
);

-- ------------- CREATE NEW COLUMNS -------------

-- Time of Day 
SELECT 
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "17:00:00" THEN "Afternoon"
        ELSE "Evening"
	END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(15);

UPDATE sales SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "17:00:00" THEN "Afternoon"
        ELSE "Evening"
	END);

-- Day Name
SELECT 
	date,
    DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales SET day_name = DAYNAME(date);

-- Month Name
SELECT 
	date,
    MONTHNAME(date)
FROM sales;	

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales SET month_name = MONTHNAME(date);


-- ------------- QUESTIONS TO ANSWER --------------- 

-- How many unique cities does the data have?
SELECT DISTINCT city FROM sales;

-- In which city is each branch?
SELECT DISTINCT city, branch FROM sales;

-- How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) FROM sales;

-- What is the most common payment method?
SELECT
	payment_method,
	COUNT(payment_method) AS count_of_pm
FROM sales
GROUP BY payment_method
ORDER BY count_of_pm DESC;

-- What is the most selling product line?
SELECT
	product_line,
    COUNT(product_line) AS count_of_pl
FROM sales
GROUP BY product_line
ORDER BY count_of_pl DESC;

-- What is the total revenue by month?
SELECT
	month_name,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue;

-- What product line had the largest revenue?
SELECT
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(VAT) AS VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC;

-- Which branch sold more products than average product sold?
SELECT
	AVG(quantity)
FROM sales;

SELECT 
	branch,
    SUM(quantity) AS quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(product_line) AS count_of_pl
FROM sales
GROUP BY gender, product_line
ORDER BY count_of_pl DESC;

-- What is the average rating of each product line?
 SELECT
	product_line,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
	








