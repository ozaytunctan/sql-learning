--UNION VS UNION ALL
--##########################

-- UNION
-- Unique olan tüm satırları sonuç olarak döner.

SELECT
product_id,
product_name
FROM left_products
UNION
SELECT
product_id,
product_name
FROM right_products;

--UNION ALL
-- Duplicate olan tüm satırlar dahil sonuç döner.
SELECT
product_id,
product_name
FROM left_products
UNION ALL
SELECT
product_id,
product_name
FROM right_products;



--INTERSECT
-- İki tabloda ortak olan satırları döner.


SELECT
product_id,
product_name
FROM left_products
INTERSECT
SELECT
product_id,
product_name
FROM right_products;

--EXCEPT
-- İlk sorgu sonucunun İkinci sorguda olmayan satırları sonuç olarak döner.
SELECT
product_id,
product_name
FROM left_products
EXCEPT
SELECT
product_id,
product_name
FROM right_products;
