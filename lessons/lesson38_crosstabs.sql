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