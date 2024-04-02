---What is Index
--############################3333333


CREATE INDEX idx_tablename_column_name ON tablename(columns) -- columns size >32 max 

CREATE UNIQUE INDEX idx_u_tablename_columnname ON tablename(columns);


CREATE TABLE municipality(
id SERIAL PRIMARY KEY ,
name VARCHAR (100)
);

INSERT INTO municipality(name)
VALUES
('Bitlis Belediyesi'),
('İstanbul Belediyesi'),
('Ankara Büyükşehir Belediyesi');



CREATE TABLE financial_periods(
	id INTEGER PRIMARY KEY  ,
	municipality_id INTEGER  REFERENCES municipality(id),
	year INTEGER 
);


ALTER TABLE financial_periods
ADD CONSTRAINT municipality_id_year_unique UNIQUE (municipality_id,year);

ALTER TABLE financial_periods
ADD CONSTRAINT financial_periods_year_positive_grather_than CHECK (year>0 AND year>2000);

INSERT INTO financial_periods(id,year,municipality_id)
VALUES
(20231,2023,1),
(20232,2023,2),
(20233,2023,3),
(20242,2024,2),
(20243,2024,3);


--constraint violation
INSERT INTO financial_periods(id,year,municipality_id)
VALUES
(20241,1999,1)


select 
*
from financial_periods;


CREATE INDEX idx_financial_periods_municipality_id ON financial_periods(municipality_id);


select 
m.name,
p.id,
p.year
from municipality m 
    INNER JOIN financial_periods p ON m.id = p.municipality_id
WHERE p.id=20231


--- list counts for all indexes
--####################################33

--all stats
select * from pg_stat_all_indexes;

-- for a schema

SELECT 
*
FROM pg_stat_all_indexes 
WHERE schemaname='public' AND relname='financial_periods'
ORDER BY relname,indexrelname;

-- Drop an Index
--###################################3

DROP INDEX [ CONCURRENTLY ]
[IF EXISTS] indexname
[CASCADE |RESTRICT];


DROP INDEX idx_financial_periods_municipality_id

---SQL statement excution process
--################################

/**

1. SQL is a declarative language

2. You trust  your databse to run the best way to fetch the data 

3. As a DBA , its your job to provide as much information to database engine to take best route to get your result set



*/

select * from orders where order_id=10257;


-- SQL Execution Parser
--#####################################

/**

Four Stages
------------------------------------

SELECT * FROM ORDERS;

parser                 handles the textual form of the statement (the sql text) and verifies whether
                       it is correct or not 
			
			
rewriter              appling any syntastic rules to rewrite the original SQL statement


optimizer             finding the very fastest path to the data that xthe statement needs


executor              reponsible for effectively going to the storage and retriveving or inseting the data
                      gets physical to the data

*/


-- The optimizer 
--#########################

/**

 a. What to use tp access data 
 
 b. as quickly as possible 
 
 1. The COST is everything
 
  POSTGRESQL operations =COST
   4 OPERATIONS =4 X COST = TOTAL AMOUNT
   
  lowest cost win !!!!!!
 
 
 2. Thread >=9.6
 
 3. Nodes
 
 SEELCT * FROM orders order by order_id;
 	a. all data  node #1
	b. order by  node #2
	
	


*/


-- Optimizer Nodes types
-- ##########################33

/*

1. Nodes are available for;

	- every operation and
	- every acces methods
	
2. nodes are stackable
	Parent Node ( cost=...01.10)
		Child Node 1
		  Child Node 2
		 ...
		 
   the output of a node can ce used ad the  input to another node 

3. Types of nodes

	-Sequencial Scan
	-ındex scan , Index only scan , AND Bitmap, 
	-Nested loop , Hash join , and Merge Join
	- the GATHER AND merge paralel nodes
*/




-- Sequencial Scan
--####################
/**

Seq Scan 
 1. Default when no another valuable alternative 
 2. Read from the beginning pf the dataset
 
 SELECT * FROM orders WHERE order_id IS NOT NULL;
 
 3. filtering clause is not very limiting , so that  the end result will be to get almost wholetable contents
 
   -sequential read-all operation faster
 
 EXPLAIN  SELECT * FROM orders;
 
 EXPLAIN SELECT * FROM orders WHERE order_id IS NOT NULL;
 
 */
 
 
 -- Index Nodes
 --##############################3
 
 /**
 
 1. An index is used to access the dataset
 
 2. Data file and index files are seperated but they are nearby
 
 3. Index Node scan type
 	- Index Scna
	-Index Only Scan
	-Bitmap Index Scan
	
 CREATE INDEX idx_orders_customer_id_order_id on orders (customer_id,order_id);

CREATE INDEX idx_orders_order_date on orders (order_date);

CREATE INDEX idx_orders_ship_city ON orders(ship_city);

DROP INDEX idx_orders_ship_city;
DROP INDEX idx_orders_order_date;
DROP INDEX idx_orders_customer_id_order_id

*/

