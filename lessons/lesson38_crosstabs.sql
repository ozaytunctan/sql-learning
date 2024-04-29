-- Crosstab
--############################################
-- v506

-- 1. Install the extension

CREATE EXTENSION IF NOT EXISTS tablefunc;

-- 2. Confirm  if the extension is installed.

SELECT * FROM pg_extension;


-- Using crosstab function
-- #################################

CREATE TABLE scores (
	score_id SERIAL PRIMARY KEY,
	name varchar(100),
	subject VARCHAR(100),
	score numeric (4,2),
	score_date DATE
)

-- 2. Lets insert some sample data

INSERT INTO scores (name,subject,score,score_date) 
VALUES
('Adam', 'Math',10, '2020-01-01'),
('Adam', 'English',8, '2020-02-01'),
('Adam', 'History',7, '2020-03-01'),
('Adam', 'Music',9, '2020-04-01'),

('Linda', 'Math',10, '2020-01-01'),
('Linda', 'English',11, '2020-02-01'),
('Linda', 'History',12, '2020-03-01'),
('Linda', 'Music',13, '2020-04-01');

-- So select our ICV here 

-- X: name
-- Y: subject
-- Z: score

--------------------------

SELECT DISTINCT(subject) FROM scores;


-- 4. Lets create our first pivot table
/*

	Name 		English		Math 	Music
	----		------		----	-----
	Adam		8 			10 		9
	Linda

*/

-- We will be using the crosstab function here
/*

	1. The syntax
	
	SELECT * from crostab
	(
	
	)as ct
	(
	
	
	)

*/

SELECT * FROM crosstab
(
	'
		SELECT
			name,
			subject,
			score
		FROM scores
		ORDER BY 1,3
	'
) as
(
	name VARCHAR,
	English NUMERIC,
	History NUMERIC,
	Math NUMERIC,
	Music  NUMERIC
)



-- Rain falls data
--

CREATE TABLE rainfalls (
    location text,
    year integer,
    month integer,
    raindays integer
);


-- rainfall data install

-- View

SELECT * FROM rainfalls;


-- 3. Lets build a pivot to display sum of all raindays per each lcoation for each year

X 	years
Y	lcoaiton
V	sum(raindays)


--

SELECT * FROM crosstab
(
	'
	
		SELECT
			location,
			year,
			COALESCE(SUM(raindays) ,0)::int
		FROM rainfalls
		GROUP BY 
			location,
			year
		ORDER BY 
			location,
			year
	'

) AS ct
(
	"Location" TEXT,
	"2012" integer,
	"2013" integer,
	"2014" integer,
	"2015" integer,
	"2016" integer,
	"2017" integer
);


-- Pivoting Rows and Columns
-- ####################################################

-- By location view

SELECT DISTINCT(month) FROM rainfalls;

SELECT * FROM crosstab (
	'
	SELECT location, month , SUM(raindays)::int
	FROM rainfalls
	GROUP BY location,month
	ORDER BY 1,2

	'
) AS CTE
(
	location TEXT,
	"Ocak" INT,
	"Şubat" INT,
	"Mart" INT,
	"Nisan" INT,
	"Mayıs" INT,
	"Haziran" INT,
	"Temmuz" INT,
	"Ağustos" INT,
	"Eylül" INT,
	"Ekim" INT,
	"Kasım" INT,
	"Aralık" INT
);


-- By Month View

SELECT * FROM crosstab
(
	'
		SELECT month, location , SUM(raindays)::int
		FROM rainfalls
		GROUP BY month,location
		ORDER BY 1,2	
	'

) AS CT
(	month       INT,
	"Dubai"		INT,
	"France"	INT,
	"Germany"	INT,
	"London"    INT,
	"Malaysia"   INT,
	"Qatar"		INT,
	"Singapore" INT,
	"Sydney"	INT,
	"Tokyo"		INT
);

-------------------------------------------

-- Matrix report via a query
-- ##########################################

