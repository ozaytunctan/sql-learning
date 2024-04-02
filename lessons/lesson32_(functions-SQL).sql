-- POSTGRESQL as a development platform ?
/*

Why anyone should chose the POSTGRESQL a s ad development platform ?

Cost of acquisition
-----------------------

Oracle              Free edition -> enterprise sales -> licesing cost

MICROSOFT SQL       Visible prices but with variant based on your database size/design etc.

Open-Source         No licensing
					No service contract cost

MY-SQL           --Very hard cost of aquisition to beat             
POSTGRESQL



*/



-- Procedural languages
--##############################3

/*

	1. Procedural languages allows us to do server programing
	
	2. Procedural languages see dataabse as 'data buckets'
	
	3. POSTGRESQL is capable of executing server-side code
	
	4. The user can create function in following build-in programing languages
	
		- SQL
		- PL/pgSQL
		- C (Very advance!)
	5. Additional language support are;
		-PL/Pyhton
		-PL/Perl
		-pl/TCL
		-pl/JAVA
		-
		
	6. The language can be added or removed  from a running version of POSTGRESQL
	
	7. Any function defined using the above language can also be create or dropped while POSTGRESQL is running !
	
	*/
	
	
	
	-- Function ve Procedures
	--#####################################
/*
	1. the term stored procedure has traditionaly been used to actualy talk about a function.
	
	2. A function is a;
		- normal SQL statement
		- not allowed to start or commit transaction
		
		e.g
		
		SELECT myfunct(id) from large_table;
		
		- If we call myfunc(id) 10 millions times with 'COMMINT' ?
		- It is imposible to simply end a transaction in the middle of a query and launch new one
		The entire concept of transactional integrity , consistency , and so on will be violated.
	
	3. A procedure is;
	
	- able to control transactions and
	- even run  multiple transactions one after the other.
	- You cannot run it inside a SELECT statement  , you have to CALL it
	
	CALL procedure_name 
	
	5. Function are around guite some time , but procedures were introduced in POSTGRESQL 11 onwards.
	

*/


-- user -defined functions
--##################33
--min ,max etc



-- Structure of a function
--#################################

--A function is defined with the following command structure;

CREATE FUNCTION function_name (p1 type, p2 type , p3 type ...... , pn type)
RETURNS return_type AS

BEGIN

--function logic

END;

LANGUAGE language_name

/*

  CREATE FUNCTION 		Specify the name of the function after the CREATE FUNCTION keyword
  p1 type ...  			Make a list of parameters seperated by commas..
  RETURNS 				Specify the return data type after RETURNS keywords.
  
  BEGIN .. END			For the PL/Pgsql language , put some code between the BEGIN and END block
  
  language name 		Define the language in which the function was written -
  						for example any one of the following , say
						
						-sql
						-plpgsql
						-plperl
						-plpyhton
						....

*/



-- SQL Functions
--##################################

/*

	1. SQL functions are the easiest way to write functions in POSTGRESQL
	
	2. We can use any SQL inside them.

*/

--Syntax

CREATE OR REPLACE FUNCTION function_name() 
RETURNS void AS
'
--SQL COMMAND

'
LANGUAGE SQL



CREATE OR REPLACE FUNCTION fn_mysum(int, int)
RETURNS int AS

'
SELECT $1 + $2 
'
LANGUAGE SQL


CALL procedure_name();

select fn_mysum(3,2),fn_mysum(30,20);



--- Introducing dollar quoting
---########################

CREATE OR REPLACE FUNCTION fn_mysum(int ,int)
RETURNS int AS

$$

	SELECT $1 + $2

$$
LANGUAGE SQL

select fn_mysum(3,2),fn_mysum(30,20);

$$ process ID- perl/bash

$$ .   $body$


CREATE OR REPLACE FUNCTION fn_mysum(int ,int)
RETURNS int AS

$body$

	SELECT $1 + $2

$body$
LANGUAGE SQL



-- Function returning no values
--############################

