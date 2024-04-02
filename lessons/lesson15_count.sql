---Count result using  COUNT
--################################3

-- SELECT COUNT(*) FROM tablename
-- select count(column_name) from tablename

--1. Count all record
-- Count total numerber of departments

select COUNT(*) FROM movies

-- 2. Count all record of a specific column

SELECT COUNT(movie_lang) FROM movies;

-- 3. Using Count with DISTINCT
-- count all distinct movie_lang 
-- WITHOUT DISTINCT clause 

SELECT COUNT(movie_lang) FROM movies;

SELECT COUNT(DISTINCT movie_lang) FROM movies;

select * from movies;




