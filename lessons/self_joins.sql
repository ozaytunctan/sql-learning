--Self Join
--######################

--* Self-join allows you you to compare rows within the SAME table.

-- * Normal use case of self join is to
-- query hierarchical data or 
-- -to compare row within the same table

/**

SELECT
column_list
FROM tablename t1
INNER JOIN tablename t2 ON t1.column=t2.column


*/

-- 1. Lets self join left_product table

SELECT 
*
FROM left_products t1
INNER JOIN left_products t2 ON t1.product_id = t2.product_id;

SELECT 
*
FROM left_products t1
INNER JOIN left_products t2 ON t1.product_id = CAST(t2.product_id AS INT);


-- 2. Lets self join directors table

SELECT
*
FROM directors t1
INNER JOIN directors t2 on t1.director_id = t2.director_id;

-- 3. Lets self join finds all pair of movies that have the same movie length

SELECT
t1.movie_name,
t2.movie_name,
t1.movie_length

FROM movies t1
INNER JOIN movies t2 
ON t1.movie_length = t2.movie_length 
AND t1.movie_name<>t2.movie_name
ORDER BY t1.movie_length DESC,t1.movie_name

