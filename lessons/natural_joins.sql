-- NATURAL JOIN
--################
-- NATURAL [LEFT,RIGHT,INNER] JOIN 
-- What if you use (*) for column list


SELECT
*
from left_products;

SELECT 
*
FROM right_products;


SELECT
*
FROM left_products
NATURAL LEFT JOIN right_products;

SELECT
*
FROM left_products
NATURAL RIGHT JOIN right_products;


SELECT
*
FROM left_products
NATURAL INNER JOIN right_products;