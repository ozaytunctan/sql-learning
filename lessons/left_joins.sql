-- LEFT JOINS
--##############################
-- * Returns ever from the LEFT table PLUS rows that match values int he joined column from the rigth table.
-- * when a left table row does not have a match in the right table, the result shows no values
-- from the rigth table
/**

SELECT
	table1.column1,
	table2.column2
FROM table1
LEFT JOIN table2 ON table1.column1=table2.column2

*/

--1. Lets create some sample tables for our JOIN exercises
-- To better visualize join types , lest call the tables left products and right products

CREATE TABLE left_products(
  product_id SERIAL PRIMARY KEY,
  product_name VARCHAR(100)
);


CREATE TABLE right_products(
  product_id SERIAL PRIMARY KEY,
  product_name VARCHAR(100)
);


-- 2. Lets add same data

INSERT INTO left_products(product_id,product_name)
VALUES
(1, 'Computers'),
(2, 'Laptops'),
(3, 'Monitors'),
(5, 'Mics');

SELECT * from left_products;

INSERT INTO right_products(product_id,product_name)
VALUES
(1, 'Computers'),
(2, 'Laptops'),
(3, 'Monitors'),
(4, 'Pen'),
(7, 'Papers');


SELECT * from right_products;


-- 3. Lets join the table with LEFT JOIN 

-- common column is product_id

SELECT 
*
FROM left_products lp
LEFT JOIN right_products rp on lp.product_id=rp.product_id;


-- 4. using movies tables for JOINS
-- list all the movies with directors dirt and last name , and movie name


SELECT
d.first_name,
d.last_name,

mv.movie_name
FROM directors d 
LEFT JOIN movies mv ON d.director_id=mv.director_id
ORDER BY 1,2

SELECT * from  directors 
SELECT * from  movies ORDER BY director_id


SELECT
d.first_name,
d.last_name,

mv.movie_name
FROM movies mv 
LEFT JOIN directors d ON d.director_id=mv.director_id

INSERT INTO 
directors(first_name,last_name,date_of_birth,nationality)
VALUES
('Özay','TUNÇTAN','199-01-01','Turkey');


-- for left join the first table matters

-- 6. Can we add a where condition , say get list he of english and chinese movies only


SELECT
d.first_name,
d.last_name,

mv.movie_name,
mv.movie_lang
FROM directors d 
LEFT JOIN movies mv ON d.director_id=mv.director_id
WHERE 
mv.movie_lang IN('English','Chinese');


-- 7. count all movies for each directors


SELECT
d.first_name,
d.last_name,
COUNT(*) AS "totalMovies"
FROM directors d 
LEFT JOIN movies mv ON d.director_id=mv.director_id
GROUP BY d.first_name,d.last_name
ORDER BY 3 DESC;

-- 8. Get all the movies with age_certificate for all directors where nationality are 'American' , 'Chinese' and 'Japanese'

-- what is the 1first table : directors

SELECT 
*
FROM directors d
LEFT JOIN movies mv ON d.director_id = mv.director_id
WHERE d.nationality IN ('American','Chinese','Japanese')

--- 9. Get all the total revenues done by each films for each directors

--What is the first table or left table : films  or direction


SELECT 
d.first_name,
d.last_name,

SUM(COALESCE(r.revenues_domestic,0) + COALESCE(r.revenues_international,0)) as "total_revenues"
FROM directors d 
LEFT JOIN movies mv  ON mv.director_id=d.director_id
LEFT JOIN movies_revenues r ON r.movie_id=mv.movie_id
GROUP BY d.first_name ,d.last_name
HAVING SUM(COALESCE(r.revenues_domestic,0) + COALESCE(r.revenues_international,0))>0
ORDER BY 3 DESC NULLS LAST;