--RETURNS void

--nortwind database

SELECT * FROM employees;

contry - 'N/A'

CREATE OR REPLACE FUNCTION fn_employees_update_country()
RETURNS void AS

$$
	UPDATE employees 
	SET country='N/A'
	WHERE country IS NULL

$$
LANGUAGE SQL

SELECT fn_employees_update_country();


UPDATE employees 
SET country= 'USA'
WHERE employee_id=1



-- Function returning single value
--#######################

--RETURNS return_type

CREATE OR REPLACE FUNCTION function_name ()
RETURN return_type AS

$$

-- SQL command

$$

LANGUAGE SQL



-- 1. Get the minimum price of product

SELECT * FROM products
ORDER BY unit_price;

--MIN(unit_price)

CREATE OR REPLACE FUNCTION fn_product_min_price()
RETURNS real AS
$$

	SELECT
	MIN(unit_price)
	FROM products

$$
LANGUAGE SQL


select fn_product_min_price();


-- 2. Get the maximum price of product
----MAX(unit_price)


CREATE OR REPLACE FUNCTION fn_product_max_price()
RETURNS real AS
$$

	SELECT
	MAX(unit_price)
	FROM products

$$
LANGUAGE SQL


select fn_product_max_price();



-- 3. Get the biggest orrer even placed

SELECT * FROM order_details;

-- unit_price * quantity = total_amount

CREATE OR REPLACE FUNCTION fn_biggest_order()
RETURNS double precision AS

$$
	SELECT 
	MAX(amount)
	FROM(
		SELECT 
		order_id,
		SUM(unit_price * quantity) as amount
		FROM order_details
		GROUP BY order_id
		ORDER BY 2 DESC
	) as total_amount
	
	--LIMIT 1

$$
LANGUAGE SQL

SELECT fn_biggest_order();



CREATE OR REPLACE FUNCTION fn_smallest_order()
RETURNS double precision AS

$$
	SELECT 
	MIN(amount)
	FROM(
		SELECT 
		order_id,
		SUM(unit_price * quantity) as amount
		FROM order_details
		GROUP BY order_id
		ORDER BY 2 DESC
	) as total_amount

$$
LANGUAGE SQL

SELECT fn_smallest_order();


------

--Get total count of customers

SELECT count(*) FROM customers

CREATE OR REPLACE FUNCTION fn_api_get_total_customers()
RETURNS bigint AS

$$

	SELECT count(*) FROM customers

$$
LANGUAGE SQL;

SELECT fn_api_get_total_customers ();


--Get total count of products

SELECT count(*) FROM products

CREATE OR REPLACE FUNCTION fn_api_get_total_products()
RETURNS bigint AS

$$

	SELECT count(*) FROM products

$$
LANGUAGE SQL;

SELECT fn_api_get_total_products();


--Get total count orders

SELECT * FROM orders

SELECT COUNT(*) from orders;


CREATE OR REPLACE FUNCTION fn_api_get_total_orders()
RETURNS bigint AS

$$

	SELECT COUNT(*) from orders

$$
LANGUAGE SQL;

select fn_api_get_total_orders();

--	Get total customers with empty fax number 
-- fn_api_total_customers_empty_fax

select * from customers;



CREATE OR REPLACE FUNCTION fn_api_total_customers_empty_fax()
RETURNS bigint AS

$$

SELECT
COUNT(*)
FROM customers 
WHERE fax is null

$$
LANGUAGE SQL;


select fn_api_total_customers_empty_fax();





--	Get total customers with empty region
-- fn_api_total_customers_empty_region


CREATE OR REPLACE FUNCTION fn_api_total_customers_empty_region()
RETURNS bigint AS

$$

SELECT
COUNT(*)
FROM customers 
WHERE region is null

$$
LANGUAGE SQL;


select fn_api_total_customers_empty_region();

--Function using parameters
--###################3

-- p1 type,p2 type ....

CREATE OR REPLACE FUNCTION function_name(p1 type,p2 type ...)
RETURNS return_type AS

