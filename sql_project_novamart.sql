CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
city VARCHAR(50),
signup_date DATE
);

CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price NUMERIC
);

CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE
);

CREATE TABLE order_items (
order_item_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT
);
SELECT * FROM customers;
SELECT COUNT(*) FROM customers;

--Q1. Find all customers from Delhi
SELECT *
FROM customers
WHERE city = 'Delhi';

--Q2. Show all products sorted by price (highest to lowest)
select * from products 
order by price DESC;

--Q3. Get top 5 most expensive products
select * from products
order by price DESC
limit 5

--Get next 5 products (pagination concept)
SELECT * FROM products
ORDER BY price DESC
LIMIT 5 OFFSET 5;

--Q4. Find total number of orders
-- Find average product price
-- Find maximum order quantity
SELECT COUNT(*) FROM orders;
SELECT AVG(price) FROM products;
SELECT MAX(quantity) FROM order_items;

--Q5. Find total number of customers in each city
SELECT city, COUNT(*)
FROM customers
GROUP BY city;

--Q6. Find cities with more than 10 customers
SELECT city, COUNT(*)
FROM customers
GROUP BY city
HAVING COUNT(*) > 10;

--Q7. Show customer_name, product_name, quantity
SELECT c.customer_name, p.product_name, oi.quantity
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON oi.product_id = p.product_id;

--Q8. Categorize orders: quantity > 3 → “High Order”, else → “Low Order”
SELECT quantity,
CASE
WHEN quantity > 3 THEN 'High Order'
ELSE 'Low Order'
END AS order_status
FROM order_items;

--Q9. Convert all customer names to UPPERCASE
-- Find customers whose name starts with ‘C’
select upper(customer_name) from customers
WHERE customer_name LIKE 'C%'

--Q10. Extract month from order_date
-- Count number of orders per month
SELECT EXTRACT(MONTH FROM order_date) AS month
FROM orders;
SELECT EXTRACT(MONTH FROM order_date), COUNT(*)
FROM orders
GROUP BY EXTRACT(MONTH FROM order_date);

--Q11. Add a new column: discount NUMERIC
alter table products add column discount int

--Q12. Update discount: If price > 300 → discount = 20, else → discount = 10
UPDATE products
SET discount = CASE
WHEN price > 300 THEN 20
ELSE 10
END;

--Q13. Find customers who have placed more than average number of orders
SELECT customer_id, COUNT(*)
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders
        GROUP BY customer_id
    ) sub
);

--Q14. Rank customers based on total spending
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_spending,
    RANK() OVER (ORDER BY SUM(oi.quantity * p.price) DESC) AS rank
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name;

--Q15. Find customers who never placed an order
SELECT 
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--Q16. Combine customer cities and product categories (remove duplicates)
SELECT city AS value
FROM customers
UNION
SELECT category AS value
FROM products;
--Q17. Combine customer cities and product categories (keep duplicates)
SELECT city AS value
FROM customers
UNION ALL
SELECT category AS value
FROM products;

--Q18. Calculate total revenue: price * quantity
SELECT 
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id;