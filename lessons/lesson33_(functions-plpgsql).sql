-- Introduction to PL/pgSQL language
--#########################################

/*

	1. PL/pgSQL is a powerful SQL scripting language that is heavily influenced by ORACLE PL/SQL
	
	2. PL/pgSQL is a full-fledged SQL development language
	
	3. Originally designed for simple scaler functions, and now providing
		
		- Full PostgreSQL internals,
		- Control structure
		- Variable declaration
		- Expression
		- Loops 
		- Cursors and much more
		
	4. Ability tp create
		
		- complex function
		- new data types
		- stored procedures and more ..
		
	5. It is easy to use
	
	6. Available by default on PostgreSQL
	
	7. Optimized for performance of data intensive tasks
	

*/



-- PL/pgSQL vs SQL
--###############################

/**

	- SQL is a query language , but con only excute SQL statement INDIVIDUALY
	
	- PL/pgSQL will;
		
		- wrap multiple statements in an OBEJCT
		
		- store that object on the server
		
		- instead of sending multiple statements on the server one by one,
		  we can send one statement to execute the 'object' stored in the server
		  
        -reduced round trips to server for each statement to execute
		  
		- provide transactional integrity and much more..


*/


--Structure of a PL/pgSQL function
--#################################

--Very similar to SQL function

CREATE FUNCTION function_name(p1 type, p2 type ...)
RETURNS return_type AS

$$

	BEGIN
	
	--statements
	
	END

$$
LANGUAGE plpgsql


--SQL vs PL/pgSQL

SELECT x;

RETURN x;

-- Lets get the max price of all products

CREATE OR REPLACE FUNCTION fn_api_products_max_price()
RETURNS bigint AS
$$
	BEGIN
	
		RETURN MAX(unit_price)
		FROM products;
	
	END;

$$
LANGUAGE plpgsql;

SELECT fn_api_products_max_price();



-- PL/pgSQL Block Structure
--##################################################

/**

	1. PL/PgSQL function or stored procedure is organized into bloks
	
	2. Block structure syntax
		
		[<<lable>>]
		[ DECLARE
			declarations ]
			BEGIN
			
			statement;
			
			END; [label];
			


*/


-- Declaring variables
--##########################################

/*

	1. A variable holds a value that can be changed through the block
	
	2. Before using a variable , you must declare it in the declaration section
	
*/

DECLARE 
	variable_name data_type [:* expression]
	
	...
BEGIN
	...
END;

-- expression 			- optionaly assing a default value to a variable

-- e.g

DECLARE
	mynum 			integer:=1 ;
	first_name		varchar(100):='Adnan';
	hire_date 		date:='2020-01-01';
	start_time  	timestamp :=NOW();
	emptyvar		integer;
	
BEGIN
	...
END;

-- Lets take on an example of declare and initialize variables
-- we will use block structure
	
DO
$$

	DECLARE
		mynum 			integer:=1 ;
		first_name		varchar(100):='Adnan';
		hire_date 		date:='2020-01-01';
		start_time  	timestamp :=NOW();
		emptyvar		integer;
		var1 			integer :=10;
	BEGIN
	RAISE NOTICE 'My variable % % % % % %',
	mynum,
	first_name,
	hire_date,
	start_time,
	emptyvar,
	var1;
	
	END;
$$
		
-- Declaring variables with ALIAS
--##############################################

newname ALIAS FOR oldname;

CREATE OR REPLACE FUNCTION function_name(int,int)
RETURNS int AS
$$
	DECLARE
		x ALIAS FOR $1;
		y ALIAS FOR $2;
	BEGIN
		...
	END;
$$
LANGUAGE plpgsql;

-- using position numbers $1, $2 ...

CREATE OR REPLACE FUNCTION fn_my_sum(integer,integer)
RETURNS integer AS
$BODY$
	DECLARE
		ret integer;
	BEGIN
		ret:= $1 + $2;
		
		RETURN ret;
	END
$BODY$
LANGUAGE plpgsql;

--example call function
SELECT fn_my_sum(1,2);


--Declaring variables via alias;

CREATE OR REPLACE FUNCTION fn_my_sum(integer,integer)
RETURNS integer AS
$BODY$
	DECLARE
		x ALIAS FOR $1; --parametre 1 x atamak için
		y ALIAS FOR $2; --parametre 2 y atamak için
		ret integer; -- dönüş değeri ataması yapılacak değişken
		
	BEGIN
		ret:= x + y;
		
		RETURN ret;
	END
$BODY$
LANGUAGE plpgsql;


SELECT fn_my_sum(1,20);


