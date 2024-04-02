--- WINDOW FUNCTION
---##############################
/*
*
* Aggregates function                   take many rows and turn them into fewer aggregated rows
										flattend the data
										
 								
* A windowing function                  It compare the current row with all rows in the group    
*
*
*
*/
-- 
-- trades tablo sunu oluşturalım.
CREATE TABLE trades (
region VARCHAR(100), 
country VARCHAR(100),
year INTEGER,
imports numeric(16,2),
exports numeric(16,2)
)


--trades.sql dosyasındaki sql çalıştıralım.


-- Lets take averahe import

SELECT AVG(imports) from trades

--Lets parse the data with OVER clause

-- aggregate_function OVER (PARTITION BY group_name)

-- Lets wiew country , year , import ,exports and overall average exports

SELECT 
country , year , imports ,exports,
avg(exports) OVER() as avg_exports
from trades;

-- Partition  the data 
--#############################3

-- aggregate_function OVER (PARTITION BY group_name)

SELECT 
country , year , imports ,exports,
avg(exports) OVER() as avg_exports
from trades;

--Lets take averahe of the country
-- Ülke bazında exports data ortalamasını verir.

SELECT country , year , imports ,exports,
avg(exports) OVER( PARTITION BY country) as avg_exports
FROM trades;


-- Can we event filter data in PARTTION BY
--- 2000 den büyük ve küçük olan ortalamasını diğer satırlara alınmış oldu.
SELECT country , year , imports ,exports,
		avg(exports) OVER( PARTITION BY  year>=2000) as avg_exports
FROM trades;

--40314515851.24621594 LT
select  AVG(exports) from trades where year<2000
--81990553634.91364318 GT
select  AVG(exports) from trades where year>=2000


--- set data into millions format
--############################

select
imports,
ROUND(imports/1000000,2)
from trades ;

update trades SET
imports=ROUND(imports/1000000,2),
exports=ROUND(exports/1000000,2)

---
select * from trades;


-- Ordering inside windows
--#####################3
-- aggregate_function OVER (PARTITION BY group_name ORDER BY columns)

--Lets take a min exports for some specific countries for period 2001 onwards
-- Ülkelere göre yıl sıralmasına göre  en küçük olan exports datasını diğer kayıtlara getirir.
SELECT
country,
year,
exports,
min(exports) OVER( PARTITION BY country ORDER BY year)
FROM trades
WHERE 
year>2001
AND country IN('USA','France');

-- Sliding dynamic windows
--#####################################

moving average = current row, previous , next row
-- PENCERE aslında başlangıç ve bitiş aralığını belirler.

-- Ülke bazında ve yıl sıralamasında  kendinden önceki bir kayıt
-- ve kendinden sonra gelen 1 kayda göre 
-- en küçük exports datasını kayıtlara basar
-- Her satır için bu işlem tekrarlanır. current row -1 , current row , current_row+1 

