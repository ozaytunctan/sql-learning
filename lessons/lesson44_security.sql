-- SECURITY
--#########################

-- Instance Level Security

-- 1. Controll all databases on an instance

-- 2. Highest level of security (so be super carefull!)

-- 3. Can be assigned with

-- 		SUPERUSER		- Super access, all access
--		CREATEDB		- Can create Databases
-- 		CREATEROLE		- Can make roles
--		LOGIN			- Can login into database
--		REPLICATION		- Can be used for replication

-- 4. Using NO means no access i.e NOSUPERUSER = No SUPERUSER access

-- Create role using CREATE ROLE
-- Lets create two roles i.e hr and programmers


CREATE ROLE hr NOSUPERUSER NOCREATEDB NOCREATEROLE NOLOGIN
CREATE ROLE programmers NOSUPERUSER NOCREATEDB NOCREATEROLE NOLOGIN

-- Can we login using a role name ? ( lets use pgsql)

-- Lets create some users

CREATE ROLE john NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'password123'

CREATE ROLE linda NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'password123';

--
-> psql -U john -d hrdb

-- But we did not give permission users/groups to login to our database 'hrdb'?
-- Revoke all access from database 'public' schema and try to login again

REVOKE ALL ON DATABASE hrdb FROM public; -- public şemasındaki tüm yetkileri kullanıcılardan aldık.


-- Add users to roles

GRANT hr to john;
GRANT programmers to linda;


-- Use PGAdmin to create roles



-- Database level Security

-- Control a database level
-- Can be assigned with

-- CREATE - Make a new schema
-- CONNECT -- Connect to a database 
-- TEMP /TEMPORARY  -- create a temporary a table

-- Adding permission for comnection via CONNECT
-- GRANT CONNECT ON DATABASE database_name TO role

 GRANT CONNECT ON DATABASE hrdb TO hr; -- hr rolü ne hrdb veritabanına bağlanma yetkisi verdik.
 GRANT CONNECT ON DATABASE hrdb TO programmers;
 
 
 --Can we create an schema ( using login:'john')
 -- Does 'john' have access to create a schema on 'employees' database ?
 
 -- CREATE SCHEMA test_schema
 
 -- Add Schema to hr
 
 GRANT CREATE ON DATABASE hrdb TO hr; -- hr rolüne veritabanında üzerinde oluşturma izni verildi.
 GRANT CREATE ON DATABASE hrdb TO programmers
 
 -- Lets try again creating an schema
 

-- Schema level security
-- #########################################

/*

	CREATE 			create tables, functions etc.
	USAGE 			view schema and its objects

*/

-- Lets login via terminal  with user 'adam'

-- try to create test table ? can adam create a table

-- However, we did not give permission to adam though
-- We must set level zero permissioning i.e We should revoke all access on schema to public first


CREATE ROLE adam NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'adam123';
GRANT CONNECT ON DATABASE hrdb TO adam;-- Veritabanı bağlanma yetkisi verildi.

REVOKE ALL ON SCHEMA public FROM public;-- public şemasındaki tüm yetkiler alındı.


-- Lets create two roles

CREATE ROLE sales NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'welcome';
CREATE ROLE tech NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN PASSWORD 'tech123';

-- Give tech create and usage persmission schema -> public
GRANT permission ON SCHEMA schema_name TO role_name
GRANT CREATE ON SCHEMA public TO tech;
GRANT USAGE ON SCHEMA public TO tech;


-- give sales USAGE permission on SCHEMA - > public
GRANT USAGE ON SCHEMA public TO sales;

-- Lets login via tech to see if they can create a table in schema -> public
GRANT CONNECT ON DATABASE database_name TO role_name;-- veritabanı erişim yetkisi verdik.

GRANT CONNECT ON DATABASE hrdb TO tech;
GRANT CONNECT ON DATABASE hrdb TO sales;

CREATE TABLE test_t3 ( id integer);




--Table Level security
-- ################################

/*


	SELECT 		read data/rows from table
	
	INSERT 		insert data into table
	
	UPDATE 		update data into table
	
	DELETE		delete data	into table
	
	TRUNCATE	remove all delete at once ( very fast operations , be carefull !!)
	
	TRIGGER 	create triggers on tables (high level access !!)
	
	REFERENCE	Ability to create foreign key constraints

*/

-- To applying on ALL TABLES -- Semadaki tüm tablolar için role izin tanımlamak için.

GRANT permission_name ON ALL TABLES IN SCHEMA schema_name to role_name;

-- To apply on an invidual table

GRANT permission_name ON TABLE table_name TO role_name;


-- Give sales 	SELECT ALL on tables in schema -> public

GRANT SELECT ON ALL TABLES IN SCHEMA public TO sales; 


-- Give tech SELECT ALL on tables in schema-public

GRANT SELECT ON ALL TABLES IN SCHEMA public to tech;

-- Give tech INSERT on empoyees table

GRANT INSERT ON TABLE employees TO tech;

-- Give tech UPDATE on empoyees table

GRANT UPDATE ON TABLE employees TO tech;

-- Give tech DELETE on empoyees table
GRANT DELETE ON TABLE employees TO tech;


-- Column level security 
-- ##################################

/*

	SELECT			read data from column
	
	INSERT			insert data into column
	
	UPDATE 			update data in column
	
	REFERENCE		Ability to refer the column is foreign key
	
	* NO DELETE *

*/

GRANT permission_name (table_col1,table_col2,....) ON table_name TO role_name;

-- restrict employees table -> phone_number , salary info etc to be see by 'sales' group

REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM sales; -- şemadaki tüm tablo yetkileri sales rolünden almak için.
--GRANT SELECT ON ALL TABLES IN SCHEMA public TO sales;

GRANT SELECT (employee_id,first_name,last_name,email) ON employees TO sales; -- 

GRANT SELECT (region_id,region_name) ON regions TO sales;

GRANT UPDATE (region_name) ON regions TO sales;


-- Row level security
-- ######################################





-- 1. Enable the extension

CREATE EXTENSION pgcrypto;

-- 2. Lets create a sample table

CREATE TABLE public.e_users(
	id SERIAL primary key,
	email varchar not null unique
);








