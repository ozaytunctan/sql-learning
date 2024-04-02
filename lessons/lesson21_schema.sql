--- CREATE SCHEMA
--#########################33

--CREATE SCHEMA schema_name

CREATE SCHEMA test_schema;

-- Mevcut Şemayı silme 

DROP SCHEMA test_schema;

-- Şema içinde tablo oluşturma
--

DROP TABLE IF EXISTS test_schema.products;

CREATE TABLE test_schema.products (
product_id SERIAL PRIMARY KEY,
product_name  VARCHAR (100)
)

-- Mevcut şemanın adını değiştirme 
--

ALTER SCHEMA test_schema RENAME TO old_schema;


-- Mevcut tablonun şemasını değiştirme
--

ALTER TABLE old_schema.products SET SCHEMA test_schema;


-- İki farklı şemadaki veriyi listeleme
-- 
SELECT 
*
FROM public.left_products p 

UNION

SELECT 
*
from test_schema.products p2;


---

DROP SCHEMA old_schema;

DROP TABLE test_schema.products
DROP SCHEMA test_schema;


