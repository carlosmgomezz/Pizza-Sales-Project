CREATE TABLE pizza_staging
LIKE pizza_sales;

INSERT INTO pizza_staging
SELECT *
FROM pizza_sales;

SELECT *
FROM pizza_staging;

-- Total Revenue

SELECT SUM(total_price) AS Total_Revenue
FROM pizza_staging;

-- Average Order Value

SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value
FROM pizza_staging;

-- Total Pizzas Sold
SELECT SUM(quantity) AS Total_Pizzas_Sold 
FROM pizza_staging;

-- Total Orders

SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_staging;

-- Average Pizzas Per Order

SELECT SUM(quantity) / COUNT(DISTINCT order_id) AS Avg_Pizzas_Per_Order
FROM pizza_staging;

-- STR TO DATE
UPDATE pizza_staging
SET order_date = STR_TO_DATE(order_date,'%d-%m-%Y');

ALTER TABLE pizza_staging
MODIFY COLUMN order_date DATE;

-- Daily Trend for Total Orders

SELECT  DAYNAME(order_date) as order_day, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_staging
GROUP BY DAYNAME(order_date);

-- STR TO DATE
UPDATE pizza_staging
SET order_time = STR_TO_DATE(order_time,'%H:%i:%s');

ALTER TABLE pizza_staging
MODIFY COLUMN order_time TIME;

-- Hourly Trend for Total Orders

SELECT HOUR(order_time) AS order_hours, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_staging
GROUP BY HOUR(order_time);

-- Percentage of Sales by Pizza Category

SELECT pizza_category,ROUND(SUM(total_price),2) AS Total_Sales,ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) 
FROM pizza_staging),2) AS Percentage_Total_Sales
FROM pizza_staging 
GROUP BY pizza_category
ORDER BY Percentage_Total_Sales DESC ;

-- Percentage of Sales by Pizza Size

SELECT pizza_size, ROUND(SUM(total_price),2) As Total_Sales, ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) 
FROM pizza_staging),2) AS Percentage_Total_Sales
FROM pizza_staging
GROUP by pizza_size
ORDER BY Percentage_Total_Sales DESC;

-- Total Pizzas Sold by Pizza Category

SELECT pizza_category, SUM(quantity) as Total_Pizzas_Sold
FROM pizza_staging
GROUP BY pizza_category;

-- Top 5 Best Sellers by Total Pizzas Sold

SELECT  pizza_name, SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_staging
GROUP BY pizza_name
ORDER BY Total_Pizzas_Sold DESC
LIMIT 5;

-- Top 5 Worst Sellers by Total Pizzas Sold

SELECT  pizza_name, SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_staging
GROUP BY pizza_name
ORDER BY Total_Pizzas_Sold ASC
LIMIT 5;
 

