--What is JSON
-- ####################################

/*

1. JSON standa for "Javascript 	Object Notification" which is a type of data format populary used b ywen appalications

2. JSON was introduced as an alternative to the XML format . In the "good old days"
 the data used to get transmitted in XML format which is heavy weight data type compared ot JSON
 
 3. JSON is a lightweight format for storing and transporting data
 
 4. JSON is a syntax for storing and exchanging data.
 
 5. JSON is "self-describing" and easy to understand . It is human readable
 

*/

/**
-- 1. Data is in anme/value pairs
A name /value pair consists of a field name (in double quotes) ,followed by a column , flowed by value.

name:value

"firstName":value

2. Data is separated by  commas 

"fisrtname":"özay","Country":"tr"

3. Curky braces {} hold objects

JSON objects are written inside curly braces.

{}

{"firstName":"Özay"}

{"firstName":"Özay","lastName":"TUNÇTAN"}



4. sGUARE BRACKETS [] hold objects

[
{objects}
]

exmaple:

"contacts":[
{"firstName":"Özay","lastName":"TUNÇTAN"},
{"firstName":"Adam","lastName":"Johnson"}
]
*/


--JSON in PostgreSQL
--#####################################3

-- 1. Two ways to store JSON data in POSTGRESQL (JSON and JSONB)

/**

JSON                                                      JSONB
--------------------------                                ------------------------------------------
Pretty much like a TEXT data wich stores                  Stores the JSON document in Binary format (JSONB)
only valid JSON document


Stores the JSON documents as-is including white spaces    Trims pff white spaces and stores in a formant conducive of faster and efficient searches

JSON is faster as it 


*/

--Exploring JSON objects

-- 1. How will you represent a JSON object in POSTGRESQL

SELECT '{"title":"The world of the rings"}'::TEXT

-- 2. Do you have cast data type to makr it json data type ?

SELECT '{
"title":"The world of the rings"
}'::JSON

-- 3. Can we preserve white spaces , if yes how ?


-- 4. What if we do not want white spaces ?

SELECT '{
    "title":"The world of the rings",
	"author":"J.R.R"
}'::jsonb



--Create our first table a with  JSONB data type
--################################33

--1. Create a table called "books"

CREATE TABLE books (
book_id SERIAL PRIMARY KEY,
book_info JSONB
)



-- 2. Insert some JSON data

-- Single record

INSERT INTO books (book_info)
VALUES
('{
 "itle":"Book title1",
 "author":"author1"
 }')
 
 SELECT 
 * FROM books
 
 
 --multiple record
 
INSERT INTO books (book_info)
VALUES
('{
 "title":"Book title2",
 "author":"author2"
 }'),
 
 ('{
 "title":"Book title3",
 "author":"author3"
 }'),
 
 ('{
 "title":"Book title4",
 "author":"author4"
 }')
 
 
 -- 3. Select all JSON data
 
 SELECT * FROM books;
 
 -- 3. 1 Lets use selectors ( ->, ->>)
 
-- The -> operator returns the JSON Object as a field in quotes

Select book_info FROM books;

SELECT book_info->'title' from books;


-- the operator ->> return the JSON object field as TEXT

SELECT
book_info ->>'title' as title ,
book_info->>'author' as author 
FROM books;


-- 4.Select and filter records

SELECT
book_info ->>'title' as title ,
book_info->>'author' as author 
FROM books 
WHERE  book_info->>'author' ='author1';


---Update JSON data
--####################

-- 1. Lets insert a sample record

select * from books;

INSERT INTO books (book_info)
VALUES
( 
	'{
	"title":"Book title 10", "author":"author10"
	}'
)


-- 2. Lets update a record

--We will use ||concetenation operator , which will
-- add field or
-- replace existing field

--Let update "author10" with "özay"

UPDATE books
SET book_info=book_info || '{"author":"özay"}'
WHERE  book_info->>'author' ='author10';

select * from books;


UPDATE books
SET book_info=book_info || '{"title":"The future 2.0"}'
WHERE  book_info->>'author' ='özay'
RETURNING *;


-- Add additional field like "Best Seller" with booelan value

UPDATE books
SET book_info=book_info || '{"bestSeller":true}'
WHERE  book_info->>'author' ='özay'
RETURNING *;


-- 4. Lets add multiple key/values e.g category,pages etc.

UPDATE books
SET book_info=book_info || '
{
"category":"Science", 
"pages":40
}'
WHERE  book_info->>'author' ='özay'
RETURNING *;


-- 5. Delete Best Seller booelan key/value
-- to delete we will use - operator

UPDATE books
SET book_info=book_info - 'bestSeller'
WHERE  book_info->>'author' ='özay'
RETURNING *;


