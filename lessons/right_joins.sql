--RIGHT JOIN
--######################


--* Returns every row from the RIGHT table PLUS rows that match values in the joined column from  the LEFT table
-- When a right table row does not have a match in the left table the result shows no values
-- from the left table

/**

SELECT 
table1.column1,
table2.column2
FROM table1
RIGHT JOIN table2 ON table1.column1=table2.column2;


*/


-- 1. Lets join left_product and right_products via RIGTH JOIN


select 
*
FROM left_products l
RIGHT JOIN right_products  r ON l.product_id = r.product_id

-- there is no revord for 'Hics'

-- 2. lets run RIGHT JOIN on movies database

-- List all the movies with directors first and last names , and movie name
--What is rigth table or table2 movies;

SELECT
d.first_name,
d.last_name,

mv.movie_name
FROM directors d
RIGHT JOIN movies mv on d.director_id = mv.director_id
ORDER BY d.first_name


-- 3. Lets reverse on the tables directos and movies
--what is the impact on the results ?

SELECT
d.first_name,
d.last_name,

mv.movie_name
FROM directors d
RIGHT JOIN movies mv on d.director_id = mv.director_id ;

-- 4. Can we and a Where conditions , say get list of english and chinese movies only

SELECT
d.first_name,
d.last_name,

mv.movie_name,
mv.movie_lang
FROM directors d
RIGHT JOIN movies mv on d.director_id = mv.director_id
WHERE mv.movie_lang IN('English','Chinese')
ORDER BY 1 ;


SELECT
d.first_name,
d.last_name,

mv.movie_name,
mv.movie_lang
FROM movies mv 
RIGHT JOIN directors d  on d.director_id = mv.director_id
WHERE mv.movie_lang IN('English','Chinese')
ORDER BY 1 ;


-- 5. Count all movies for each directors

SELECT
d.first_name,
d.last_name,

count(*) as "total_movies"
FROM movies mv 
RIGHT JOIN directors d  on d.director_id = mv.director_id
GROUP BY d.first_name,d.last_name
ORDER BY 3 DESC,d.first_name


-- 6. get all the total revenues done by each films for each directors


SELECT
d.first_name,
d.last_name,

SUM (r.revenues_domestic+r.revenues_international) as "total_revenues"
FROM directors d
RIGHT JOIN movies mv on d.director_id = mv.director_id
LEFT JOIN movies_revenues r on mv.movie_id = r.movie_id
GROUP BY d.first_name,d.last_name
--HAVING SUM (r.revenues_domestic+r.revenues_international) >100
ORDER BY 3 DESC NULLS LAST;