EXPLAIN SELECT * FROM orders 
WHERE ship_city='Lyon' 
AND order_date>'1995-07-01'
and order_id=10251



--Join Index
---##################################






----Partial Index
--###################################
CREATE TABLE t_big (
id SERIAL PRIMARY KEY,
name VARCHAR(100)
)

INSERT INTO t_big (name)
SELECT 'value-' ||s from generate_series(1, 2_000_000) as s;

SELECT 
*
FROM t_big;

CREATE INDEX index_name ON tablename WHERE conditions;

CREATE INDEX idx_t_big_name ON t_big(name);

CREATE INDEX idx_t_big_id ON t_big(id);

SELECT pg_size_pretty(pg_indexes_size('t_big'));

DROP INDEX idx_t_big_name;

CREATE INDEX idx_p_t_big_name on t_big(name)
WHERE name NOT IN ('Adam','Linda');

select * from t_big where name <> ALL (ARRAY['value-1','value-2']);


---Gender Nationality

SELECT * FROM customers 
ORDER BY is_active;

UPDATE customers
set is_Active='N'
WHERE customer_id IN('ALFKI','ANATR');


EXPLAIN ANALYZE SELECT * FROM customers 
WHERE is_active='N';

"Planning Time: 0.338 ms",
"Execution Time: 0.040 ms"


DROP INDEX idx_p_customers_is_active

CREATE INDEX idx_p_customers_is_active ON customers(is_active)
WHERE is_active='N'


EXPLAIN ANALYZE SELECT * FROM customers 
WHERE is_active='N';

"Planning Time: 0.251 ms"
"Execution Time: 0.042 ms"


EXPLAIN ANALYZE SELECT COUNT(*) FROM customers;



---Expression Index
--##################3
/**
	1. An index created based on an 'expression' e.q
		UPPER(column_name),
		LOWER(col)
		EXTRACT(day from DATE_COLUMN)
		
	2. POSTGRESQL will consider using that index when the expression that defines the index appears in the 
		- WHERE clause or
		- in the ORDER BY clause of the SQL statement
		
	3. Very expensive indexes
		
		Postgresql has to evuluate the expression FOR EACH ROW hen it is inserted OR UPDATE and use the result
		for index;
		
	**/
	
	CREATE INDEX index_name
	ON tbale_name (expression);
	
	--
	CREATE TABLE t_dates AS
	select d,repeat(d::text,10) as padding
	        FROM generate_series(timestamp '1800-01-01',
								 timestamp '2100-01-01',
								 interval '1 day') s(d);
								 
VACUUM ANALYZE t_dates;	

select count(*) from t_dates	;

EXPLAIN ANALYZE SELECT * FROM t_dates WHERE d  BETWEEN '2001-01-01' AND '2001-01-31';



--WITHOUT ANY INDEX
--4866.61		

CREATE INDEX idx_t_dates_d ON t_dates(d)
	

EXPLAIN ANALYZE SELECT * FROM t_dates WHERE EXTRACT(day from d)=1;
	
CREATE INDEX idx_exp_t_dates ON t_dates (EXTRACT(day from d));

EXPLAIN ANALYZE SELECT * FROM t_dates WHERE EXTRACT(day from d)=1;


--CONCURENTLY
--##########
--Adding daat while indexing

--CREATE INDEX CONCURRENTLY

CREATE INDEX CONCURRENTLY idx_t_big_name2 ON t_big (name);


SELECT 
oid,relname,relpages,reltuples,
i.indisunique,i.indisclustered,i.indisvalid,
pg_catalog.pg_get_indexdef(i.indexrelid,0,true)
FROM pg_class c JOIN pg_index i on c.oid=i.indrelid
WHERE c.relname='t_big';
	
	
--Rebuilding an index (REINDEX)
---##################

REINDEX [(verbose)] [INDEX|TABLE|SCHEMA|DATABASE|SYSTEM] [concurrently] name

BEGIN

REINDEX INDEX idx_orders_customer_id_order_id;

REINDEX (VERBOSE) INDEX idx_orders_customer_id_order_id;

REINDEX (VERBOSE) TABLE t_big;

REINDEX (VERBOSE) DATABASE nortwind;
END;