SELECT
country,
year,
exports,
min(exports) OVER( PARTITION BY country ORDER BY year ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS avg_moving
--min(exports) OVER( PARTITION BY country ORDER BY year ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING EXCLUDE CURRENT ROW) AS avg_moving

FROM trades
WHERE 
year BETWEEN 2001 AND 2010
AND country IN('USA','France');


-- Understanding window frames
--- ##################################

/*

1. Window frames are used to indicate how many rows around the current row , the window function should include.


2. Specify window window frame via 

	ROWS OR RANGE                      indicators
	BETWEEN                            start of the frame and the and of the frame 
	
3. Window frame in window functions use UNBOUNDED PRECEDING by default

	RANGE BETWEEN ONBOUNDED PRECEDING AND CURRENT ROW
	
	--kendisinde önce ne kadar kayıt varsa ve kendisine kadar bakacak. Default tur.

4. Possible frame combinations 

	UNBOUNDED                     Everythink (Herkes,Hepsi)
	
	UNBOUNDED PRECEDING   -- kendisinden önceki tüm kayıtlar
	1         PRECEDING   -- kendisinden önceki bir kayıt
	
	UNBOUNDED FOLLOWING   -- kendisinden  sonraki tüm kayıtlar
	2         FOLLOWING   -- kendisinden sonraki 2 kayıt
    0         FOLLOWING   -- kendisinden sonraki 0 kayıt
	
	CURRENT ROW 
	
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED PRECEDING -- kendisi ve sonraki kayıtlara göre
	
	ROWS BETWEEN CURRENT ROW AND 1 PRECEDING -- kendisi ve sonraki 1 kayıt

	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW -- kendisi dahil kendinden önceki tüm kayıtlar
	

   EXAMPLE:
   
   1. kendisinden önceki 1 kayıt ve kendisinden sonra 1 kayıt 
   
   -- ROWS BETWEEN  1 PRECEDING AND 1 FOLLOWING
   
   2. kendisinden önceki tüm kayıtlar
   
   -- ROWS BETWEEN UNBOUNDED PRECEDING
   
   3. Kendisinden sonraki tüm kayıtlar
   
   -- ROWS BETWEEN UNBOUNDED FOLLOWING 
   
   4. kendisinden önceki tüm kayıtlar ve kendisinden sonraki bir kayıt
   
   -- ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING

*/

SELECT
*,
array_agg(x) OVER (ORDER BY x)
from generate_series(1,3) as x;
-- == AYNI SONUCU VERECEKTIR. BY DEFAULT 
SELECT
*,
array_agg(x) OVER (ORDER BY x  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
from generate_series(1,3) as x;


----

SELECT
*,
array_agg(x) OVER (ORDER BY x  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING )
from generate_series(1,3) as x;


SELECT
*,
array_agg(x) OVER (ORDER BY x  ROWS BETWEEN UNBOUNDED PRECEDING AND 0 FOLLOWING )
from generate_series(1,3) as x;

SELECT
*,
array_agg(x) OVER (ORDER BY x  ROWS BETWEEN UNBOUNDED PRECEDING AND 2 FOLLOWING )
from generate_series(1,5) as x;


SELECT
x,
array_agg(x) OVER () AS frame,
sum(x) OVER() as sum,
x::float /sum(x) OVER () as part_percentage
from generate_series(1,5) as x;


---

-- ROWS and RANGE indicators

/*

1. RANGE acan only be used with UNBOUNDED 

2. ROWS can actualy  be used for all og the options 

3. How aggregations are treated differently

if the field you use for ORDER BY does not contain unique values for each row, then RANGE will combine all
the rows it comes acrorss for non-unique values rathe than processing then one at a time;

ROWS will include all of the rows in the non-unique bunch but process each of them separately

*/

SELECT
*,
x/3 as y,
array_agg(x)   OVER(ORDER BY x ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) rows1,
array_agg(x)   OVER(ORDER BY x RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING) range1,
array_agg(x/3) OVER(ORDER BY x ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) rows2,
array_agg(x/3) OVER(ORDER BY x RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING) range2
FROM generate_series(1,5) as x;


-- WINDOW function
-- ##########################

/*

 1. WINDOW function allows us to add columns the result set that been calculated on the fly
 
 2. Allows to pre-defined a result set and used it anywhere ( even multiple places) in a query
 
 3. Using multiple window in a query 
 
 	SELECT
	  wf1() OVER ( PARTITTION BY c1 ORDER BY c2),
	  wf2() OVER ( PARTITTION BY c1 ORDER BY c2)
	FROM table_name;
	
 4. To shorten a query
 
 	SELECT
	  wf1() OVER w,
	  wf2() OVER w
	FROM table_name
	 WINDOW w AS (PARTITION BY c1 ORDER BY c2)
	
 	-- use the WINDOW clause even though we call one window function in a query
	
	SELECT
	  wf1() OVER w
	FROM table_name
	 WINDOW w AS (PARTITION BY c1 ORDER BY c2)
 
*/

-- Lets get min and max exports per year each country say from year 2000 owards in a single query


SELECT
country,
year,
exports,
min(exports) OVER w,
max(exports) OVER w
FROM trades
WHERE country='USA'AND year>2001
WINDOW w as (ORDER BY year)

---------

SELECT
country,
year,
exports,
min(exports) OVER w,
max(exports) OVER w
FROM trades
WHERE country='USA'AND year>2001
--WINDOW w as (ORDER BY year ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING);
--WINDOW w as (ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);
WINDOW w as (ORDER BY year ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING);

-- RANK AND DENSE_RANK functions
--#######################3
-- 1. rank() function return number of the current ow within its window. Counting start at 1.
-- 2. the rank column will number tuples in yoru dataset
-- 3. For rank () based on your data , you might encounter 



-- Lets look at top 10 exports by year for USA

SELECT * 
FROM(
	SELECT 
	year,
	exports,
	--RANK () OVER () r,
	--RANK () OVER (ORDER BY year DESC) as r2
	RANK () OVER (ORDER BY year DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as r2
	from trades
	WHERE 
	country ='USA'
	LIMIT 10
) AS T
WHERE r2=5


-- NTILE function
--#################################
/*

	1. NTILE will split data into ideally equal groups
	
	2. Divide ordered rows in the partition into a specified number of ranled buckets
	
	3. Bucket number for each group start with 1
	
	4. NTILE (buckets) OVER (
	         [PARTITION BY partition_expression , ... ]
			 [ORDER BY short_expression |asc|desc , ...]
			 
			 buckets  		the buckest represent the number of ranked groups , cannot not be null 
			 
    5. 
			
*/

-- Get USA export from year 2000 into 4 buckets
-- 4 erli grup halinde paketlere bölmek için
-- Tüm veriyi 4 kova  halinde toplamak
SELECT
year,
exports,
NTILE(4) OVER (ORDER BY exports)
FROM trades
WHERE country ='USA' AND year> 2000

--
-- 2 kovaya  bölmek için yarı yarıya 
SELECT
year,
exports,
--NTILE(2) OVER (ORDER BY exports)
NTILE(10) OVER (ORDER BY exports)
FROM trades
WHERE country ='USA' AND year> 1995

--
-- GET USA exports from year 2000 to into 5 buckets
SELECT * 
FROM(
	SELECT
	country,
	year,
	exports,
	--NTILE(2) OVER (ORDER BY exports)
	NTILE(5) OVER (PARTITION BY year ORDER BY exports) as r
	FROM trades
	WHERE
	country IN('USA', 'France','Belgium') 
	AND year> 1995 
) as T
WHERE r=2



--- LEAD and LAG function
--###########################

/**

  1. LEAD and LAG functions allows you to MOVE lines within the resultsets
  
  2. Verify useful  function to compare data of current row with any other rows (going backward LAG and forward LEAD)

  3. LEAD function  access a row that follows the current row , at a specfic physical offset.
  
  	 AFTER THE CURRENT ROW  -- sonraki
	 LEAD (expression,offset,[, default_value])
	 
  4. LAG function to access a row which comes before the current row at a specific physical ooffset
  
    BEFORE THE CURRENT ROW -- önceki 
	
	LAG (expression, offset, [, default_value])
	
**/


-- Lets calcculate  the difference of export from one year to another year for belgium
-- Kendisinden sonraki ilk kaydın export değerini al

select
year,
exports,
LEAD(exports,1) OVER (ORDER BY year)
from trades
WHERE country ='Belgium';

select
year,
exports,
LEAD(exports,2) OVER (ORDER BY year)
from trades
WHERE country ='Belgium';

---

select
year,
exports,
LAG(exports,1) OVER (ORDER BY year)
from trades
WHERE country ='Belgium';

select
year,
exports,
LAG(exports,2) OVER (ORDER BY year)
from trades
WHERE country ='Belgium'

LIMIT 4


select
country,
year,
exports,
LEAD(exports,1) OVER (PARTITION BY year ORDER BY year)
from trades
WHERE 
country IN('Belgium','USA') AND year>2010



--- FIRST VALUE ,LAST_VALUE AND NTH_VALUE FUNCTIONS
--################################3

/*

  FIRST_VALUE()   returns the first value in a sorted partition of a result set.
  
  LAST_VALUE()    returns the LAST value in a sorted partititon of the resulset
  
  NTH_VALUE()    returns the value from the NTH Row of result set


*/


--SINGLE country

SELECT
year,
imports,
FIRST_VALUE(imports) OVER( ORDER BY year)
FROM trades
WHERE
country='Belgium'



SELECT
year,
imports,
LAST_VALUE(imports) OVER( ORDER BY year)
FROM trades
WHERE
country='Belgium'



----
SELECT
year,
imports,
--LAST_VALUE(imports) OVER( ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
LAST_VALUE(imports) OVER( ORDER BY year ROWS BETWEEN 0 PRECEDING AND 0 FOLLOWING)

FROM trades
WHERE
country='Belgium'


--
SELECT
year,
imports,
NTH_VALUE(imports,2) OVER( ORDER BY year ),
NTH_VALUE(imports,4) OVER( ORDER BY year )

FROM trades
WHERE
country='Belgium'

-- Multiple columns
--
SELECT
country,
year,
imports,
--FIRST_VALUE(imports) OVER(PARTITION BY country ORDER BY year ),
--LAST_VALUE(imports) OVER(PARTITION BY country ORDER BY country )
NTH_VALUE(imports,2) OVER(PARTITION BY country ORDER BY year ) --2. Satırdaki değeri al

FROM trades
WHERE
country IN('Belgium','USA') AND
year>2014




--- ROW_NUMBER() function
--#############################################

/**

	1. can simply be used to return a virtual ID
	
	2. assign a unique integer value to each row in a result set starting with 1
	

*/

-- Assign rows to all imports for a country say france

SELECT
year,
imports,
ROW_NUMBER() OVER (ORDER BY imports DESC) as r
from trades
WHERE 
country='France'

-- Using ROW_NUMBER in SELECT FROM clause 
-- Get the 4th imports from each country order by year


SELECT
*
FROM(
	SELECT
	country,
	year,
	imports,
	ROW_NUMBER() OVER (PARTITION BY country ORDER BY year) as r
	FROM trades
	WHERE year>=2010
)as T
WHERE r=4
ORDER BY  country,imports DESC


----
-- HR DB
-------------------------------------------
-- 1. Select first name, last name , salary and department name for all then use ROW_NUMBER to order by salary

select 
e.first_name,
e.last_name,
e.salary,

d.department_name,

ROW_NUMBER() OVER (
	--ORDER BY e.salary
	ORDER BY e.last_name
)

FROM employees e
INNER JOIN departments d ON d.department_id=e.department_id



---
-- 1. Her bölümde en yüksek maaş alan 2 çalışanı listeyiniz.

SELECT
*
FROM (
	SELECT 
	e.first_name,
	e.last_name,
	e.salary,
	
	d.department_name,
	ROW_NUMBER() OVER (
		PARTITION BY d.department_name 
		ORDER BY e.salary DESC
	) as r
	FROM employees e
	INNER JOIN departments d ON d.department_id=e.department_id
) AS T
WHERE T.r=2 
ORDER BY T.salary DESC

-- Using DISTINCT with ROW_NUMBER()
-- #####################################

-- Get all the distinct salaries and assign ROW_NUMBER() on then
-- Using DISTINCT in SELECT ROW

SELECT 
	e.salary,
	ROW_NUMBER() OVER (
		ORDER BY e.salary 
	) as r
FROM employees e;


-- duplicate rows
-- ROW_NUMBER() is applied on the DISTINCT resulset
SELECT
	salary,
	ROW_NUMBER() OVER
	(
	 ORDER BY salary DESC
	)
FROM(

	SELECT DISTINCT
		   salary
	FROM employees
) as t
ORDER BY salary DESC;



-- DENSE and DENSE_RANK
-- #################################

SELECT
first_name,
salary,
RANK() OVER w,
DENSE_RANK() OVER w
FROM employees 
WINDOW w AS (ORDER BY salary DESC);


-- rank and global rank

SELECT
	first_name,
	salary,
	department_id,
	RANK() OVER w_department as w_department ,
	RANK() OVER w_all_departments as w_all_departments
FROM employees
WINDOW w_department AS( PARTITION BY department_id ORDER BY salary DESC),
       w_all_departments AS(ORDER BY salary DESC)
ORDER BY salary DESC;


-- PARTITION BY departments

SELECT
	first_name,
	salary,
	department_id,
	ROUND( AVG(salary) OVER (PARTITION BY department_id ) , 2 ) as avg,
	ROUND(salary- AVG(salary) OVER (PARTITION BY department_id ) , 2 ) as diff_avg
FROM employees

-- Using WITH clause to create your own data
--##################################################

WITH cte_name (col1,col2,..) AS (

	VALUES
	(...),
	(...)
) 
SELECT statement;


WITH num (value) AS
(
	VALUES
	(1),
	(2),
	(3),
	(4)
)
select max(value),min(value),sum(value),avg(value) from num;




-- Using WITH clause for ORDER BY values
--###################################3

-- 1. Lets crate a sample table 

CREATE TABLE t_order(
id SERIAL PRIMARY KEY,
item VARCHAR(100)
)


-- 2. Let insert some values

INSERT INTO t_order (item)
VALUES
('Pen'),
('Paper'),
('Pencil'),
('Book'),
('Printer');

-- 3. Lets use simple order by first

select * from  t_order
ORDER BY item;


WITH t_data (list_order,item) AS(
VALUES
(1,'Pen'),
(2,'Paper'),
(3,'Pencil'),
(4,'Book'),
(5,'Printer')
)
select * 
FROM t_order o
JOIN t_data  d on o.item=d.item;


--- WITH DELETE,INSERT ,SELECT

WITH name AS(
	DELETE statement
	RETURNING *
)
INSERT statement
SELECT statement;


-- example 
create table t1(
id SERIAL PRIMARY KEY,
item VARCHAR(100)
);

INSERT INTO t1 (item)
VALUES
('item1'),
('item2'),
('item3'),
('item4');


create table t2(
id SERIAL PRIMARY KEY,
item VARCHAR(100)
)

SELECT * FROM t2;


WITH yahoo AS(

	DELETE FROM t1
	WHERE id in (1,2)
	RETURNING item
)
INSERT INTO t2(item)
SELECT * FROM yahoo;