/*

	SELECT
		y,
		aggregate_fun (CASE WHEN x='value 1' THEN v ELSE '' END) "value 1",
		aggregate_fun (CASE WHEN x='value 2' THEN v ELSE '' END) "value 2",
		.. repeated for each x transposed into a column
		
	FROM table or subquery
	GROUP BY y
	[ORDER BY 1]
	
	
*/


SELECT DISTINCT (subject) FROM scores;

-- Bu şekilde büyük bi sorguda performans sıkıntısı yaratabilir.
-- Bu yüzden crosstab kullanmak daha iyi olabilir.
SELECT
	name,
	SUM(CASE WHEN subject='English' THEN score END) English,
	SUM(CASE WHEN subject='History' THEN score END) History,
	SUM(CASE WHEN subject='Math' THEN score END) Math,
	SUM(CASE WHEN subject='Music' THEN score END) Music
FROM scores
GROUP BY 
	name
ORDER BY 
	3;
	
	
-- Aggregate over filter 
-- ############################################

-- We can used aggregate and filter function to get our pivot table done too...


SELECT
	location,
	SUM(raindays) FILTER (WHERE year='2012') AS "2012",
	SUM(raindays) FILTER (WHERE year='2013') AS "2013",
	SUM(raindays) FILTER (WHERE year='2014') AS "2014",
	SUM(raindays) FILTER (WHERE year='2015') AS "2015",
	SUM(raindays) FILTER (WHERE year='2016') AS "2016",
	SUM(raindays) FILTER (WHERE year='2017') AS "2017"
FROM rainfalls
GROUP BY
	location
ORDER BY
	6 DESC;
	

-- How about average rainfalls days 

SELECT
	location,
	ROUND(AVG(raindays) FILTER (WHERE year='2012'),2) AS "2012",
	ROUND(AVG(raindays) FILTER (WHERE year='2013'),2) AS "2013",
	ROUND(AVG(raindays) FILTER (WHERE year='2014'),2) AS "2014",
	ROUND(AVG(raindays) FILTER (WHERE year='2015'),2) AS "2015",
	ROUND(AVG(raindays) FILTER (WHERE year='2016'),2) AS "2016",
	ROUND(AVG(raindays) FILTER (WHERE year='2017'),2) AS "2017"
FROM rainfalls
GROUP BY
	location
ORDER BY
	6 DESC;
	
	
	
-- Static to dynamic pivots 
-- ##########################################

/*

	Static Pivots
	-----------------------
	
	1. We have in both the crosstab and the traditional query form have the drawbcak that the;
	
		-- Output columns must be expilcity enumarated
		-- They must be added manually to the list
		
	2. These queries also lack flexibility;
	
		- To change the order of the columns , or transpose a diffrent column of the source data 


	3. Also , some pivots  may have hundreds of colums , so lsiting them manually in SQL is too tedious.
	
	Dynamic Pivots
	==========================
	
	4. A polymorphic query that would automatically have row values transposed into columns without the need to edit
		the SQL statement
	
	-- get columns names , main query
	-- crosstab query
	-- execute crosstab query


*/


-- Creating a  dynamic pivot query
-- ############################################

/*

	1. The difficulty of a creating a dynamic pivot is;
		
		IN an SQL  query , the output columns must be determined before execution , but to know which columns are formed
		from transposing rows , wed to need to execute the query first.
	
	2. One solution may be to have pivotated part encapsulated inside a single column with a composite pr array tyoe style .
	
		we can use JSON to solve this problem.
		

*/


-- We will use json_object_agg i.e aggregates name/value pairs as a JSON object

SELECT 
	location ,
	json_object_agg (year,raindays ORDER BY year) as "mydata"
FROM rainfalls
GROUP BY location
ORDER BY location

-- 

SELECT
	location,
	json_object_agg(year, total_raindays ORDER BY year) as "mydata" 
FROM 
(

	SELECT 
		location,
		year,
		SUM(raindays) AS total_raindays
	FROM rainfalls
	GROUP BY 
		location,
		year
	ORDER BY location

)S
GROUP BY location
ORDER BY location;


-- Dynamic pivot table columns
-- #############################################

