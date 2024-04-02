-- Understanding Row by row operation
-- ##############################################

/*
	-- 	Bir select sorgusu sonucunda row lar arasında ileri geri yapmayı sağlar.
	
	1. SQL retrieval operations works sets of rows as ' result sets ' or ' dataset'.
	
	2. The rows returns are all the rows that returns match a SQL statement. Either zero or more of theme.
	
	3. e.g. When you use a simple SELECT statement , there is no way to get the first row , the next row , or the previous 5 rows etc.
	
	4. Traditional procedural languages like pyhton , php , etc can operates on a row by row.
	
	5. Sometimes you need to step through rows FORWARD OR BACKWARD and ONE or MORE AT A TIME. This is what 'cursor' is used for .
	
	6. A cursor enable SQL to retrieve ( or update, or delete ) a single row at a time.
	
	7. A cursor is like a pinter that point or locate a specific table row.
	
	8. A cursor is a database query store  on the DBMs server - not a SELECT statement i but the RESULT SET retrieve by that
		statement.
	
	9. Once the cursor is active or stored , you can ;
	
		SELECT
		UDPATE or
		DELETE
		
		a row at which the cursor is pointing.
		
		Satır bazında ileri geri , silme , güncelleme yapılabilir.

*/





-- Using cursors with procedural languages
-- ###################################################

/*

	1. Cursor are very valuable if you want to retrieve SELECTED ROWS from a table.
	
	2. Once retrieved, you can check the contents of the result sets, and perform different operations on those contents.
	
	3. However , Please note SQL can't perform this sequence of operations by itself . SQL can retrieve the rows, but ideally
		the operations should be done by procedural languages based on contents.
		
	
	4. Procedural and non-procedural languages
	
		
		In PROCEDURAL languages, the program code is written as a sequence of instructions. User has to specify " what to do"
		and also "how to do" (step by step procedure). These instructions are executed in the sequential order.
		These instructions are written to solve specific problems.
		
		Examples of Procedural Languages:
		FORTRAN , COBOL , ALGOL , BASIC, C, Pascal etc.
		
		In the NON-PROCEDURAL languages , the user has to specify only "what to do " and not "how to do". It is also known as an aplication
		
		Examples of non-procedural languages :
		SQL, PROLOG, LISP.
		
	5. Cursors can retrieve and then feed the contents/result sets to a procedural language for further processing

*/


-- Steps to create a cursor
-- ###########################

/*

	Before using the cursors, following steps are required
	
	1. DECLARE ( KÜMEYİ DECLARE ET)
		
		A cursor must be DECLARE before it is to be used .
		This does not retrieve any data , it just defines the SELECT statement to be used and any other cursor options.
		
	2. OPEN (Açma)
		
		Once it is declare , it must be OPENED for use.
		This process retrieves the data using the define SELECT statement.
		

	3. FETCH (Getirme SATIR SATIR)
	
		Withe the cursor populated with data , individual rows cab be fetched (retrieved) as per needed.
		
	
	4. CLOSE (KAPAT)
		
		When you do not need the cursor, it must be closed.
		This operation  then deallocate memory etc back to the DBMS.
		
	5. Once a cursor is declared , it may be opened , fetched and close as often as needed.
	
	6. So the steps are;
	
		DECLARE -> OPEN -> FETCH -> CLOSE
		
*/


-- Creating a Cursor
-- #######################################

-- 1. Declare a cursor using refcursor data type
-- 	 PSOTGRESQL provides you with a special type called REFCURSOR to declare a cursor variable.

	DECLARE cursor_name refcursor;
	
	DECLARE cur_all_movies refcursor;
	
--  cursor_name uniquely identifies a cursor in the current module or compilation unit

	


-- 2. Create a cursor that  bounds to a query expression
	
	cursor_name [cursor-scrollability] CURSOR [ (name datatype, name datatype ...)]
	FOR
		query-expression
		
-- 		cursor-scrollability 		SCROLL or NO SCROLL (default)  NO SCROLL mean the cursor cannot scroll bacward.

--		query-expression 			You can use any legal SELECT statement as a query expression . The resultsets rows are
--									considered as scope of the cursor.

	
	 DECLARE
	 	cur_all_movies CURSOR
		FOR
			SELECT
				movie_name,
				movie_length 
			FROM movies

-- 3. Create a cursor with query parameters

-- custom_year : 2010

DECLARE 
	cur_all_movies_by_year CURSOR (custom_year integer)
	FOR
		SELECT
			movie_name,
			movie_length 
		FROM movies
		WHERE 
			EXTRACT ('YEAR' FROM release_date)=custom_year
		

-- Opening a cursor
-- #####################################

-- Unbound cursor
-- They are not bound any query expressions.

-- 1. Opening an unbound cursor

	OPEN unbound_cursor_variable [ [NO] SCROLL] FOR query;
	
	SELECT * FROM directors;
	
	OPEN cur_directors_us
	FOR
		SELECT
			first_name,
			last_name,
			date_of_birth
		FROM directors
		WHERE 
			nationality = 'American'
	
-- 2. Opening an unbounded cursor with dynamic query
	
	OPEN unbound_cursor_variable [ [NO] SCROLL] -- NO SCROLL imleç geri gitmeyecek hep ileri olacaktır.
	FOR EXECUTE
		query-expression [ using expression [, ...]]
		
	
	my_query : = ' SELECT DISTINCT (nationality) FROM directors ORDER BY $1';
	
	OPEN cur_directors_nationality
	FOR EXECUTE 
		my_query USING sort_field;
	
