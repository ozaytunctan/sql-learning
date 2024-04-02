--##################CONSTRAINTS################
--########
--##############################################

CREATE TABLE cart_item (
 id BIGINT NOT NULL  DEFAULT nextval('cart_item_id_seq')  ,
 name VARCHAR(150),
 quantity INTEGER DEFAULT 1,
 price NUMERIC(14,2)
  
)
ALTER TABLE cart_item
ADD CONSTRAINT cart_item_id_pkey PRIMARY KEY(id)

ALTER TABLE cart_item
ADD CONSTRAINT cart_item_unique UNIQUE(id)

ALTER TABLE cart_item
DROP CONSTRAINT cart_item_unique

INSERT INTO cart_item(id,name,quantity,price)
VALUES
(1,'Ayakkabı 42 numara',2,1600.56)

SELECT* from cart_item;

INSERT INTO cart_item(name,quantity,price)
VALUES
('Ayakkabı 42 numara',2,1600.56),
('Gömlek',1,600)


CREATE TABLE t_products(
 id INT PRIMARY KEY ,
 name VARCHAR(100) NOT NULL,
 supplier_id INT NOT NULL ,
 FOREIGN KEY (supplier_id) REFERENCES t_suppliers(id)
);

SELECT * FROM t_products;

CREATE TABLE t_suppliers(
 id INT PRIMARY KEY,
 name VARCHAR(100) NOT NULL
)

SELECT * FROM t_suppliers;

--lets insert some data

INSERT INTO t_suppliers(id,name)
values
(100,'Supplier100')
(1,'Supplier1'),
(2,'Supplier2'),
(3,'Supplier3')

SELECT * FROM t_suppliers;

INSERT INTO t_products(id,name,supplier_id)
VALUES
(4,'COMPUTER',100)
(1,'PEN',1),
(2,'PAPER',2)

SELECT * FROM t_products;

--lets try to delete data from the child or foreign table
DELETE FROM t_products WHERE id=4
DELETE FROM t_suppliers WHERE id=100 

-- lets try update a data on parent table 
UPDATE t_products SET supplier_id=2 where id=1;

--how to drop a contraint
--#######################3
ALTER TABLE tablename
DROP CONSTRAINT cname

ALTER TABLE t_products
DROP CONSTRAINT t_products_supplier_id_fkey;

--Update foreign key constraints on an esisting table
--#############################
ALTER TABLE tablename
ADD CONSTRAINT cname FOREIGN KEY (columnname) REFERENCES table2name(columnname)

ALTER TABLE t_products
ADD CONSTRAINT t_products_supplier_id_fkey 
    FOREIGN KEY(supplier_id) REFERENCES t_suppliers(id);
	
	
--- ########################### CHECK CONTRAINT ###############
---POSTGRESQL constraint : CHECK
--Define CHECK cosntaint for new tables 
CREATE TABLE staff(
id SERIAL PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
birth_date DATE CHECK(birth_date>'1900-01-01'),
joined_Date DATE CHECK(joined_date>birth_date),
salary NUMERIC CHECK (salary>0)
)

select * from staff;

INSERT INTO staff(first_name,last_name,birth_date,joined_date,salary)
VALUES('Özay','TUNÇTAN','1993-06-22','2022-05-30',8000.00)

INSERT INTO staff(first_name,last_name,birth_date,joined_date,salary)
VALUES
('Ada','TUNÇTAN','2021-01-31','2022-05-30',15000.00)

INSERT INTO staff(first_name,last_name,birth_date,joined_date,salary)
VALUES
('Yağmur','TUNÇTAN','2021-01-31','2022-05-30',-15000.00)
	
(tablename)_(columnname)_check

UPDATE staff SET salary=2000.00 where id=1;

select * from staff;

-- Define CHECK constraint for existing table

CREATE TABLE prices (
  id SERIAL PRIMARY KEY,
  product_id INT NOT NULL ,
  price NUMERIC NOT NULL,
  discount NUMERIC NOT NULL,
  valid_from DATE NOT NULL
)

select * from prices ;

-- price>0 and discount >=0 and price>discount

ALTER TABLE prices
ADD CONSTRAINT price_check 
CHECK (
	price>0
    AND discount>=0
	AND price>discount
)

INSERT INTO prices(product_id,price,discount,valid_from)
VALUES
(1,100.00,120,'2024-10-01')

select * from prices ;

--Rename constraint on new table

ALTER TABLE prices
RENAME CONSTRAINT price_check TO price_discount_check;

--drop a constaint
ALTER TABLE prices
DROP CONSTRAINT price_discount_check



