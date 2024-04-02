--FULL Joins
--###################3

--- * Returns every row from all the join tables

/**
select 
table1.column1,
table2.column2
FROM table1
FULL JOIN table2 ON table1.column1=table2.column2;

*/

--Return all the data from table1,and table2

--1. Lets join left_products and right_products via FULL JOIN

SELECT
*
FROM left_products l
FULL JOIN right_products r ON l.product_id = r.product_id;


-- 2. Lets run FULL JOINS on movies database

--Lets all the movies wit directors first and last names and movie name

SELECT 
d.first_name,
d.last_name ,

mv.movie_name
FROM directors d 
FULL JOIN movies mv on d.director_id = mv.director_id
ORDER BY d.first_name;


-- 3. Lets reverse the tables directos and movies
--what is the impct on the results?




-- 4. 4.Can we add a WHERE conditions, say get list of english and chinese movies only


SELECT 
d.first_name,
d.last_name ,

mv.movie_name,
mv.movie_lang
FROM directors d 
FULL JOIN movies mv on d.director_id = mv.director_id
WHERE mv.movie_lang IN ('English','Japanese','Chinese')
ORDER BY d.first_name;