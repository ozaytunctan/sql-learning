---Common Table Expression(CTE)
--############################################3

/**

WITH cte_name AS(



)
SELECT
* FROM cte_name


*/

---

WITH directors_cte AS(

	select
	director_id,
	first_name,
	last_name
	FROM directors d
)

SELECT
*
FROM directors_cte




--------------------------------------


WITH total_revenues AS(

SELECT 
	mv.movie_id,
    sum((r.revenues_domestic+r.revenues_international)) as "totalRevenues"
	FROM movies mv
	INNER JOIN movies_revenues r ON mv.movie_id = r.movie_id
	GROUP BY mv.movie_id
   
)
SELECT 
m.movie_name,
m.movie_length,
tr."totalRevenues",
d.first_name,
d.last_name
FROM total_revenues tr
INNER JOIN movies m ON tr.movie_id =m.movie_id
INNER JOIN directors d ON d.director_id = m.director_id
WHERE tr."totalRevenues">0 
ORDER BY tr."totalRevenues" DESC

-----
---- CTE RECURSIVE 
--#########################################################3

/**


WITH RECURSIVE cte_name AS 
(

CTE_query_definition -- non-recursive term

UNION [ALL]

CTE_query_definition -- recursive term exit conditions


)
SELECT *  from cte_name


*/


-- Creation a time series with recursive CTEs

WITH RECURSIVE series( list_num) AS
(
 --non recursive statement
 SELECT 10 
	   
 UNION

 -- recursive statement

	SELECT 
	list_num+5
	FROM series  where list_num+5<=50
	
)
SELECT
*
FROM series



-------------------------------
-- Lets create our sample table which will contains some hierarchiacal data

CREATE TABLE items (
id serial PRIMARY KEY,
name TEXT NOT NULL,
parent_id INT
)

--Lets insert sample data

INSERT INTO items (id,name,parent_id)
VALUES
(1,'vegetables',NULL),
(2,'fruits',NULL),
(3,'apple',2),
(4,'banana',2)



INSERT INTO items (id,name,parent_id)
VALUES
(5,'melon',4)


select * from items;


-- Lets show data in parent-child relationship

tree_level ,name

1. vegetable
1, fruits
2, fruits -> apple
2 , fruitis -> banana

-------------------------------------------------------------

WITH RECURSIVE cte_tree AS (

-- non recursive statement
-- all parent info
	select 	name,
	id,
	1 as tree_level
	FROM items
	where parent_id is null
	
	UNION
	
	--recursive statement 
	
	-- loop  tp get all child of each parent
	
	SELECT  
	tt.name ||' -> '||ct.name,
	ct.id,
	tt.tree_level+1
	from items ct 
	INNER JOIN cte_tree tt ON ct.parent_id = tt.id
)

SELECT
tree_level,
name
FROM cte_tree



-------------------------------------------------------------
---



CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  account_code VARCHAR (100),
  amount numeric(10,2)
)


INSERT INTO transactions(account_code,amount)
VALUES
('333.01.02.99',100),
('333.01.02.99',90),
('333.01.03',20),
('333.02.99',40),
('333.03.02',50)


SELECT * FROM transactions




WITH RECURSIVE transaction_sum AS (

	SELECT 
	account_code::text as code,
	amount
	FROM transactions
	
	UNION ALL
	
	SELECT
	LEFT(code, LENGTH(code) - POSITION('.' in REVERSE(code)))::text as code,
	amount
	FROM transaction_sum 
	WHERE LEFT(code, LENGTH(code) - POSITION('.' in REVERSE(code))) <> transaction_sum.code
)
SELECT
code,
SUM(amount)
FROM transaction_sum
GROUP BY code 
ORDER BY code










*/