$$


$$
LANGUAGE language_name


-- Function parameters/arguments can be passed and accessed by name , instead of just by the ordinal order ($1, $2 ....)
-- This makes the code much better for readability

CREATE OR REPLACE FUNCTION function_name(p1 type,p2 type ...)RETURNS return_type AS
$$

$1, $2

$$
LANGUAGE language_name

CREATE OR REPLACE FUNCTION function_name(p1 type,p2 type ...) RETURNS return_type AS
$$

p1, p2

$$
LANGUAGE language_name


CREATE OR REPLACE FUNCTION function_name(customer_id  bpchar,p2 type ...)RETURNS return_type AS
$$

customer_id=customer_id

$$
LANGUAGE language_name ;


-- 1. Lets create a mid function with input parameters like string and starting_point

CREATE OR REPLACE FUNCTION fn_mid(p_string varchar, p_starting_point integer)
RETURNS varchar AS

$$

SELECT substring(p_string,p_starting_point)

$$
LANGUAGE SQL;

SELECT fn_mid('Mis Eylül Adam',4);



-- 2. Get total customer by city
-- parameter  	: p_city
--output        : number / bigint

SELECT * FROM customers;

CREATE OR REPLACE FUNCTION fn_api_get_total_customers_by_city(p_city varchar)
RETURNS bigint AS

$$
	SELECT count(*)
	FROM customers
		WHERE city=p_city

$$
LANGUAGE SQL;

SELECT fn_api_get_total_customers_by_city('London');


-- 2. Get total customer by country


CREATE OR REPLACE FUNCTION fn_api_get_total_customers_by_country(p_country varchar)
RETURNS bigint AS

$$
	SELECT count(*)
	FROM customers
		WHERE country=p_country

$$
LANGUAGE SQL;

SELECT fn_api_get_total_customers_by_country('USA'),
       fn_api_get_total_customers_by_country('N/A'),
	   fn_api_get_total_customers_by_country('UK')
	   
	   
-- 4. Get total orders by a customer
-- fn_api_customer_total_orders

-- input : p_customer_id bpchar
	   
SELECT 
count(*)
FROM orders 
NATURAL JOIN customers
WHERE customer_id='VINET'
	   
CREATE OR REPLACE FUNCTION fn_api_customer_total_orders(p_customer_id bpchar) 
RETURNS bigint AS

$$

	SELECT 
		count(*)
	FROM orders 
	NATURAL JOIN customers
	WHERE
		customer_id=p_customer_id

$$
LANGUAGE SQL


SELECT fn_api_customer_total_orders('VINET'),
	   fn_api_customer_total_orders('BERGES');
	   

-- Function with parameters
--##############################

--Get the biggest order amount placed by a customer 
-- fn_api_customer_largest_order
-- input : p_customer_id
-- total_amount

SELECT
orders.order_id,
orders.customer_id,

products.product_name,

order_details.unit_price,
order_details.quantity,
(order_details.unit_price* order_details.quantity) - order_details.discount AS total_amount

FROM orders
NATURAL JOIN order_details
NATURAL JOIN products
WHERE orders.customer_id='ALFKI'
ORDER BY 1
	   
SELECT * from customers;   
	   
	   
CREATE OR REPLACE FUNCTION fn_api_customer_largest_order(p_customer_id bpchar)	  
RETURNS double precision AS

$$
 SELECT
   	MAX(total_amount)
 FROM(
		SELECT
			orders.order_id,
			SUM( (unit_price* quantity) - discount) AS total_amount
		FROM order_details
		NATURAL JOIN orders
		WHERE 
			orders.customer_id=p_customer_id
		GROUP BY orders.order_id
		ORDER BY 1
 ) AS total_amount

$$
LANGUAGE SQL
	   

SELECT fn_api_customer_largest_order('ALFKI')
	   
	   
-- Get most ordered product by customer
-- fin_api_customer_most_ordered_product