-- 6. Add a nested array data in JSON. e.g availability_locations like 'Ankara' , "İstanbul"

UPDATE books
SET book_info=book_info || '{"availability_locations":[
"Ankara",
"İstanbul"
]}'
WHERE  book_info->>'author' ='özay'
RETURNING *;


-- 7. Delete from array via path '#-'
-- Ankara ,İstanbul  --> 0,1
UPDATE books
SET book_info=book_info #-'{availability_locations,1}' 
WHERE  book_info->>'author' ='özay'
RETURNING *


--Create JSON table 
--###############################

-- 1. Lets output directors table into JSON format

SELECT * FROM directors;

select row_to_json(directors) from directors;


-- 2. Now about taking only dirsctos_id , first_name , and nationality from the dirdctors table

SELECT row_to_json (T)
FROM
	(SELECT DIRECTOR_ID,
			FIRST_NAME,
			LAST_NAME,
			NATIONALITY
		FROM directors) AS T;
		


--use json_agg() to aggregate data
--#############################

-- 1. Lets  list movies for each directos;

Select 
*
from movies;

select 
* ,
(
SELECT json_agg(x) as  "allMovies" FROM
	(
	SELECT movie_name
	FROM movies
		WHERE director_id=d.director_id
	) x
)
from directors d;

--2. Select director_id ,first_name,last_name and all movies created by that director

Select 
*
from movies;

select 
d.director_id ,
d.first_name,
d.last_name,
(
SELECT json_agg(x) as  "allMovies" FROM
	(
	SELECT movie_name
	FROM movies
		WHERE director_id=d.director_id
	) x
)
from directors d;



--- Build a json array
--#########################

json_build_array(values);

-- 1. Lets build a sample array with numbers

SELECT json_build_array(1,2,3,4,6);

-- 2. can we do strings and numbers togethers

SELECT json_build_array(1,2,3,4,6,'Hii');

-- 3. Lets build a sample array
-- json_build_object (key/value)

SELECT json_build_object(1,2,3,4,5,'Hi');

-- 4. Can we supply key/value style data

select json_build_object ('name','özay','email','ozaytunctan@gmail.com')


json_object((keys),(values));

select json_object ('{name,email}','{"Özay tunçtan","ozaytunctan@gmail.com"}');


-- Create documents drom data
--########################33333

-- 1. lets create a table called "directors_docs"ö

CREATE TABLE directors_docs (
id SERIAL PRIMARY KEY,
body JSONB
)


-- 3. Prep data for insert operations
-- Lets get all movies by each directos in JSON array format
INSERT INTO directors_docs(body)
SELECT row_to_json(a)::jsonb FROM (
SELECT
director_id,
first_name,
last_name,
date_of_birth,
nationality,
(
SELECT json_agg(x) as all_movies from 
	(
	select movie_name
		FROM movies
		WHERE director_id=directors.director_id
	) as x
)
FROM directors ) AS a;



--Insert data

SELECT *
FROM directors_docs;


--Null values in JSON document
--##########################3

-- 4. Lets have a quick data check

SELECT *
FROM directors_docs;

SELECT jsonb_array_elements(body->'all_movies')
FROM directors_docs 
WHERE (body->'all_movies') IS NOT NULL;


-- 5. Lets populate the data with empty array element for all_movies

delete from directors_docs;


INSERT INTO directors_docs (body)
SELECT row_to_json(a)::jsonb FROM (
SELECT
director_id,
first_name,
last_name,
date_of_birth,
nationality,
(
SELECT CASE COUNT(x) WHEN 0 THEN '[]' ELSE json_agg(x) END as all_movies from 
	(
	select movie_name
		FROM movies
		WHERE director_id=directors.director_id
	) as x
)
FROM directors ) AS a

select * from directors_docs


--Getting information from JSON documents
-- #########################333

-- 1. Count total movies for each directors

jsonb_array_length

SELECT 
*,
jsonb_array_length(body->'all_movies') as total_movies
FROM directors_docs
order BY jsonb_array_length(body->'all_movies') ;

-- 2. List all the keys within each jsON row
jsonb_array_keys

SELECT 
jsonb_object_keys(body) as total_movies
FROM directors_docs;

-- what is you want to see key/value style output

SELECT 
j.key,
j.value
FROM directors_docs ,jsonb_each(directors_docs.body) as j;


SELECT 
j.*
FROM directors_docs ,jsonb_to_record(directors_docs.body) as j(
director_id INT,
first_name VARCHAR(255),
nationality VARCHAR (100)
);


-- The existence operator ?
-- #############################

-- 1. Find all first name equal to 'Özay'

SELECT
*
FROM directors_docs
WHERE body->'first_name' ? 'Özay';



SELECT
*
FROM directors_docs
WHERE body ? 'Özay'