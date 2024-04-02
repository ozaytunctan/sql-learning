--- Sum with SUM function
---#######################################3

--select sum(columnname) FROM tablename

-- 1. lets look at all movies revenues record

SELECT * FROM movies_revenues

-- 2. Get total domestic revenues for all movies

SELECT 
  SUM(revenues_domestic)
FROM movies_revenues;

-- 3. Get total domestic revenues for all movies where domestic revenue is grather than 200

SELECT 
  SUM(movie_length)
FROM movies
WHERE movie_lang='English';

-- 4. Can I sum all movies name 


SELECT 
  SUM(movie_length)
FROM movies

---MIN & MAX

select MIN(movie_length),
       MAX(movie_length),
	   SUM(movie_length),
	   SUM(DISTINCT movie_length)
FROM movies;


---LEAST EN KÜÇÜĞÜ
-- GREATEST EN BÜYÜĞÜ
--#################################


select 
  revenues_domestic,
  revenues_international,
  LEAST(revenues_domestic,revenues_international),
  GREATEST(revenues_domestic,revenues_international)
  
from movies_revenues




CREATE TABLE personel (
  id SERIAL PRIMARY KEY ,
  first_name VARCHAR(80),
  last_name VARCHAR(100),
  salary NUMERIC(14,2) CHECK (salary>0),
  department VARCHAR(250)
)

INSERT INTO personel(first_name,last_name,salary,department)
VALUES 
('Özay' ,'TUNÇTAN',70000.00,'SOFTWARE'),
('Erdal' ,'Ağça',90000.00,'SOFTWARE'),
('Alihan' ,'Bayraktar',44000.00,'SOFTWARE'),
('Mustafa ' ,'Burak',30000.00,'SOFTWARE'),
('Kağan' ,'Esen',10000.00,'SOFTWARE'),
('Nazlı' ,'KOCA',60000.00,'IK'),
('Neriman' ,'Merve',80000.00,'IK'),
('Uğur' ,'AltınTaş',94000.00,'IK'),
('Eylül ' ,'TUNÇTAN',30000.00,'IK'),
('Yağmur' ,'AYDIN',25000.00,'IK')

select * from personel;

SELECT T.*
FROM ( SELECT FIRST_NAME,LAST_NAME,SALARY,DEPARTMENT,
			ROW_NUMBER() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS MAX_SALARY_DEPARTMENTS_ROW_NO
		FROM PERSONEL
	 ) T
WHERE MAX_SALARY_DEPARTMENTS_ROW_NO <= 3
