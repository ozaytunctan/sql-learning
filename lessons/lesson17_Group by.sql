---Gruping records by GROUP BY
--##########################
/*
*The GROUP BY clause divedes the rows returned from the slect statement şnto groups
-- for each , you can apply an aggregate function like COUNT,SUM,MIN,MAX,AVG etc.
SELECT
column1
AGGREGATE_FUNCTION(column2)
from table_name
GROUP BY column1
*
*/ -- GROUP BY eliminates duplicate values from the results , similar to DISTINCT
-- 1. Get total count of all movies group by movie_length

SELECT MOVIE_LENGTH,
	COUNT(DISTINCT MOVIE_LENGTH)
FROM MOVIES
GROUP BY MOVIE_LENGTH
SELECT MOVIE_LANG,
	COUNT(*)
FROM MOVIES
GROUP BY MOVIE_LANG;

-- 2. Get average novie length group by movie language

SELECT MOVIE_LANG,
	AVG(MOVIE_LENGTH)::NUMERIC(14,2),
	CAST(AVG(MOVIE_LENGTH) AS NUMERIC(14))																									2))
FROM MOVIES
GROUP BY MOVIE_LANG;

-- 3. Get the sum total movie length per age certificate

SELECT AGE_CERTIFICATE,
	SUM(MOVIE_LENGTH)
FROM MOVIES
GROUP BY AGE_CERTIFICATE ;

-- 4. List minimum and maximum movie length group by movie language

SELECT MOVIE_LANG,
	MIN(movie_length),
	MAX(movie_length)
FROM MOVIES
GROUP BY MOVIE_LANG
ORDER BY MAX(movie_length) DESC;

-- 5. Can we use group by without aggregate function

SELECT movie_length
FROM movies
GROUP BY movie_length;


SELECT movie_length
FROM movies
order by movie_length;

-- 6. Can we use columns ,aggregate function without sepeciffy group by column ?

select 
movie_lang,
MIN(movie_length),
MAX(movie_length)
FROM movies 
GROUP BY movie_lang
ORDER BY MAX(movie_length) desc


-- 7. Using more than 1 columns şn selcr 
-- Get average lenght hroup by movie  language and age certification

select 
movie_lang,
age_certificate,
AVG(movie_length) AS "Avg movie lenght"
FROM movies 
GROUP BY movie_lang,age_certificate
ORDER BY movie_lang, 3 desc;


-- 8 Can we not use group by on all column

select 
movie_lang,
age_certificate,
AVG(movie_length) AS "Avg movie lenght"
FROM movies 
GROUP BY movie_lang,age_certificate
ORDER BY movie_lang, 3 desc;


-- 9. Lets filter some record too 

SELECT
movie_lang,
age_certificate,
movie_length,
AVG(movie_length) AS "avg_movie_length"
FROM movies
WHERE movie_length>100
GROUP BY movie_lang,age_certificate,movie_length

-- 10. Get average t movie length group by movie  age certificate where age certificate =10

SELECT 
 age_certificate,
 AVG(movie_length) AS "avg_movie_length"
 FROM movies
WHERE age_certificate='PG'
GROUP BY age_certificate


-- 11. 

-- 12 . How many directors are there per each nationality 

SELECT 
nationality,
COUNT(*)
FROM directors
GROUP BY nationality
ORDER BY 2 DESC;

-- 13.  Get total sum movie lenght for each age certificate and movie languae combination
-- order by  two column --> ORDER BY 2 --> Order By age_certificate
SELECT 
  movie_lang,
  age_certificate,
  SUM(movie_length)
  FROM  movies
  GROUP BY  movie_lang,age_certificate
  ORDER BY 1 DESC;
  
---- Order of execution in GROUP BY 
-- #########################################

-- Postgresql aevulates the GROUP by clause after the FROM and WHERE clause and before
-- the HAVING,SELECT,DISTINCT, ORDER BY and LIMIT  clauses

FROM 

WHERE --conditions

GROUP BY -- group sets

HAVING -- filter again

SELECT -- columns

DISTINCT --unigue columns if you use DISTINCT

ORDER BY -- sorting

LIMIT


--- HAVING AGGREGATE_FUNCTION(column2)>=value
--
--

--- 1. List movies langueages where sum total lenght of the movies is grather tahn 200

SELECT
movie_lang,
sum(movie_length)
FROM movies
GROUP BY movie_lang
HAVING  sum(movie_length)>=200
ORDER BY sum(movie_length)


-- 2. list directors where their sum total movie length is grather than 200

SELECT
director_id,
sum(movie_length)
FROM movies
GROUP BY director_id
--HAVING  sum(movie_length)>=200
HAVING  sum(movie_length)>=200
ORDER BY director_id,sum(movie_length)

-- 3. Can we use column aliases witg havıng clause ?

SELECT 
director_id,
sum(movie_length) as tml
FROM movies
GROUP BY director_id 
--HAVING BY tml>200
HAVING SUM (movie_length)>200
ORDER BY  2 desc

-- Order of 
