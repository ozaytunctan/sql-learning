--Introduction POSTGRESQL View
--##################################
/**

One of the advantages of using a programing language is that is allows us to automate repetitive , boring tasks.
for example, if you have to run the same query every day or month to update the same table , sooner or later
you will search for a shorcut to accomplish the task. the good bewa is that shorcuts exists in POSTGRESQL and it is
Called a 'View'.

 * You can save your query into a view , so instead of writing long queries , you can just refer to a view.
 * A view is a database object that is of a 'stored query'.
 * A view is a virtual table you can  create dynamically using a saved query acting as a 'virtual tabşe'.
 * Views  help to encapsulate queries and logic into reusable POSTGRESQL database objects that will
 speed up your workflow.
 * Views are like Don't Repeat Yourself!
 * Similar to a regular table , you can;
  
   	* query a view,
	* join a view to regular tables 
	* use the view to update or insert data into the table its based on , albeit with some caveats,
	
	* Pelase note that a regular views do not store any data except the 'materialized views'
	
	-- How  views are useful
	  * Views are especial useful because  they allow you to ;
	  
	  * Avoid duplicate effort by letting  your write a query ıonce and acess the results when needs
	  * Reduce complexisty for yoursdwlf or othe database users by showing only columns relevant your needs 
	  * Provide security  by limiting access to only certain columns in a table
	  * Like a table , you can grant permission to users through a view that the users are authorized to see.
	  
	  **/
	  

-- Creating a view 
--#####################

-- CREATE OR REPLACE VIEW view_name AS query

-- 'query' can be;

-- SELECT
-- SELECT with subqueries
--  SELECT with joins
-- pretty much anything that you run via SELECT can be turned into a views

-- 1. Create a view to include all movies with dirdctors first and last names
-- Lets look at normal approach

CREATE OR REPLACE VIEW v_movie_quick AS 
SELECT
mv.movie_name,
mv.movie_length,
mv.release_date
FROM movies mv





-- Lets see how to use view now!

CREATE OR REPLACE VIEW v_movies_directors_all AS 
SELECT
mv.movie_id,
mv.movie_name,
mv.movie_length,
mv.movie_lang,
mv.age_certificate,
mv.release_date,


d.director_id,
d.first_name,
d.last_name,
d.date_of_birth,
d.nationality

FROM movies mv
INNER JOIN directors d ON mv.director_id = d.director_id;


-- 2. How to view a query

-- 3. How to use a view for query database ?

SELECT * FROM v_movie_quick;

SELECT * FROM v_movies_directors_all;


--Rename a view 
--################

--ALTER VIEW view_name RENAME TO new_view_name;

ALTER VIEW v_movie_quick RENAME TO v_movie_quick2;
ALTER VIEW v_movie_quick2 RENAME TO v_movie_quick;

ALTER VIEW v_movie_quick OWNER TO super_db_admin;


-- Delete a view
-- ##############33

DROP VIEW view_name;

DROP VIEW v_movie_quick;


--Using conditions /filters with views
--##############################33


-- 1. Create a view to list all movies released after 1997

CREATE  OR REPLACE VIEW v_movies_after_1997 AS
SELECT 
*
from movies 
WHERE release_date >='1997-12-31'
ORDER BY release_date DESC


-- 2. Select all movies with english language only from the view

--original 
SELECT 
*
from v_movies_after_1997
WHERE movie_lang ='English'
AND age_certificate='12'
order by movie_lang

-- 3. Select all movies with directors with American, and Japanese nationalities

SELECT
*
FROM movies mv
INNER JOIN directors d ON d.director_id=mv.director_id;

--with views

--We do not need wory about giving join tables aliases in views,instead
select 
* 
from v_movies_directors_all
WHERE nationality IN('American','Japanese');

--A view using SELECT and UNION with multiple tables
--############################################

--Lets have a view for all peoples in a movie like actors and directos with first ,last name

CREATE OR REPLACE VIEW v_all_actors_directors AS
select 
first_name,
last_name,
'actors' as people_type
from actors
UNION ALL
SELECT
first_name,
last_name,
'directors' as people_type
FROM directors;


SELECT
*
FROM v_all_actors_directors
where first_name ='John'
ORDER BY people_type,first_name;



--Conecting multiple table with a single view
--##########################

--Lets connect movies ,direcrtos,movies revenues tables with a single view 
--
-- movies |directors
--dirctor_id common !

CREATE OR REPLACE VIEW v_movies_directors_revenues AS
select
mv.movie_id,
mv.movie_name,
mv.movie_length,
mv.movie_lang,
mv.age_certificate,
mv.release_date,

d.director_id,
d.first_name,
d.last_name,
d.date_of_birth,
d.nationality,

r.revenue_id,
r.revenues_domestic,
r.revenues_international

from movies mv
INNER JOIN directors d ON mv.director_id = d.director_id
INNER JOIN movies_revenues r ON mv.movie_id = r.movie_id


--the above queries contains multiple columns like movie_id ,can we use CREATE VIEW ?

--with views
select
*
FROM v_movies_directors_revenues
WHERE age_certificate='12';


--Changing views
--######################


-- 1. Can I re-range a column to an existing view ?
CREATE OR REPLACE VIEW v_directors2 AS
select
last_name,
first_name
from directors;

-- the way is to delte the existing view anf then create new view  for re-aranging the columns!.


-- 2. Can I remove a column from an existing view

select
* from v_directors


CREATE OR REPLACE VIEW v_directors AS
select
first_name,
last_name
from directors;

CREATE OR REPLACE VIEW v_directors_first_name AS
select
first_name
from directors;

-- so either we rename old view or delete it and then we create our new vi,ew with required columns!

