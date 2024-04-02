--#####################SEQUENCES#######
--#####
--#####################################
-- 1. Create a sequences
-- CREATE SEQUENCE IF NOT EXISTS sq_name
-- CREATE SEQUENCE sq_name

CREATE SEQUENCE IF NOT EXISTS test_sq ;

-- 2. Advance sequence and return new value
-- SELECT nextval(sq_name)

SELECT nextval('test_sq');

-- 3. Return most current value of the sequence
-- SELECT currval(sq_name)

select currval('test_sq')

-- 4. Set a sequence
-- SELECT setval(sq_name,value)

select setval('test_sq',8)

-- 5. Set a sequence and do not skip over
-- select setval(seq_name,value,false)

select setval('test_sq',200,false)

-- 6. Control the sequence START value
-- CREATE SEQUENCE IF NOT EXISTS sq_name START WITH value
-- CREATE SEQUENCE sq_name START WITH

CREATE SEQUENCE IF NOT EXISTS test_seq2 START WITH 100;

-- 7. Use multpile sequence parameters to crete a sequence
-- CREATE SEQUENCE name
-- START WITH value
-- INCREMENT WITH value
-- MINVALUE WITH value
-- MAXVALUE WITH value
CREATE SEQUENCE IF NOT EXISTS test_seq3
INCREMENT 50
MINVALUE 400
MAXVALUE 600
START WITH 500;

select nextval('test_seq3');


-- 8. Specify the data type of a sequence (SMALLINT|INT|BIGINT)
-- Default is BIGINT
-- CREATE SEQUENCE IF NOT EXISTS name AS data_type
-- CREATE SEQUENCE name AS data_type

CREATE SEQUENCE IF NOT EXISTS test_seq_smallint AS SMALLINT
CREATE SEQUENCE IF NOT EXISTS test_seq_int AS INT
CREATE SEQUENCE IF NOT EXISTS test_seq_bigint AS BIGINT

select nextval('test_seq_smallint');

-- 9. Create a Descending sequence and CYCLE |NO CYCLE
-- CREATE SEQUENCE seq_desc
-- INCREMENT -1
-- MINVALUE 1
-- MAXVALUE 3
-- START 3
-- CYCLE

CREATE SEQUENCE test_seq_asc;
select nextval('test_seq_asc');

CREATE SEQUENCE test_seq_desc
INCREMENT -1
MINVALUE 1
MAXVALUE 3
START 3
CYCLE;

select nextval('test_seq_desc');


CREATE SEQUENCE test_seq_desc2
INCREMENT -1
MINVALUE 1
MAXVALUE 3
START 3
NO CYCLE;

select nextval('test_seq_desc2');


-- 10. Alter a sequence
-- ALTER SEQUENCE name RESTART WITH value
-- ALTER SEQUENCE name RENAME TO new_value

select nextval('test_sq')

ALTER SEQUENCE test_sq RESTART WITH 100;

ALTER SEQUENCE test_sq RENAME TO test_seq

-- 11. Delete/DROP a sequence
-- DROP SEQUENCE name

CREATE SEQUENCE delete_seq

DROP SEQUENCE delete_seq

-- 13. Attaching sequence to a table

CREATE TABLE users (
id SERIAL PRIMARY KEY,
user_name VARCHAR (50)
)

INSERT INTO users (user_name) VALUES ('otunctan4');
select * from users;

ALTER SEQUENCE users_id_seq RESTART WITH 100;

-- To attach a sequence to an existing  table 
--Step 1 > Create a  sequuence and attached to a table 
-- CREATE SEQUENCE name
-- START WITH value OWNED BY tablename.columnname

CREATE TABLE users2 (
 id INT PRIMARY KEY,
 user_name VARCHAR(50)
)

CREATE SEQUENCE users2_id_seq
START WITH 100 OWNED BY users2.id;

--Step 2 > Alter Table column and set sequence
-- ALTER TABLE tablename
-- ALTER COLUMN columnname SET DEFAULT nextval(sequence_name)

ALTER TABLE users2
ALTER COLUMN id SET DEFAULT nextval('users2_id_seq');

INSERT INTO users2(user_name) values('otunctan2');

SELECT * FROM users2 ;


-- 14. List all sequences
select relname sequence_name from pg_class 
        where relkind='S' 
		
-- 15. Share sequence among tables

CREATE SEQUENCE common_fruits_seq START WITH 100;

CREATE TABLE apples (
  fruit_id INT DEFAULT nextval('common_fruits_seq') NOT NULL,
  fruit_name varchar (50)
)

CREATE TABLE mangoes (
  fruit_id INT DEFAULT nextval('common_fruits_seq') NOT NULL,
  fruit_name varchar (50)
)

INSERT INTO  apples (fruit_name) VALUES ('big apple');
select * from apples;

INSERT INTO  mangoes (fruit_name) VALUES ('big mango');
select * from mangoes;

--  How to create an Alpha-numeric sequence

CREATE TABLE contacts (
 id SERIAL PRIMARY KEY,
 name VARCHAR(150)
)

INSERT INTO contacts (name) VALUES ('Özay2');

SELECT * from contacts

DROP TABLE contacts ;

CREATE SEQUENCE table_seq ;

-- Create a table and use Default to add an alphanumeric sequence
--ID1,ID2,ID3

CREATE TABLE contacts (
 id TEXT NOT NULL DEFAULT ( 'REF-'|| nextval('table_seq')),
 name VARCHAR(150)
)

INSERT INTO contacts(name) VALUES ('Özay')

select * from contacts