-- Variable initialization timing
--#################################

DO
$$
	DECLARE
		start_time time :=NOW();
	BEGIN 
	
	RAISE NOTICE 'Starting at : %' , start_time;
	PERFORM pg_sleep(2);
	RAISE NOTICE 'Next at : %' , start_time;
	
	END;
$$
LANGUAGE plpgsql;


-- Copying daat types
--###########################

/*

	%TYPE 	 	refers to data type of a stable column or another variable
	
	variable_name table_name.column_nametype;

*/

DO
$$
	DECLARE
		variable_name table_name.column_name%TYPE;
		
		empl_first_name employees.first_name%TYPE; -- Tabloda alanın tipine değişkene vermek için
		
		product_name products.product_name%TYPE;
		
	BEGIN
	
	
	END;
$$
LANGUAGE plpgsql


-- Assigning variable from query
--############################33

SELECT expression INTO variable_name

-- Must return only a single result

-- some example here

SELECT * from products    INTO product_row LIMIT 1;

SELECT product_row.product_name INTO product_name ; 


-- Lets return the name of the product for a particular product id

DO
$$
	DECLARE
		product_title products.product_name%TYPE;
	BEGIN
		SELECT
			product_name INTO product_title
		FROM products
	         
		WHERE product_id=1
		LIMIT 1;
		
		RAISE NOTICE 'Your product name is %', product_title;
	END;
$$

-----

DO 
$$
	DECLARE
		row_record record;
	BEGIN
	
	
		SELECT
			* 
		FROM products
	    INTO row_record
		
		WHERE product_id=1
		LIMIT 1;
		
		RAISE NOTICE 'Your product name is %', row_record.product_name;
	
	END;
$$


-- Using IN, OUT without RETURNS
--############################

CREATE OR REPLACE FUNCTION function_name() 
RETURNS return_type AS

-- we used the RETURNS clause in the first row of the fdunction definition , however we can IN ,OUT ,INOUT
-- parameters modes

IN	variable_name type;
OUT variable_name type;
INOUT variable_name type;

--Lets create a function to calculate a sum of three integers

CREATE OR REPLACE FUNCTION fn_my_sum_2_par( IN x integer, IN y integer , OUT z integer) 
AS
$$
	BEGIN
	
	z := x + y;
	
	END;
$$
LANGUAGE plpgsql;


select fn_my_sum_2_par(10,2);



CREATE OR REPLACE FUNCTION fn_my_sum_2_par1( IN x integer, IN y integer ,OUT w integer, OUT z integer) 
AS
$$
	BEGIN
	
	z := x + y;
	w := x + y;
	
	END;
$$
LANGUAGE plpgsql;

select * from fn_my_sum_2_par1(10,2);


-- Variables in block and subblock
--#######################################

-- Block nesting

/*

	block_1
	
		DECLARE
			v1 int ;
		BEGIN
		
			block_2
			DECLARE
				v2 integer;
			BEGIN 
			
			END;
		END;
   		
*/

-- to refrence a variable we will use

block_name ,variable_name 

DO
$$
	<<PARENT>>
	
	DECLARE 
		counter integer :=0;
	BEGIN
		counter :=counter+1;
		RAISE NOTICE 'THE CURRENT VALUE OF COUNTER IS %', counter;
		
		-- Another block
		DECLARE 
			counter integer :=0;
		BEGIN
			counter :=counter+5;
			
			RAISE NOTICE 'THE CURRENT VALUE OF COUNTER SUBBLOCK IS %', counter;
			RAISE NOTICE 'THE CURRENT VALUE OF COUNTER at BLOCK_1  IS %', PARENT.counter;


		END;
	END;
$$



--- How to return query results
--#########################################
--Lesson:444

CREATE OR REPLACE FUNCTION function_name()
RETURNS SETOF table_name AS
$$
	BEGIN
	
		RETURN QUERY 
		SELECT ....
	
	END
$$
LANGUAGE plpgsql;


--TOP 10 orders by order_date 

SELECT * FROM orders ORDER BY order_date DESC;

CREATE OR REPLACE FUNCTION fn_api_orders_latest_top_10_orders()
RETURNS SETOF orders AS
$$
	BEGIN
	
		RETURN QUERY
		   SELECT
		    *
		   FROM orders
		   ORDER BY order_date DESC
	       LIMIT 10;
	END;

$$
LANGUAGE plpgsql;

SELECT * from fn_api_orders_latest_top_10_orders();

SELECT * from fn_api_orders_latest_top_10_orders()
WHERE customer_id='RATTC';


-- Control structures
-- ####################################