SELECT
orders.order_id,
orders.customer_id,

products.product_name,

order_details.unit_price,
order_details.quantity,
order_details.quantity

FROM orders
NATURAL JOIN order_details
NATURAL JOIN products
WHERE orders.customer_id='CACTU'
ORDER BY 1 DESC


CREATE OR REPLACE FUNCTION fin_api_customer_most_ordered_product(p_customer_id bpchar)
RETURNS varchar AS

$$

 SELECT 
 	product_name
 FROM products
 WHERE
 	product_id
	IN(
	SELECT 
	product_id
	FROM(
		SELECT
			product_id,
			SUM(quantity) as total_quantity
		FROM order_details
		NATURAL JOIN orders 
		WHERE orders.customer_id=p_customer_id
		GROUP BY product_id
		ORDER BY 2 DESC
		LIMIT 1
	 ) AS product_order
		)

$$
LANGUAGE SQL


SELECT fin_api_customer_most_ordered_product('CACTU');


--Function returning a composite
--##########################################
-- RETURNS table_name

-- Returns a single row , int he form of an array style


--Most recent order

CREATE OR REPLACE FUNCTION fn_api_order_latest()
RETURNS orders AS
$$

SELECT
*
FROM orders 
ORDER BY order_date DESC, order_id DESC
LIMIT 1

$$
LANGUAGE SQL


SELECT  fn_api_order_latest();

SELECT  (fn_api_order_latest()).*;

--(fn_name()).field_name
SELECT  (fn_api_order_latest()).order_id;

SELECT  * from fn_api_order_latest();


-- Most recent order between date range

CREATE OR REPLACE FUNCTION fn_api_order_largest_by_date_range(p_from date,p_to date)
RETURNS orders AS

$$

	SELECT
		*
	FROM orders
	WHERE 
		order_date BETWEEN p_from AND p_to
	ORDER BY order_date DESC, order_id DESC
	LIMIT 1

$$
LANGUAGE SQL;

SELECT fn_api_order_largest_by_date_range('1997-01-01','2020-10-10');

SELECT (fn_api_order_largest_by_date_range('1997-01-01','2020-10-10')).*;

select * from fn_api_order_largest_by_date_range('1997-01-01','2020-10-10');


-- Most recent hire

CREATE OR REPLACE FUNCTION fn_api_amployees_latest_hire()
RETURNS employees AS
$$

	SELECT
		*
    FROM employees
	ORDER BY hire_date DESC
	LIMIT 1
$$
LANGUAGE SQL;

SELECT * from fn_api_amployees_latest_hire();


-- Functions returning multiple rows
--###########################

/*

	RETURNS ROWS

*/

-- List all employees hire in a particualry year
-- fn_api_employees_hire_date_by_year

CREATE OR REPLACE FUNCTION fn_api_employees_hire_date_by_year(p_year integer)
RETURNS SETOF employees AS
$$

	SELECT
		*
	FROM employees
	WHERE
		EXTRACT('YEAR' FROM hire_date) =p_year

$$
LANGUAGE SQL


SELECT  * FROM fn_api_employees_hire_date_by_year(1992)

-- List all products where total order amount is greather then an input amount
-- fn_api_products_total_amount_by

CREATE OR REPLACE FUNCTION fn_api_products_total_amount_by(p_amount integer)
RETURNS SETOF products AS
$$
	SELECT
	 * 
	 FROM products
	 WHERE
	 	product_id
		  IN(
		     SELECT
				 product_id
				 FROM(
					SELECT
					 product_id,
					 SUM ( (unit_price*quantity) -discount) as product_total_sale

					FROM order_details
					GROUP BY product_id
					HAVING SUM ( (unit_price*quantity) -discount)>p_amount
			 ) t1
		 )
$$
LANGUAGE SQL


SELECT * FROM fn_api_products_total_amount_by(100000)


--- Function as table source
--########################