/*

The Idea:
	
	1. To prepare a function which will return the full crostab query 
	
	2. We will prepare the following syntax
	
		- We will create syntax for
		
			- master query			    SELECT * FROM  ... GROUP BY
			- header columns query      SELECT DISTINCT(column_name) FROM ....
			
			
	3. For dynamic columns we will have them lower case, add e prefix as '_', so that to make them unique too
	
		e.g _english , _history
	
	4. The final output syntax
	
		SELECT * FROM crosstab (
		
		'master_query',
		'header_columns query'
		) as newtable
		(
			row_column_name VARCHAR,
			_col1,
			_col2,
			....
		)


*/

-- ########################################################################################

-- Lets create our function 'pivotcode'

/*
	
	tablename		Name of source table you want to pivot
	myrow			Name of the column in source table you want to be the rows
	mycol			Name of the column in source table you want to be the columns
	mycell			An aggregate expression determining how the cell values will be created
	celldatatype	desired data type for the cels
	
*/




CREATE OR REPLACE FUNCTION pivotcode (
	tablename VARCHAR,
	myrow VARCHAR,
	mycol VARCHAR,
	mycell VARCHAR,
	celldatatype VARCHAR
)
RETURNS VARCHAR
LANGUAGE PLPGSQL
AS
$$

	DECLARE
		
		dynsql1 VARCHAR;
		dynsql2 VARCHAR
		columnlist VARCHAR;
	
	BEGIN
	
		-- 1 retrieve list of all DISTINCT column name
			
			-- SELECT DISTINCT (column_name) FROM table_name
			
			dynsql1= 'SELECT STRING_AGG (DISTINCT ''_''||'||mycol||'||'' '||celldatatype||''', '', '' ORDER BY ''_'' ) '
		
		-- 2. setup the crosstab query
		
		-- 3. returns the query
		
		RETURN dynsql2;
	
	
	END;

$$




-- Handling missing values
-- #####################################################

SELECT * FROM crosstab ( QUERY ) AS (columns)

-- You can also used crosstab in the following sytax too. It produces a "pivot table" with the value columns specified by 
-- a SECOND QUERY.

	crosstab( text source_sql, text category_Sql)
	
-- Get all directors first name with their total revenues per each year

-- Using crosstab (text source_sql)


SELECT * FROM crosstab (
	$$
		SELECT d.first_name ,EXTRACT('year' FROM mv.release_date) as year,
				SUM(r.revenues_domestic + r.revenues_international)::int
		FROM directors d
		INNER JOIN movies mv ON mv.director_id=d.director_id
		INNER JOIN movies_revenues r ON r.movie_id=mv.movie_id
		WHERE mv.release_date BETWEEN '2010-01-01' AND '2020-10-31'
		GROUP BY
			d.first_name,mv.release_date
		ORDER BY d.first_name,year
	
	$$
) AS CT
(

	director VARCHAR,
	"2010" int,
	"2011" int,
	"2012" int,
	"2013" int,
	"2014" int,
	"2015" int,
	"2016" int,
	"2017" int
);


-- with two queries i.e source_sql and categories_sql
-- crosstab( text source_sql,text category_sql)

SELECT * FROM crosstab (
	$$
		-- source_sql
	
		SELECT d.first_name ,EXTRACT('year' FROM mv.release_date) as year,
				SUM(r.revenues_domestic + r.revenues_international)::int
		FROM directors d
		INNER JOIN movies mv ON mv.director_id=d.director_id
		INNER JOIN movies_revenues r ON r.movie_id=mv.movie_id
		WHERE mv.release_date BETWEEN '2010-01-01' AND '2020-10-31'
		GROUP BY
			d.first_name,mv.release_date
		ORDER BY d.first_name,year
	
	$$,
	
	$$
	
	--columns_sql
	--SELECT DISTINCT (EXTRACT('year' FROM mv.release_date)) AS year 
	
	VALUES (2010),(2011),(2012),(2013),(2014),(2015),(2016),(2017)
	
	$$
	
) AS CT
(

	director VARCHAR,
	"2010" int,
	"2011" int,
	"2012" int,
	"2013" int,
	"2014" int,
	"2015" int,
	"2016" int,
	"2017" int
);