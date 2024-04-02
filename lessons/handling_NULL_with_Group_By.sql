-- Handling NULL values with group by 
--#####################################

-- 1. Lets create our test table 'employees_test' with some data e.g.
--
--#######################################################

CREATE TABLE employess_test (
	employee_id SERIAL PRIMARY KEY ,
	employee_name VARCHAR (100),
	department VARCHAR(100),
	salary NUMERIC(14,2) CHECK (salary>=0)
)

-- 2. Lets view the contents

SELECT * from employess_test

ALTER TABLE employess_test
RENAME TO employees_test

-- 3. Lets insert some data

INSERT INTO employees_test(employee_name,department,salary)
VALUES
('Özay', 'Finance',2500),
('John',NULL, 3000),
('Adam',NULL,4000),
('Mary',NULL,400),
('Alihan','Finance',4000),
('Linda','IT',5000),
('Megan','IT',3800);


select * from employees_test

-- 4. Lets display all department

SELECT 
* 
FROM employees_test
ORDER BY department

-- 5. How many employees are there for each group

SELECT 
department,
count(salary) as total_employess
FROM employees_test
GROUP BY department
ORDER BY department ;


-- 6 . Lets handle NULL values 
-- COALESCE (source,'')
-- COALESCE (departmen,'NO DEPARTMENT')


SELECT 
COALESCE (department,'* NO DEPARTMENT *') AS department,
count(salary) as total_employess
FROM employees_test
GROUP BY 
   department
ORDER BY 
   department