/*

	- We can use functions as table source i.e
	
	SELECT
		column_list
	FROM function_name();

*/
-- fn_api_employees_hire_date_by_year
-- fn_api_products_total_amount_by

--LESSON: 425


SELECT function_name();

SELECT (fn_api_employees_hire_date_by_year('1992')).*

SELECT 
first_name,
last_name,
hire_date
FROM fn_api_employees_hire_date_by_year('1992');


-- Functions - Order matters
--######################

-- RETURNS TABLE (col type,col2 type , ...)


CREATE OR REPLACE FUNCTION fn_api_customer_top_orders(p_customer_id bpchar, p_limit integer)
 RETURNS TABLE
 (
    order_id smallint,
	customer_id bpchar,
    product_name varchar,
	unit_price real,
	quantity smallint,
	total_order double precision
 )
 AS
 
 $$
 
 	SELECT 
		o.order_id,
		o.customer_id,
		
		p.product_name,
		
        od.unit_price,
		od.quantity,
		
		(( od.unit_price*od.quantity)-od.discount ) as total_order
		
	FROM order_details od
	NATURAL JOIN orders o
	NATURAL JOIN products p
	WHERE o.customer_id=p_customer_id
	ORDER BY 6 DESC
	LIMIT p_limit
 
 $$
 LANGUAGE SQL


DROP FUNCTION fn_api_customer_top_orders

SELECT * FROM fn_api_customer_top_orders('VINET',20);

--Functions parameters with default values 
--#############################

CREATE OR REPLACE FUNCTION function_name(p1 type DEFAULT v1, p2 type DEfAULT v2 )

--Lets do sum of three numbers

CREATE OR REPLACE FUNCTION fn_sum_three(x int , y int DEFAULT 10, z int DEFAULT 10)
RETURNS integer AS
$$

	SELECT x + y + z ;

$$
LANGUAGE SQL;

DROP FUNCTION fn_sum_three;

SELECT fn_sum_three(1,2,3);

SELECT fn_sum_three(1,2);

SELECT fn_sum_three(1);


-- Lets set a new pricing with a 7% increase

SELECT 
    unit_price,
	unit_price * 107 /100
FROM products;


CREATE OR REPLACE FUNCTION fn_api_new_price(products, percentage_increase numeric DEFAULT 107)
RETURNS double precision AS
$$

SELECT $1.unit_price * percentage_increase /100 ;

$$
LANGUAGE SQL



SELECT 
	product_id,
	product_name,
	unit_price,
	fn_api_new_price(products.*) as new_price
FROM products



--Function based on views
--###################################

SELECT * FROM pg_stat_activity where state='active'

CREATE OR REPLACE VIEW v_active_queries AS

SELECT 
	
	pid,
	usename,
	query_start,
	(CURRENT_TIMESTAMP -query_start) as runtime,
    query
FROM pg_stat_activity 
WHERE
	state='active'
ORDER BY 4 DESC


--input p_limit 

CREATE OR REPLACE FUNCTION fn_internal_active_queries(p_limit int)
RETURNS SETOF v_active_queries AS
$$

 SELECT
 *
 FROM v_active_queries
 LIMIT p_limit
	

$$
LANGUAGE SQL


SELECT * FROM fn_internal_active_queries(10)


-- Drop a function
--##############################

DROP FUNCTION [IF EXISTS] function_name(argument_list) [cascade |restrict];

/*

function_name        try to keep the name unique GLOBALLY !!!

if exists 			Issue a notice instead of an error in case the function does not exist

argument_list        $ince functions can be overloaded , POSTGRESQL needs to know which function you want to remove by
					checking the argument list
					
cascade 			To 	drop the function and its dependent objects (BE CAREFUL)

restrict 			Rejects the removal of a fucntion  when it has any dependent objcets



*/


CREATE OR REPLACE FUNCTION fn_sum(x int, y int)
RETURNS int AS

$$

	SELECT x + y ;

$$
LANGUAGE SQL


SELECT fn_sum(1,2);

DROP FUNCTION fn_sum





