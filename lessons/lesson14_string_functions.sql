--############################string functions######
--#########
--##########################################

-- 1. Upper case characters
select upper('ozay tunçtan');

-- 2. Lower case a string characters

select lower ('Ozay TUNÇTAN');

-- 3. INITCAP

select INITCAP(
    CONCAT('ozay', ' ', 'TUNÇTAN')
) AS full_name

-- 4. LEFT

select LEFT('Ozay TUNÇTAN',1) as left

-- last n-2
select LEFT('Ozay TUNÇTAN',-2) as left

--

-- 5. RIGTH
select RIGHT ('ozay tunçtan',2)

select RIGHT ('ozay tunçtan',-3);


-- 6. SPLIT_PART

select SPLIT_PART('48.13.01.04','.',1);

select SPLIT_PART('ozay tunctan bilişim uzmanı',' ',1)

-- 7. LPAD - RPAD functions
-- ########################################
/*
* LPAD function pads a string on the left to a specified length with a sequence of characters
* RPAD function pads a string on the right to a specified length wit a sequence of characters

*/

LPAD (string,length, fill)

RPAD (string,length,fill)

-- The fill aruments is optional . If you the fill argument , is default value is space

select LPAD('Database',15,'*');

select RPAD('Database',15,'*');

SELECT RPAD('REF-001',8,'0');


--- LEGHT Function
--################

-- length return the numer of characters ot the number of bytes of a string

LENGTH(string);

SELECT LENGTH('Amazing Postgresql 123');

SELECT LENGTH('What is the length of this string');

select LENGTH(CAST(123456 AS text)) as characters_len;

SELECT CHAR_LENGTH('');
SELECT CHAR_LENGTH('  ');

--Get the total lenght of all directors full_name

--Posittion Function
--SELECT POSITION(term in str_text)
SELECT POSITION('Amazing' in 'Amazing PostgreSQL');

SELECT POSITION('mazing' in 'Amazing PostgreSQL');

SELECT POSITION('A' in 'OZAY TUNÇTAN PostgreSQL Eğitimi');

--STRPOST function
--#####################################
--strpos(string_text, term) ;

SELECT strpos('World Bank', 'bank');

SELECT strpos('World Bank', 'Bank');


INSERT INTO  users(user_name)
VALUES
('Tomas Anderson'),
('Paul Anderson'),
('Laon Besson'),
('Özay TUNÇTAN');

SELECT * from users
            WHERE STRPOS(user_name,'on')>0



--SUBSTRING function
--################################
--SUBSTRING(text,from,to);

SELECT SUBSTRING('Merhaba SQL Eğitimi', 0,3);

SELECT SUBSTRING('Merhaba SQL Eğitimi', 1,3);

SELECT SUBSTRING('Merhaba SQL Eğitimi' from 1 for 3);

SELECT user_name ,SUBSTRING(user_name,1,1) as first_letter
      from users

---REPEAT function
--################################
-- repeats a string a specified number of times.

SELECT REPEAT('A',4);

SELECT REPEAT('AB',10);


--- REPLACE function
--##############################################
-- REPLACE (string,from_str,to_str);

select REPLACE('SQL Eğitimine Hoşgeldiniz.!','SQL','POSTGRESQL');

select REPLACE('ABC XYZ','YZ','AA');