/*

	- Conditional statements
	- Loop statements
	- Exception handler statement
	
Conditional statements
--------------------------------

	- IF
	
	- CASE

*/

IF
END IF;

IF THEN
IF THEN ELSE
IF THEN ELSEIF

IF boolean-expression THEN
	--statement
END IF;

IF expression THEN
	--statement
[ELSEIF expression] THEN
	--statement
[ELSEIF expression] THEN
	--statement
....
ELSE
	--statement
END IF;

---

IF expression THEN
	statement 1...
ELSE
	statement..2

END IF;

CREATE OR REPLACE FUNCTION fn_my_check( x integer default 0, y integer default 0)
RETURNS text AS
$$
	BEGIN
		IF x>y THEN
			RETURN 'x>y';
		ELSEIF x=y THEN
			RETURN 'x=y';
		ELSE
			RETURN 'x<y';
		END IF;
	END;
$$
LANGUAGE plpgsql;

SELECT fn_my_check();
SELECT fn_my_check(1,2);
SELECT fn_my_check(20,5);




-- Using IF with table data
--###########################################

SELECT * FROM products order by unit_price DESC;

price> 50	: High
price>25	:Medium
sweet spot


CREATE OR REPLACE FUNCTION fn_api_products_category(price real)
RETURNS text AS

$$
	BEGIN
		IF price>50 THEN
			RETURN 'HIGH';
		ELSEIF price>25 THEN
			RETURN 'MEDIUM';
		ELSE
			RETURN 'SWEET_SPOT';
		END IF;
	END;
$$
LANGUAGE PLPGSQL;


SELECT 
unit_price,fn_api_products_category(unit_price)
FROM products
ORDER BY 2 DESC;


-- CASE statement
-- #############################################

/*

simple 			if we have to make a choice from a LIST of values (1,2,3,4)

searched         we have to choose from a RANGE of values (1....10)

*/

CASE condition
	WHEN THEN
		RETURN;

END CASE;



CASE search-expression
	WHEN expression, [,expression [....]] THEN
		--statement
	WHEN expression, [,expression [....]] THEN
		--statement
	ELSE
		--statement
END CASE;

---
CREATE OR REPLACE FUNCTION fn_my_check_value(x integer default 0)
RETURNS text AS
$$
	BEGIN
		CASE x
			WHEN 10 THEN
				RETURN 'VALUE = 10';
			WHEN 20 THEN
				RETURN 'VALUE = 20';
			ELSE
			RETURN 'No values found , returning input value x';
		END CASE;
	END;
$$
LANGUAGE PLPGSQL;



SELECT fn_my_check_value();
SELECT fn_my_check_value(10);
SELECT fn_my_check_value(20);
SELECT fn_my_check_value(30);


SELECT distinct(ship_via) FROM orders;

SELECT * FROM shippers;

1- Speedy
2- United
3- Federal

CREATE OR REPLACE FUNCTION fn_api_order_ship_via(ship_via smallint)
RETURNS text AS
$$
	BEGIN
		CASE ship_via
			WHEN 1 THEN
				RETURN 'SPEEDY';
			WHEN 2 THEN
				RETURN 'UNITED';
			WHEN 3 THEN
				RETURN 'FEDERAL';
			ELSE
				RETURN 'UNKNOWN';
		END CASE;
	END;
$$
LANGUAGE PLPGSQL;

-----

SELECT fn_api_order_ship_via(ship_via),*
FROM orders;


-- Searched CASE statement 
-- #########################################
1,2,3,4 ..


SELECT * FROM order_details;

10248

total amount> 200 -- Platimum
total amount> 100 -- Gold
Silver;

DO
$$
    DECLARE 
		total_amount numeric;
		order_type varchar(50);
		
	BEGIN
		
		SELECT 
		 SUM((unit_price * quantity)-discount) INTO total_amount
		FROM order_details
		
		WHERE 
			order_id=10248;
			
		IF found THEN
			CASE 
				WHEN total_amount>200 THEN
					order_type='PLANTINIUM';
				WHEN total_amount>100 THEN
					order_type='GOLD';
				ELSE
				order_type='SILVER';
			END CASE;
			RAISE NOTICE 'Order Amount , Order Type % %',total_amount,order_type;
		ELSE
			RAISE NOTICE 'No order was found';
		END IF;
	END;
$$
LANGUAGE PLPGSQL;



-- Loop Statement 
--##############################

LOOP
	--statement
	EXIT;
END LOOP;


LOOP
	--statement
	EXIT CASE WHEN conditiom
END LOOP;


LOOP
	statement
	IF condition THEN
		EXIT;
	END IF;
