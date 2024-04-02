--- joining multiple tables via JOIN
--############################33

-- we can join multiple tables together via JOIN statment

-- 1. Lets join movies ,directors and movies tables

SELECT
*
FROM movies mv
INNER JOIN directors d ON mv.director_id=d.director_id
INNER JOIN movies_revenues r ON mv.movie_id = r.movie_id


--- 2. Do the order of the tables joining matters ?

SELECT 
*
FROM movies mv
INNER JOIN directors d ON mv.director_id=d.director_id
INNER JOIN movies_revenues r ON mv.movie_id = r.movie_id


SELECT 
*
FROM directors d 
INNER JOIN  movies mv ON mv.director_id=d.director_id
INNER JOIN movies_revenues r ON mv.movie_id = r.movie_id;


-- 3. Lets join movies actors ,directors , moveis revenues together

SELECT 
*
FROM actors ac
JOIN movies_actors ma ON ac.actor_id = ma.actor_id
JOIN movies mv ON ma.movie_id = mv.movie_id
JOIN directors d ON mv.director_id = d.director_id
JOIN movies_revenues r ON mv.movie_id=r.movie_id


-- 4. Is JOIN is same as INNER JOIN ?

SELECT 
*
FROM actors ac
INNER JOIN movies_actors ma ON ac.actor_id = ma.actor_id
INNER JOIN movies mv ON ma.movie_id = mv.movie_id
INNER JOIN directors d ON mv.director_id = d.director_id
INNER JOIN movies_revenues r ON mv.movie_id=r.movie_id

--
