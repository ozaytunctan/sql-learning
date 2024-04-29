-- Character set support
-- ########################################

/*

	The whole idea over here ,s : 'How to make POSTGRESQL support global language data' !!
	
	www.klickanalytics.com
	
	1. POSTGRESQL allows you to store text in a variety of character sets (also called encoding)
		
		- single-btyte character sets		ISO 8859 series and
		- multiple-byte character sets      EUC (Extended Unix Code)
											UTF-8 , and Mule internal code
											
	2. The default character set is selected while initializing your POSTGRESQL database cluster using initdb.
		
		initdb -E UTF8
		
	3. You can have multiple database each with a different character set.
	
	4. For all supported character sets
	
		https://www.postgres.org/docs/12/multibyte.html
		
		CREATE DATABASE korean WITH ENCODING 'UTF8' LC_COLLATE='tr_TR.euckr' LC_CTYPE='ko_KR.euckr' TEMPLATE=template0;
		

*/

SHOW client_encoding;

-- 5. To create a UTF-8 based database

	CREATE DATABASE database_utf8
	WITH OWNER "otunctan"
	ENCODING 'UTF8'
	LC_COLLATE ='tr_TR.UTF8'
	LC_CTYPE ='tr_TR.UTF8'
	TEMPLATE template0;
	
	DROP DATABASE database_utf8
	

-- 6. To create a say KOREAN based language database with character set EUC_KR
	CREATE DATABASE database_korean 
	WITH ENCODING 'EUC_KR'
	LC_COLLATE='ko_KR.euckr' 
	LC_CTYPE='ko_KR.euckr'
	TEMPLATE=template0;
	
	
-- 7. POSTGRESQL will allow superusers to create database with SQL-ASCII  encoding even when LC_CTYPE is not C or 
-- 	  POSIX. As noted above, SQL_ASCII does not enforce that the data stored in the database has any particular 
--	  encoding. Not a good choice to have encoding set to SQL_ASCII ...

-- 8. POSTGRESQL can determine which character set is implied the LC_CTYPE setting , and it will enforce that 
--	  only the matching database encoding is used.


-- Server Encoding
-- ########################################

-- 1. Lets view the server encoding

SHOW SERVER_ENCODING;

-- Client Encoding
-- #######################################

SHOW CLIENT_ENCODING;


-- 3. Set cleint encoding
SET CLIENT_ENCODING TO UTF8;

-- 4. Lets create an example table to hole UTF8 based data

CREATE TABLE table_encoding (
	lang_id SERIAL PRIMARY KEY,
	lang_code TEXT,
	lang_text TEXT
);

INSERT INTO table_encoding(lang_code,lang_text)
VALUES
('tr', 'Merhaba'),
('en', 'Hello');

SELECT * FROM table_encoding