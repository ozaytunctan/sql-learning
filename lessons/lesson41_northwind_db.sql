-- Using Northwind Database
-- #########################################

/*

	-- Practice Queries
	-- Join / Sub Queries
	-- Advanced Quries and much more 


*/

-- Orders shipping to USA or France

SELECT * FROM orders ORDER BY ship_country;

SELECT 
*
FROM  orders
WHERE
	ship_country ='USA'
	OR ship_country='France'
ORDER BY
	ship_country;
	
	
-- Count total numbers of orders shipping to USA or France


SELECT 
	ship_country,
	COUNT(*)
FROM  orders
--WHERE
--	ship_country ='USA'
--	OR ship_country='France'
GROUP BY 
	ship_country
ORDER BY
	2 DESC,
	ship_country;
	
	
	
-- Show order total amount per each order line

total_amount=(unit_price * quantity) - discount

SELECT
	order_id,
	product_id,
	unit_price,
	quantity,
	( (unit_price*quantity) - discount) as total_order_amount
FROM order_details;



-- Customers with no orders

SELECT
	*
FROM customers c
LEFT JOIN orders o ON o.customer_id=c.customer_id
WHERE
	o.customer_id IS NULL





-- orders with double entry line items;
QTY>60

SELECT	
	order_id,
	quantity
	--,COUNT(*)
FROM order_details
WHERE 
	quantity>60
GROUP BY 
	order_id,
	quantity
HAVING  COUNT(*)>1
ORDER BY order_id;


SELECT * FROM order_details WHERE order_id=10990;


WITH dublicates_entries AS(

SELECT	
	order_id,
	quantity
FROM order_details
WHERE 
	quantity>60
GROUP BY 
	order_id,
	quantity
HAVING  COUNT(*)>1
ORDER BY order_id

)
SELECT 
*
FROM order_details
WHERE order_id IN(SELECT order_id FROM dublicates_entries)


-- List employees with late shipped orders

late_orders
	employee_id,
	count(*)
	
all_orders
	employee_id
	count(*)

select
	JOIN...
	
-----

WITH late_orders AS 
(
	SELECT 
		employee_id,
		COUNT(*) AS total_late_orders
	FROM orders
	WHERE 
		shipped_date> required_date
	GROUP BY
		employee_id
),
all_orders AS
(
	SELECT
		employee_id,
		COUNT(*) AS total_orders
	FROM orders
	GROUP BY
		employee_id
)
SELECT
	e.employee_id,
	e.first_name,
	ao.total_orders,
	lo.total_late_orders
FROM employees e 
JOIN all_orders ao ON ao.employee_id=e.employee_id
JOIN late_orders lo ON lo.employee_id=e.employee_id;


-- Countries with customers or suppliers

SELECT
	country
FROM customers

UNION

SELECT
	country
FROM suppliers
ORDER BY country;

-- 25 records


SELECT
	DISTINCT(country)
FROM customers

UNION ALL

SELECT
	DISTINCT(country)
FROM suppliers
ORDER BY country;


-- Countries with customers or suppli
-- Using CTE

WITH
(
	countries_suppliers
),
(
	
	countries_customers
)
SELECT
...
FROM
FULL JOIN


---

WITH countries_suppliers AS(
	SELECT
		DISTINCT country
	FROM suppliers
),
countries_customers AS(
	SELECT
		DISTINCT country
	FROM customers
)
SELECT
	cs.country as country_supplier,
	cc.country as country_customer
FROM countries_suppliers cs
FULL JOIN countries_customers cc ON cs.country=cc.country