-- Bound cursor

-- 3. Opening a bound cursor

-- As they are bounds to query when we declared it, so when we open it, we just need to pass the arguments to the query
-- if necessary.

OPEN cursor_variable [ (name:=value, name:=value ...)]

OPEN cur_all_movies;

-- example opening

DECLARE 
	cur_all_movies_by_year CURSOR (custom_year integer)
	FOR
		SELECT
			movie_name,
			movie_length 
		FROM movies
		WHERE 
			EXTRACT ('YEAR' FROM release_date)=custom_year

OPEN cur_all_movies_by_year(custom_year:=2010)



-- Using cursors
-- ###############################

-- 1. Following operations can be done once a cursor is open;
		
		FETCH, MOVE, UPDATE, or DELETE statement.

-- 2. FETCH statement

	FETCH [direction { FROM |IN}] cursor_variable 
	INTO target_variable;
	
	FETCH cur_all_movies INTO row_movie;
	
-- 3. Direction

-- By Default a cursor gets NEXT row if you don't sepecify the direction explicitly.

/*
	
	NEXT
	LAST
	PRIOR
	FIRST
	ABSOLUTE count
	RELATIVE count
	FORWARD  -- İLERİ
	BACKWARD -- GERİ
	
*/

	FETCH LAST
	FROM row_movie
	INTO movie_title, movie_release_year;
	
-- IF you enable SCROLL at the declaration of the cursor, they can only you can use;

	FORWARD
	BACKWARD

-- 4. Moving the cursor

-- If you want to move the cursor only without retrieving any row , you will use the MOVE statement.

	MOVE [ direction { FROM | IN }] cursor_variable
	
	MOVE cur_all_movies;
	MOVE LAST  FROM cur_all_movies; -- son kayda gider
	MOVE relative -1 FROM cur_all_movies; -- Geriye doğru bir satır gider
	MOVE FORWARD 4 FROM cur_all_movies; -- Mevcut konumdan 4 satur ileri gider
	
	
	
--  Updating data using cursor
-- ####################################

/*

	Once a cursor is positioned, we can delete or update row identifying by the cursor using the following statement
	
		DELETE WHERE CURRENT OF or
		UPDATE WHERE CURRENT OF 
	
*/
	

UPDATE movies
SET YEAR(release_date)=custom_year
WHERE 
current of cur_all_movies;



-- Closing a cursor
-- ###########################

CLOSE cursor_variable

-- CLOSE statement release resources or frees up cursor variable to allow it to be opened again using OPEN statement.

CLOSE cur_all_movies;
OPEN cur_all_movies;



-- PL/pgSQL cursor
-- #####################

-- 1. Lets use the cursor to list all movies names

SELECT * from movies ORDER BY movie_name;

DO
$$
	DECLARE
		output_text varchar DEFAULT '' ;
		rec_movie record;
		
		cur_all_movies CURSOR
		FOR
			SELECT * FROM movies; -- cur_all_movies implecimizi oluşturduk.
		
	BEGIN
		OPEN cur_all_movies; -- cursor u açtık.
		LOOP
		
			FETCH cur_all_movies INTO rec_movie; -- satır satır alıyoruz
			EXIT WHEN NOT FOUND ; -- Kayıt yok ise döngüden çık .
		
			output_text :=output_text || ' | ' || rec_movie.movie_name;
		
		END LOOP;
	
		RAISE NOTICE  'ALL MOVIES NAMES %',output_text;
		
	END;
$$
LANGUAGE PLPGSQL;




-- Using cursor with a function
-- #################################

-- 2. Lets create a function where will use the cursor to loop through the all movies rows and concatenate the 
-- movie title and release date year of movie that has tühe title contains say the word 'Star'.

SELECT * FROM movies ORDER BY movie_name;
-- 1977 ,1980, 1983

CREATE OR REPLACE FUNCTION fn_get_movie_names_by_year(custom_year integer)
RETURNS TEXT
LANGUAGE PLPGSQL
AS
$$

	DECLARE 
		rec_movie record;
		movie_names TEXT DEFAULT '';
		
		-- cursor tanımlıyoruz
		cur_all_movies_by_year CURSOR (custom_year integer) 
		FOR
			SELECT
				movie_name,
				EXTRACT('YEAR' FROM release_date) as release_year
			FROM movies
			WHERE 
				EXTRACT('YEAR' FROM release_date) = custom_year;
	BEGIN
	
		-- cursor açıyoruz.
		OPEN cur_all_movies_by_year(custom_year);
		LOOP
			-- tek tek satırları alıyoruz.
			FETCH cur_all_movies_by_year INTO rec_movie;
			EXIT WHEN NOT FOUND; -- Eğer kayı yok ise çık
			
			IF rec_movie.movie_name LIKE '%Star%' THEN
				movie_names :=movie_names || ',' || rec_movie.movie_name || ':' ||rec_movie.release_year;
			END IF;
		
		END LOOP;
		
		CLOSE cur_all_movies_by_year; -- cursor ı kapat release memory
	
		RETURN movie_names;
	
	END;
$$



SELECT * FROM fn_get_movie_names_by_year(1977);

SELECT fn_get_movie_names_by_year(1977),fn_get_movie_names_by_year(1980);



