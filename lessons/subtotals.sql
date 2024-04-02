----Group BY
---#####################################

-- 1. Lets create out table in which we will be calculating the subtotals.

CREATE TABLE courses (
course_id SERIAL PRIMARY KEY,
course_name VARCHAR(100) NOT NULL,
course_level VARCHAR(100) NOT NULL,
solid_units INT NOT NULL
)

-- 2. Lets browse data

select * from courses

-- 3. Lets insert some test data

INSERT INTO courses(course_name,course_level,solid_units)
VALUES
('Machine Learning with Pyhton','Premium',100),
('Data Science Bootcamp','Premium',50),
('Introduction to Pyhton','Basic',200),
('Understand MongoDB','Premium',100),
('Algorithm Desing in Python','Premium',200);

select * from courses;

select * from courses
ORDER BY course_level, solid_units

-- 4. Lets organize the data 

SELECT
course_level,
course_name,
solid_units
FROM courses;

--- 4. Lets find total unit sold by each course level

SELECT
course_level,
--course_name,
SUM(solid_units) AS "totalSold"
FROM courses
GROUP BY course_level
--,course_name;

-- 5. Lets ROLLUP

SELECT
course_level,
course_name,
SUM(solid_units) AS "totalSold"
FROM courses
GROUP BY
ROLLUP(course_level,course_name)
ORDER BY 
course_level,course_name

-- 6. We can even do a partial rollup two 


SELECT
course_level,
course_name,
SUM(solid_units) AS "totalSold"
FROM courses
GROUP BY
course_level,
ROLLUP(course_name)
ORDER BY 
course_level,course_name;


-- Adding Subtotals with ROLLUP
--########################

-- 1. Lets create a test table of inventory item
CREATE TABLE inventory(
inventory_id SERIAL PRIMARY KEY ,
category VARCHAR(100) NOT NULL ,
sub_category VARCHAR(100) NOT NULL,
product VARCHAR (100) NOT NULL ,
quantity INT
)

-- 1. Lets insert some sample data

INSERT INTO inventory (category,sub_category,product,quantity)
VALUES
('Furniture','Chair', 'Black',10),
('Furniture','Chair', 'Brown',10),
('Furniture','Desk', 'Blue',10),
('Equipment','Computer', 'Mac',5),
('Equipment','Computer', 'PC',5),
('Equipment','Computer', 'Dell',10);


select 
*
from inventory;


-- Lets group data byy  category and subcategory i.e product is broken down by category and sub category

SELECT
category,
SUM(quantity) as "Quantity"
FROM inventory 
GROUP BY category


-- Furniture 30,Equipment 20
SELECT
category,
sub_category,
SUM(quantity) as "Quantity"
FROM inventory 
GROUP BY category, sub_category;


-- 4. What if we want to see the subtotal of each  catgeory and a final total
---

SELECT
category,
sub_category,
SUM(quantity) as "Quantity"
FROM inventory 
GROUP BY 
ROLLUP(category, sub_category)
ORDER BY 
category, 
sub_category;

----


SELECT
category,
sub_category,
SUM(quantity) as "Quantity"
FROM inventory 
GROUP BY 
category,
ROLLUP(sub_category)
ORDER BY 
category, sub_category;


---

SELECT
category,
sub_category,
SUM(quantity) as "Quantity",
GROUPING(category) as "category_group"b
FROM inventory 
GROUP BY 
category,
ROLLUP(sub_category)
ORDER BY 
category, sub_category;