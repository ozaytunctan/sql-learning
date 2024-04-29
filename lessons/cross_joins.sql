-- CROS JOIN 
--#######################333
--- * In as CROSS JOIN query , the result (also known as a cartesian product) lines up each row int he left table
-- with each row in the right table to present all possible combination of rows


-- *Suppose you have to perform a CROSS JOIN of two table table1 and table2
-- If tables has n rows and table2 has m rows , the result set will have
-- n*m rows
-- table1 rows=9 , table2 rows= 20 result=9 * 20 =180

/**
SELECT 
*
FROM table1 , table2
FROM table1 CROSS JOIN table2

*/


-- 1. Lets CROSS JOIN left_product and right products
SELECT * FROM left_products ;-- rows=4
SELECT * FROM right_products ;-- rows=5
 -- 4 x 5 =20 
 
SELECT 
*
FROM left_products
CROSS JOIN right_products 


SELECT 
*
FROM left_products,right_products ;


SELECT 
*
FROM left_products
INNER JOIN right_products ON true ;


select 
*
FROM actors
CROSS JOIN directors;