END LOOP;


DO
$$
	DECLARE
		i_counter integer=0; -- Değişken tanımladık.
	BEGIN -- başla
		LOOP -- döngü
		
		RAISE NOTICE '%',i_counter; -- yazdırma
		i_counter:=i_counter + 1;
		
		EXIT WHEN i_counter=5 ; -- döngü bitirmek için
		END LOOP;
	
	END;
$$
LANGUAGE PLPGSQL;


-- end of a loop
EXIT;
EXIT WHEN _condition;

-- skip
CONTINUE;
CONTINUE WHEN _condition;



-- FOR Loops
--########################

FOR [counter name] IN [REVERSE] [START VALUE] ... [END VALUE] [BY stepping]
LOOP
	[statements]; -- [] isteğe bağlı
END LOOP;


DO
$$
	BEGIN
		FOR counter IN 1..10 --BY 2
		LOOP
			RAISE NOTICE 'counter : %',counter;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;


DO
$$
	BEGIN
		FOR counter IN REVERSE 10..1 --BY 2
		LOOP
			RAISE NOTICE 'counter : %',counter;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;

--- stepping 

DO
$$
	BEGIN
		FOR counter IN  1..10 BY 5
		LOOP
			RAISE NOTICE 'counter : %',counter;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;


-- FOR Loops iterator over result set
--#########################################

FOR target IN your_select_statement
LOOP
	  --statements
END LOOP;


DO
$$
	DECLARE 
		r_item record; -- record variable
	BEGIN
		FOR r_item IN 
				SELECT order_id ,customer_id FROM orders LIMIT 10 -- sorgu
		LOOP
			RAISE NOTICE '{ order_id: % ,customer_id: % }',r_item.order_id, r_item.customer_id;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;
	

-- CONTTINUE statement
-- ##################################

CONTINUE [loop_label] [WHEN condition];

--Lets print odd numbers only from 1 to 20;


DO
$$
	DECLARE
		i_counter integer =0;
	BEGIN
		LOOP
			i_counter := i_counter + 1;
			EXIT WHEN i_counter>20;
			CONTINUE WHEN MOD(i_counter,2)=1;
			RAISE NOTICE '%',i_counter;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;


-- FOREACH loop with arrays
--###################################

FOREACH var IN ARRAY array_name;
LOOP
	statements;
END LOOP;


DO
$$
	DECLARE
		arr1 int[] := array[1,2,3,4,5];
		arr2 int[] := array[6,7,8,9,10];
		var int;
	BEGIN
		FOREACH var IN ARRAY arr1 || arr2
		LOOP
			RAISE NOTICE '%' , var;
		END LOOP;
	END;
$$
LANGUAGE PLPGSQL;


-- WHILE loops
-- #########################################

WHILE your_condition
LOOP

END LOOP;

CREATE OR REPLACE FUNCTION fn_while_loop_sum_all(x integer )
RETURNS numeric AS
$$
	DECLARE 
		counter integer :=1;
		sum_all integer :=0;
	BEGIN
		WHILE counter<=x
		LOOP
			sum_all :=sum_all + counter;
			counter :=counter+1;
		END LOOP;
		RETURN sum_all;
	END;
$$
LANGUAGE PLPGSQL;

select fn_while_loop_sum_all(10);
select fn_while_loop_sum_all(5);
select fn_while_loop_sum_all(3);


-- table n

