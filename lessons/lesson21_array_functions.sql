-- Array Functions 
-- IN,ALL, SOME,ANY , ARRAY


--

SELECT 
10 IN(1,3,4,5,10,23) as "result",
100 IN(1,3,4,5,10,23) as "result"

/* NOT IN OPERATOR 
---- expression NOT IN (value, [....])
-- expression<>value1


*/

SELECT 
10 NOT IN(1,3,4,5,10,23) as "result",
100 NOT IN(1,3,4,5,10,23) as "result"


-- ANY Operator
--

SELECT 
25=ALL(ARRAY[25,25,25]) as "result",
25=ALL(ARRAY[1,2,3,25]) as "result",
25=ANY(ARRAY[1,2,3,25]) as "result",
20=ANY(ARRAY[1,2,3,25]) as "result",
25=ANY(ARRAY[1,2,3,25,NULL]) as "= ANY with NULLS",
25<>ANY(ARRAY[1,2,3,25,NULL]) as "!= ANY with NULLS",
25=SOME(ARRAY[1,2,3,25]) as "!= ANY with NULLS"



-- Using Arrays in tables 
--#####################################

--1. Lets create a atble with array data

CREATE TABLE teachers (
	teacher_id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	phones TEXT []
);

-- You can also use ARRAY as keyword to create a array data type 

CREATE TABLE teachers1 (
	teacher_id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	phones TEXT ARRAY
)

-- Please note, the phones column is a ONE-DIMENSIONAL  array  that holds various phone numbers that a contact may have.


--- Insert data into arrays
-- ##############################
/*

1. We use single qquotes ' to wrap the arary or use ARRAY function

2. Fon non-text data, we can user curly braces {}

   '{value1,value2}'
   
   ARRAY[value1,value2]
   
 3. For text-data ,we use double quotes ""
 
  '{"value1","value2"}'
  
  ARRAY ['value1','value2']  -- single quote when using ARRAY  function

*/

INSERT INTO teachers(name,phones)
VALUES
( 'Özay2', ARRAY['(538)-111-11-11','(538)-111-11-12','(538)-111-11-13'])


INSERT INTO teachers(name,phones)
VALUES
('Adam','{"(538)011-04-67"}'),
('Özay','{"5380110467","05374453243","(444)-786-123456"}');

SELECT * from teachers;


--Query array data
-- #############################33

--Find all phones record

SELECT
name,
phones
FROM
	teachers


-- How to access array elements
-- 

-- We acces arary element using subscript witin sguare brackets [],
-- The first array start with number 1


SELECT
name,
phones[1],
phones[2]
FROM 
	teachers;

--Can we user filter condition

SELECT
*
FROM 
	teachers
WHERE 
	phones[1]='5380110467';

-- How about search any array for all them

SELECT
*
FROM 
	teachers
WHERE 
	'5380110467' = ANY(phones);
	
-- Modify Array contents
--- #####################333

UPDATE teachers
SET phones[2]='(000)-123-4567'
where teacher_id=2
RETURNING *;



--Dimenstions are ignored by POSTGRESQL
--#######################################

--Lets create a table with only one ARRAY dimension

CREATE TABLE teachers2(
teacher_id SERIAL PRIMARY KEY,
name VARCHAR(150),
phones TEXT ARRAY[1] --limit 1 ignored
)


--Can we add two phones record eventhough we define ARRAY[1] ?

INSERT INTO teachers2(name,phones)
VALUES
(
'Özay', ARRAY['(111)-111-11-11','(538)-011-04-67']
)


SELECT * from teachers2;


-- Display all array elements
-- #########################33

-- unnest (anyarray) 
-- function is used to expand an array to set of rows

SELECT
teacher_id,
name,
unnest(phones)
FROM
	teachers2;
	
	
	
-- lest use an ORDER BY  for phone numbers;

SELECT
teacher_id,
name,
unnest(phones)
FROM
	teachers2
ORDER BY 3;



---Using MULTI-DIMENSIONAL ARRAY

--Lets cerate a table "students" where will store store grades along with the year i.d. mult-dimension

CREATE TABLE students(
student_id SERIAL PRIMARY KEY,
student_name VARCHAR(100),
student_grade INTEGER [][]
)


INSERT INTO students (student_name,student_grade)
VALUES
('s1','{90,2020}')

SELECT student_grade[2] FROM students 


-- insert multiple input data

INSERT INTO students(student_name,student_grade) 
VALUES
('S2','{80,2020}'),
('S3','{70,2019}'),
('S4','{60,2019}')
	

SELECT * FROM students 

--How  to get specific arary dimesion data

SELECT student_grade[1] FROM students ;

SELECT student_grade[2] FROM students ;


--Seraching in multi-dimesional array
--Serach all students with grade year 2020


SELECT * FROM students WHERE student_grade @>'{2020}' ;

SELECT * FROM students WHERE 2020=ANY(student_grade);

--Search all student wit grade greather than 70

SELECT * FROM students WHERE student_grade[1]>70