-- 3. Can I add a column to an existing view ?

CREATE OR REPLACE VIEW v_directors AS
SELECT
first_name,
last_name,
nationality
FROM directors;


-- A regular view
-- * does not store data physically
-- * always give update data

select
*
from v_directors;

--Lets insert some data
INSERT INTO directors(first_name,last_name)
VALUES('test_name','test_last_name');

select * from directors;

DELETE FROM directors where director_id=77;



--WHAT IS AN UPDATABLE VIEW 
--############################

--CREATE OR REPLACE VIEW view_name AS query 

-- An updatable view allows you to update the data on the underling data. However, there are some rules to follow;

/*

	1. The query must have one from entry which can be either a table or another updatable view
	
	2. The query cannot contains the following ar he top level;
	DISTINCT
	GROUP BY
	WITH
	
	LIMIT
	OFFSET
	
	UNION
	INTERSECT
	EXCEPT
	
	HAVING
	
	
	3. You cannot use the following in the selection list;
	
	  any window function
	  any set-returning function;
	  any aggregate function such as
	  SUM
	  COUNT
	  AVG 
	  MIN 
	  MAX
	  
	  --Pretty limited options. but rememver we are only updating the data here and not ideally selecting the data
	  
	4. You can use the following operations to update the data	  
	INSERT
	UPDATE
	DELETE
	
	along with say a where clause!
	

**/

-- 1. Lets create an updateble view for directors table

CREATE OR REPLACE VIEW vu_directors AS
select
first_name,
last_name
from directors;

--2. Lets add some record via view and not from the underling table

INSERT INTO vu_directors (first_name,last_name) VALUES('dir1','dir_last1'),('dir2','dir_last_2');

INSERT INTO v_all_actors_directors (first_name,last_name)
VALUES('dir4','dir_last4'),('dir5','dir_last_5')

-- Lets check the contents of directors table via view 

SELECT 
*
FROM vu_directors;

SELECT * FROM directors;

-- 4. Lets delete some record via a view and not from the underling table

delete from vu_directors where first_name='dir1';


--- Updatable views using WITH CHECK OPTION
--#################################

-- 1. lets create a table for contries

CREATE TABLE countries(
country_id SERIAL PRIMARY KEY,
country_code VARCHAR(4) ,
city_name varchar(100)	
);

-- 2. Lets insert some sample data to base table 

INSERT INTO countries (country_code,city_name)
VALUES
('TR','İstanbul'),
('TR','Ankara'),
('TR','Bitlis'),
('US','New york'),
('US','New  JERSEY'),
('UK','London');

-- 3. lets viq the content of contries table

select * from countries;

-- 4. Now lets create a simple view called v_cities_us to list all US based cities

CREATE OR REPLACE VIEW v_cities_us AS
SELECT 
country_id,
country_code,
city_name
FROM countries
WHERE country_code='US'


-- 5. Lets view the content of v_citites_us

select * from v_cities_us

-- 6. .Lets insert some US base cities via our view


INSERT INTO v_cities_us (country_code,city_name)
VALUES
('US','California');

INSERT INTO v_cities_us (country_code,city_name)
VALUES
('TR','Trabzon');

select * from v_cities_us;

--We have problem , as no record of UK countries are showing in our view , however the table 'countries'
-- contains the newly add UK city


select * from countries;

--- TO SOLVE we will set our views to use WITH CHECK OPTION

--- 8. lets update our view v_cities_us using WITH CHECK OPTION

CREATE OR REPLACE VIEW v_cities_us AS
SELECT 
country_id,
country_code,
city_name
FROM countries
WHERE country_code='US'
WITH CHECK OPTION;


-- 9. Now , lets try add a UK base city say 'Leeds'

INSERT INTO v_cities_us (country_code,city_name)
VALUES
('UK','Leeds');


-- 10 . Lets try the UPDATE operations on view having WITH CHECK OPTION ,can we the data

select * from v_cities_us;

UPDATE v_cities_us 
SET country_code='UK'
WHERE city_name='New york';

--11 . Now lets add a US based city
INSERT INTO v_cities_us (country_code,city_name)
VALUES
('US','Chicago');


select * from v_cities_us;

--So our WITH CHECK OPTION is working perfectly!!!!




----What is a Materialized Views
---###########################3

/*


	1. A materialized view allow you to;
	* store result of a query physical and
	* update the data periodically.
	
	2. A materialized view caches the result of a complex expensive query and then allow you to refresh
	this result periodically.
	
	3. A materialized view executes the query once and then holds onto those result


CREATE MATERIALIZED VIEW IF NOT EXISTS view_name AS QUERY
WITH [NO] DATA

When materialized views are generally used for;

-Materialized view can be used to cache results of  a heavy query
-When you need to store data that has been manipulated from its basic normalized state abd that manipulaton is expensive or slow, and you dont mind that your data is stale.
That manipulation can be a complicated join or union , filtering criteria , or protracted calcualtion etc.


**/


--- Create a materialized view
--- #####################################

CREATE MATERIALIZED VIEW IF NOT EXISTS view_name AS query_
WITH [NO] DATA 

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors AS
SELECT
first_name,
last_name
FROM directors
WITH DATA


select * from mv_directors;

-----------------------------



--Create a materialized view with NO DATA option
-- WITH NO DATA , the view is flagged as unreadable . It means that you cannot query data from the view until you
-- load daat into it.

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors_nodata AS
SELECT
first_name,
last_name
FROM directors
WITH NO DATA


select * from mv_directors_nodata;

REFRESH MATERIALIZED VIEW mv_directors_nodata;

select * from mv_directors_nodata;