CREATE OR REPLACE FUNCTION fn_create_table_insert_values(x integer )
RETURNS boolean AS
$$
	DECLARE 
		counter integer :=1;
		done boolean    :=false;
	BEGIN
		-- create the table
		--EXECUTE format('
		--		CREATE TABLE IF NOT EXISTS 	t_table(id int)   
		--	');
		CREATE TABLE IF NOT EXISTS 	t_table(
			id int
		) ;  
	
		WHILE counter<=x
		LOOP
			-- insert some data
			INSERT INTO t_table(id) VALUES(counter);
			counter := counter + 1;
		END LOOP;
		done=true;
		RETURN done;
	END;
$$
LANGUAGE PLPGSQL;


SELECT fn_create_table_insert_values(20);

SELECT * FROM t_table;

--------------------------

-- Using RETURN QUERY

RETURN QUERY select_statement

>1500 

CREATE OR REPLACE FUNCTION fn_api_products_sold_more_than_val(p_total_Sale real)
RETURNS SETOF products AS
$$
	BEGIN
		RETURN QUERY
	 -- all columns from products
		-- product _id
		 -- total_amount for each orders
		 -- total_amount > p_total_sales
		SELECT
		*
		FROM products
		WHERE product_id IN
		(
			SELECT 
				d.product_id
			FROM order_details d 
			GROUP BY d.product_id
			HAVING SUM((d.unit_price * d.quantity)-d.discount)>p_total_Sale
		) ;
		
		--exceptions
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No products was found for total_sales > %' , p_total_Sale; 
		END IF;
	END;
$$
LANGUAGE PLPGSQL;


SELECT * FROM fn_api_products_sold_more_than_val(1000);
SELECT * FROM fn_api_products_sold_more_than_val(10000);
SELECT * FROM fn_api_products_sold_more_than_val(100000);
SELECT * FROM fn_api_products_sold_more_than_val(1000000); --exceptions



-- Returning a table 
--########################################

RETURNS TABLE ( column_list)


CREATE OR REPLACE FUNCTION fn_api_products_by_names(p_pattern varchar)
RETURNS TABLE(
	productname varchar,
	unitprice real
) AS
$$
	BEGIN
		RETURN QUERY
			SELECT
				product_name,
				unit_price
			FROM products
			WHERE 
				product_name LIKE p_pattern;
				
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No products was found for product_name pattern: %', p_pattern;
		END IF;
	END;
$$
LANGUAGE PLPGSQL;

DROP FUNCTION fn_api_products_by_names

SELECT * FROM fn_api_products_by_names('A%');
SELECT * FROM fn_api_products_by_names('Al%');
SELECT * FROM fn_api_products_by_names('AL%');


-- Using RETURN NEXT
-- #########################################

CREATE OR REPLACE FUNCTION function_name()
RETURN SETOF table_name AS
$$

	BEGIN
		...
		RETURN NEXT;
	
	END;
	RETURNS;
$$
LANGUAGE PLPGSQL;

-- Lets get all orders where unit_price> 10000

CREATE OR REPLACE FUNCTION fn_get_all_orders_greather_than()
RETURNS SETOF order_details AS
$$
	DECLARE
		r record;
		
	BEGIN
		FOR r IN SELECT * FROM order_details WHERE unit_price> 100
			
		LOOP
			RETURN NEXT r;
		END LOOP;
		
		RETURN;
	END;
	
$$
LANGUAGE PLPGSQL;


SELECT * FROM fn_get_all_orders_greather_than();


-- Lets create December pricing where we will set new unit_price based on a category_id


SELECT DISTINCT(category_id) FROM products
ORDER BY category_id ;


1,2,3 -- unit_price * 0.90

3,4,5 -- unit_price * 0.80

else
	
	unit_price * 1.20
	
CREATE OR REPLACE FUNCTION fn_api_products_new_dec_pricing()
RETURNS SETOF products AS
$$
	DECLARE
		r record; -- r products % row_type
		
	BEGIN
		FOR r IN 
			SELECT * FROM products
		LOOP
			CASE 
				WHEN r.category_id IN(1,2,3) THEN
				 	r.unit_price=r.unit_price * 0.90;
				WHEN r.category_id IN(4,5,6) THEN
					r.unit_price=r.unit_price * 0.80;
				ELSE
					r.unit_price=r.unit_price * 1.20;
			END CASE;
			RETURN NEXT r;
		END LOOP;
		RETURN;-- final döngüden çık
	END;
$$
LANGUAGE PLPGSQL;

--
SELECT * FROM fn_api_products_new_dec_pricing();

-- check id :1 -> 16.2
SELECT 18*0.90;

SELECT * FROM products where product_id=1;



--ERROR Handling
--##########################################
exception clause


BEGIN
	EXCEPTION ...
END

-------------------

DO
$$
	DECLARE 
		rec record;
		p_order_id smallint :=1;
	BEGIN
		SELECT
			customer_id,
			order_date
		FROM orders
		INTO  rec
		WHERE 
			order_id=p_order_id;
		--hata olursa yakala
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RAISE EXCEPTION 'No orderid was found %',p_order_id;
	END;
$$
LANGUAGE PLPGSQL;


-- Exception - Too many rows
-- ##############################################

too_many_rows


DO
$$
	DECLARE 
		rec record;
	BEGIN
		SELECT
			customer_id,
			company_name
		FROM customers
		INTO  rec
		WHERE company_name LIKE 'A%'
		LIMIT 1;
		-- hata olursa yakala
		EXCEPTION
			WHEN too_many_rows THEN
				RAISE EXCEPTION 'Your query returns too many rows';
	END;
$$
LANGUAGE PLPGSQL;


-- Using SQLSTATE codes for exception handling
-- ########################################

https://www.postgresql.org/docs/10/errcodes-appendix.html






