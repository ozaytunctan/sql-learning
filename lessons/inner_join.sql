-- INNER JOINS 
--###########################
/**

--* POSTGRESQL join is used combine/attach columns from one or more tables based on the values of the 
-- COMMON COLUMNS between tables

-- * These COMMON COLUMNS are generally

-- PRIMARY KEY COLUMN of first table and FOREIGN KEY COLUMN  of the second table
*/


/**
SELECT *
 FROM first_table
     JOIN second_table
	 on first_table.key_column=second_table.foregin_key_column
	 
SELECT *
 FROM first_table
     INNER JOIN second_table
	 on first_table.key_column=second_table.foregin_key_column	 
*/


-- For Inner joins : All common columns defined at ON must match values on both tables

-- 1. Let combine 'movies' and 'directors' tables


SELECT 
*
FROM movies
   ORDER BY director_id

-- directors.director_id=movies.director_id

SELECT 
movie_id
movie_name,
directors.director_id
FROM directors 
INNER JOIN movies ON directors.director_id=movies.director_id;


-- 2. Using Joins with an alias
-- Normal way --long way!

SELECT 
movie_id
movie_name,
directors.director_id
FROM directors 
INNER JOIN movies ON directors.director_id=movies.director_id;

-- Alias way
SELECT 
mv.movie_id,
mv.movie_name,
d.director_id,
mv.movie_lang,
d.first_name
FROM movies mv
 INNER JOIN directors d 
 ON mv.director_id=d.director_id;
 
 
 
-- 3. Lets filter some records

SELECT 
mv.movie_id,
mv.movie_name,
d.director_id,
mv.movie_lang,
d.first_name
FROM movies mv
 INNER JOIN directors d 
 ON mv.director_id=d.director_id
  WHERE movie_lang='English' AND d.director_id=3

--- INNER JOIN with USING
-- #############################

--We use using only when joining tables have same columsn names , rather than ON!.

-- Lets say the SAME COLUMN name is column1

SELECT tables1.column1
        table1.column2
	FROM table1
	INNER JOIN table2 USING(column1)
	
	
-- 1. Lets connect 'movies' and 'directors' table with USING keyword

SELECT
*
FROM movies 
INNER JOIN directors USING (director_id);

-- <> 

SELECT * FROM movies 
 INNER JOIN directors ON movies.director_id=directors.director_id;
 
 
 -- 2. Can we connect 'movies' and 'movie_revenues' too ?
 -- WHAT US COMMON ? movie_id
 
 select 
 *
 FROM movies 
 INNER JOIN movies_revenues USING(movie_id)
 
 
 
 -- 3. Can we connect more than two table
 -- Connect 'movies', 'directors' and 'movies_revenues' tables
 
 -- movies->directors  movies.director_id =directors.dirdctor_id
 -- movies->movie_revenues  movies.movie_id=movie_revenues.movies_id
 
SELECT
mv.movie_name,
d.first_name

FROM movies mv
INNER JOIN directors d USING(director_id)
INNER JOIN movies_revenues mvr USING(movie_id);


-- 4. Select movie_name ,director name, domestic_revenues fro all japanese movies


SELECT
mv.movie_name,
d.first_name,
d.last_name,
r.revenues_domestic
FROM movies mv
INNER JOIN directors d ON mv.director_id = d.director_id
INNER JOIN movies_revenues r ON mv.movie_id = r.movie_id
WHERE mv.movie_lang='Japanese';


-- 5. Select movie name , director name for all English ,Chinese and Japanese movies where domestic revenues is grather
-- than 100

SELECT
mv.movie_name,
d.first_name,
d.last_name,
r.revenues_domestic
FROM movies mv
INNER JOIN directors d ON mv.director_id = d.director_id
INNER JOIN movies_revenues r ON mv.movie_id = r.movie_id
WHERE mv.movie_lang in ('English','Chinese','Japanese')
     AND r.revenues_domestic>100 ;


-- 6. select movie name, director name , movie language , total revenues for all top 5 movies

SELECT
mv.movie_name,

d.first_name,
d.last_name,

r.revenues_domestic,
r.revenues_international,

(COALESCE(r.revenues_domestic,0) + COALESCE(r.revenues_international,0)) as "totalRevenues"

FROM movies mv
INNER JOIN directors d ON mv.director_id=d.director_id
INNER JOIN movies_revenues r ON mv.movie_id = r.movie_id
ORDER BY 6 desc NULLS LAST
LIMIT 5;


-- 7. What where top 10 most profitable movies between  year 2003 and 2008 . Print the movie name, direcor id etc.

SELECT
mv.movie_name,
mv.movie_lang,
DATE_PART('YEAR',mv.release_date) as "relaseYear",

d.first_name,
d.last_name,

r.revenues_domestic,
r.revenues_international,
(COALESCE(r.revenues_domestic,0) + COALESCE(r.revenues_international,0)) as "totalRevenues"

FROM movies mv
INNER JOIN directors d ON mv.director_id=d.director_id
INNER JOIN movies_revenues r ON mv.movie_id = r.movie_id
WHERE DATE_PART('YEAR',mv.release_date) between 2003 and 2008
ORDER BY 7 DESC NULLS LAST 
LIMIT 10;

