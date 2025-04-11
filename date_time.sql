-- Q1 Find the total order amount per customer for each month.
SELECT customer_id,YEAR(order_date), MONTH(order_date),SUM(total_amount)
FROM campusx.orders
GROUP BY customer_id, YEAR(order_date), MONTH(order_date)
ORDER BY customer_id;

-- Q2 Label each order as 'Early', 'Mid', or 'Late' month based on the day of order_date
SELECT order_id, order_date,
CASE
    WHEN DAY(order_date) BETWEEN 1 AND 10 THEN 'early'
    WHEN DAY(order_date) BETWEEN 11 AND 20 THEN 'mid'
    ELSE 'late'
END AS month_period
FROM orders;

-- Q3 Find customers who placed at least one order in every month from Jan to Mar 2024.
SELECT customer_id
FROM orders 
GROUP BY customer_id
HAVING COUNT(DISTINCT(MONTH(order_date)))>=3;

-- Q4 Find the cumulative total_amount spent per customer, ordered by order_date.
SELECT customer_id,order_id,order_date,total_amount,
SUM(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM orders;

-- Q5 Show customer orders that were delivered on a weekend and had total_amount > 1000.
SELECT order_id,customer_id,delivery_date,
DAYNAME(delivery_date) AS day_of_week,
total_amount
FROM orders WHERE (DAYNAME(delivery_date) = 'Sunday' OR DAYNAME(delivery_date) = 'Saturday')
AND total_amount > 1000;

-- Q6 For each customer, show the month where they spent the most (total_amount sum-wise).
SELECT customer_id, m AS best_month, s AS total_spent
FROM 
(SELECT customer_id,  MONTH(order_date) AS m, SUM(total_amount) AS s,
RANK() OVER(PARTITION BY customer_id ORDER BY SUM(total_amount) DESC) AS r
FROM orders
GROUP BY customer_id, MONTH(order_date)
) t
WHERE r=1;

-- Q7 Find average delivery gap per customer per month.
SELECT customer_id, YEAR(order_date), MONTH(order_date) ,
ROUND(AVG(DATEDIFF(delivery_date, order_date)),2)AS avg_delivery_days 
FROM orders
GROUP BY customer_id,  YEAR(order_date),MONTH(order_date)
ORDER BY customer_id;