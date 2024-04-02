-- What is a Trigger
-- ##############################

/*

	1. A 'trigger' is defined as event that sets a course  of action in a motion.
	
	2. A POSTGRESQL trigger is a function invoked automatically whenever 'an event' assotiated wit ha table occurs
	
	3. An event could be any of the following.
		
		- INSERT
		- UPDATE 
		- DELETE
		- TRUNCATE
		
	4. A trigger can be associated with a specified
	
		- Table,
		- View or
		- Foreign Table
		
	5. A trigger is a special 'user-defined function'.
	
	6. The difference between a trigger and a user-defined function is that a trigger is automatically invoked
		when a tiggering event occurs.
		
	7. we can create trigger
	
		- BEFORE
			
			- If the trigger is invoked before an event, it can skip the operation for the current row or even change
			 the row being updated or inserted.
		
		- AFTER 
		
			- All changes are available to the trigger.
		
		- INSTEAD
			of the events /operation.
			
	8. If there are more than one triggers on the a table , then they are fired in alphabaticall orders.
		First , all of those BEFORE triggers happen in alphabatical order . Then , POSTGRESQL performs the row
		operation that the trigger has been fired for , and continues executing after the triggers in alphabatical order.
		
	
		In other words , the execution order of triggers is absolutely deterministic , and the number of triggers is 
		basically unlimited.
		
	9. Triggers can modify data before or after the actual modşfşcatşons has happened. In general , this is a good 
	 	way to verify data and to error out if some custom restrictions are violated. T
		
	
	10. There are two main characteristic that make triggers different that stored procedures:
		
		- Triggers cannot be manualy executed by the user.
		- There is no chance for triggers to receive parameters.
		

*/



-- Types of triggers
-- ###################################

/*

	1. Row Level Trigger
		
		If the trigger is marked FOR EACH ROW then the trigger function will be called for each row that is getting modified by the event.
		
		e.g ., If we UPDATE 20 rows in the table , the UDPATE trigger function will be called 20 times, once for
		each updated row.
		
	2. Statement Level Trigger
		
		The FOR EACH STATEMENT option will call the trigger function only ONCE for each statement , 
		regardless of the number of the rows getting modified.
		
		- As ypu can see , the diffrences between the two kinds are HOW MANY TIMES trigger is invoked and AT WHAT TIME.
		
		- IN POSTGRESQL, triggers have become more powerful over the years  , and they now provide a rich set of features.
		

*/


-- Trigger table 
-- #########################################

/*

Following table will help you to understand when ato used which triggers in what event ( INSERT, UPDATE, DELETE, TRUNCATE )

When                    Event                          Row-Level                                  Statement-Level
--------------        -------------------------        ------------------------------             --------------------------------
					  INSERT /UPDATE /DELETE			tables 										Tables and views

BEFORE				  TRUNCATE							-											Tables

					  INSERT/UPDATE/DELETE 				Tables										Tables and views
					  
AFTER				  TRUNCATE							-											Tables
					  
					  INSERT/UPDATE/DELETE				Views 										-

INSTEAD OF 			  TRUNCATE							-											-


*/



-- Pros and Cons of using triggers
-- ##################################################

/*


	Props
	--------------
	
	1. Triggers are not difficult to code . The fact that they are coded like stored procedures which makes getting 
		started with triggers easy.
		
	2. Triggers allow you to create 'basic auditing'. By using the deleted table inside a trigger you can build a decent
		audit solution that  inserts the contents of the deleted table data into an audit table which holds the data that
		is either being removed by a DELETE statement or being changed by an UDPATE statement.
		
	3. You can call stored procedures and functions from inside a trigger.
	
	4. Triggers are useful when you need to validate inserted or updated data in batches instead of row by row.
		Think about it , in a triggers code you have the inserted and deleted tables that hold a copy of the data
		that potential will be stored in the table ( the inserted table) ; and the data that will be removed from
		the table  ( the deleted table).
		
	5. You can use triggers to implement referential integrity across databases . Unfortunately SQL Server does'nt 
		allow the creation of constraints between objects on different databases , but by using triggers you can
		simulate the behavior of constarints.
		
	6. Triggers are useful if you need to be sure that certain events always happen when data is inserted, updated
		or deleted. This is the case when you have to deal with complesx default values  of columnsi or modify the data
		of other tables.
	
	7. Triggers allow recursion. Triggers are recursive when a trigger on a table performs an action on the base table 
		that causes another instances of the trigger of fire . This is useful when you have to solve  a self- referencing
		relation ( i.e a constaint to itself)
		
	
	Cons (DezAvantajları)
	---
	1. Triggers are difficult to locatee unless you have proper documenttaion because the are invisible to the client.
		For instance, sometimes you execute a DML statement without errors or warnings , say an insert , and you donut see 
		it reflected in the table's data. In such case you have to check the table for triggers that may be disallowing
		you to run the insert you wanted.
		
	2. Triggers add overhead to DML statement s. EverY Time yo run a DML statement that has a trigger associated to it
		you are actualy executing the DML statement and the trigger ; but by definition  the DML statement wont end until
		the trigger execution completes. this can  can create a proplem in production .
		
	3. The problem of using tiggers for audit proposes is that when triggers are enabled , they execute always regardless
	 of the circumstances that caused the trigger to fire . For example , if you only need to audit the data inserted by 
	 a specific stored procedfure and you use a trigger , you may have to delete the rows of the audit the data that were
	 created when someone changed data using an ad-hoc query or add more logic into the triggers code which of course impacts
	 performance. In such case you may  have to use the OUTPUT clause.
	 
	 4. If there are many nested triggers it could get very hard to debug and troubleshoot , which consumes development time 
	 	and resources
		
	 5. Recursive triggers are even harder to debug than the  nested triggers.
	 
	 
*/


--- Triggers Key points
-- ##################################################

/*

	1. No trigger on SELECT statement , bacause SELECT DOES NOT MODIFY ANY ROW
	
		IN such cases lets use views.
	
	2. Multiple triggers can be used in alphabetical orders
	
	3. UDF (User defined functions) are allowed in triggers
	
	4. A SINGLE trigger can support MULTIPLE ACTIONS  ie. SINGLE -> MANY


*/





-- Trigger creation process
-- ##############################################

/*


	TO create a new trigger in POSTGRESQL, you folow these steps:
	
		1. First , create a trigger function using CREATE FUNCTION statement 
		
		2. Second , bind the trigger function to a table by using CREATE TRIGGER statement.

*/


-- CREATE FUNCTION syntax

CREATE FUNCTION trigger_function()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
AS
$$

	BEGIN
	
		--trigger logic
	
	END;

$$

-- CREATE TRIGGER function
CREATE TRIGGER trigger_name
	{ BEFORE | UPDATE} {event}
ON table_name
	[ FOR [EACH] { ROW | STATEMENT} ]
	
		EXECUTE PROCEDURE trigger_function

--
/*
	- First, specify the name of the trigger after the TRIGGER keywords
	
	- Second , specify the timing that cause the trigger to fire . It can be BEFORE or AFTER an event occurs
	
	- Third specify the event that invokes the triggers. the event can be INSERT , DELETE ,UPDATE or TRUNCATE 
	
	- Fourth, specify the name of the table associated with the trigger after the ON keyword.
	
	-Fifth , sepecify the type of triggers which can be :
	
		Row-Level trigger :             that is specified by the FOR EACH ROW clause
		
		Statement-level trigger :        that is specified by the FOR EACH STATEMENT clause

*/



-- Data auditing with triggers
--#################################################

-- Lets say we have a 'players' table. Suppose we want to log all data when the name of a player gets change or updated.

-- 1. Lets create the 'players' table


CREATE TABLE players(
	player_id SERIAL PRIMARY KEY,
	name VARCHAR(100)
);


-- Lets create 'players_audit' table to store all changes

CREATE TABLE players_audits(
	player_audit_id SERIAL PRIMARY KEY ,
	player_id INT NOT NULL,
	name VARCHAR(100) NOT NULL,
	edit_date TIMESTAMP NOT NULL
);


-- 3. As we seen earlier , we first create a function and then bind that function to our trigger
-- Lets create a function

CREATE OR REPLACE FUNCTION fn_players_name_changes_log()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
	BEGIN

		--COMPARE THE new value vs OLD value
		-- NEW , OLD 
		
		IF NEW.name<>OLD.name THEN
			INSERT INTO players_audits(player_id,name,edit_date)
			VALUES
			(OLD.player_id,OLD.name,NOW() );
		END IF;
		
		RETURN NEW;
	END;
$$




-- The OLD represents the row before update while the NEW represent the new row that will be updated.

-- 4. Now bind our newly created function to our table 'players' via CREATE TRIGGER statement

CREATE TRIGGER trg_players_name_changes
	BEFORE UPDATE --OR DELETE OR INSERT -- Güncellemeden önce 
	ON players  -- oyuncu tablosuna bağla
	FOR EACH ROW -- her satır için 
	EXECUTE PROCEDURE fn_players_name_changes_log() -- çalışacak function logic bunun içinde 
	

-- 5. Lets inserting some data

INSERT INTO players( name )
VALUES
('Adam'),
('Linda'),
('Özay');

SELECT * from players;
SELECT * from players_audits;

-- 6. Lets UPDATE some data

UPDATE players 
SET name ='Linda3'
WHERE player_id=2

SELECT * from players_audits;



-- Modify data at INSERT event
-- #####################################

-- Triggers can modify data BEFORE OR AFTER the actual modifications has hapened. This is a good way to verify
-- data and to error out data mistakes and more

-- Lets demonstrate the use of trigger to a. Check the inserted data and b. then change it if needed as per logic


-- 1. Lets create a table 

CREATE TABLE t_temprature_log(
	temprature_log_id SERIAL PRIMARY KEY,
	add_date TIMESTAMP,
	temprature numeric
)


-- 2. Lets create a function to check the inserted data

CREATE OR REPLACE FUNCTION fn_temprature_value_check_at_inserted()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
	AS
$$
	BEGIN
		
		-- temprature < -30 : temprature = 0
		IF NEW.temprature< -30 THEN
			NEW.temprature = 0;
		END IF;
		
		RETURN NEW;
	
	END;
$$


-- 3. Lets bind our function to our table 

CREATE TRIGGER trg_temprature_value_check_at_inserted
BEFORE INSERT
ON t_temprature_log
FOR EACH ROW
EXECUTE PROCEDURE fn_temprature_value_check_at_inserted();

--

INSERT INTO t_temprature_log(add_date,temprature)
VALUES
('2020-10-01',-300);


SELECT * FROM t_temprature_log;




-- View Triggers variables
--################################

-- Triggers knows a lot about themselfs . They can access copuple of varibales that allow you write advanced
-- code and more

-- 1. Lets add a new function which display some key trigger variables data


CREATE OR REPLACE FUNCTION fn_trigger_variables_display()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS
$$
	BEGIN
		RAISE NOTICE 'TG_NAME: % ', TG_NAME; --Trigger adı
		RAISE NOTICE 'TG_RELNAME: % ', TG_RELNAME; -- 
		RAISE NOTICE 'TG_TABLE_SCHEMA: % ', TG_TABLE_SCHEMA; -- şeması
		RAISE NOTICE 'TG_TABLE_NAME: % ', TG_TABLE_NAME; -- tablo adı
		RAISE NOTICE 'TG_WHEN: % ', TG_WHEN; -- AFTER ,BEFORE
		RAISE NOTICE 'TG_LEVEL: % ', TG_LEVEL; -- SIRA ROW  veya STATEMENT
		RAISE NOTICE 'TG_OP: % ', TG_OP; -- trigger işlem
		RAISE NOTICE 'TG_NARGS: % ', TG_NARGS;
		RAISE NOTICE 'TG_ARGV: % ', TG_ARGV;
	
		RETURN NEW;
	END;
$$


--  2. Lets bind the function to table after the INSERT

CREATE TRIGGER trg_trigger_variables_display
AFTER INSERT
ON t_temprature_log
FOR EACH ROW
EXECUTE PROCEDURE fn_trigger_variables_display();


-- Disallowing DELETE
-- ########################################

/*

	What if our business requirements are such that the data can only be added and modified in some tables, but not deleted ?
	
	One way to handle this will be to just revoke the DELETE rights on these tables from all the users
	( remember to also revoke DELETE from public), but this can also be archived using triggers !!!

*/

-- 1. Llets create a test table 

CREATE TABLE test_delete (
	id INT 
);

-- 2. Lets insert some data

INSERT INTO test_delete(id) values(1),(2),(3),(4);

SELECT * FROM test_delete;


-- 1. Lets create a generic 'cancel' function for our use case here 


CREATE OR REPLACE FUNCTION fn_generic_cancel_op()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
	BEGIN
		IF TG_WHEN = 'AFTER' THEN
			RAISE EXCEPTION ' YOU ARE NOT ALLOWED TO % ROWS IN %.%',
			TG_OP,TG_TABLE_SCHEMA,TG_TABLE_NAME;
		END IF;
		
		RAISE NOTICE ' % ON ROWS IN %.% WONT HAPPEN',
		TG_OP,TG_TABLE_SCHEMA,TG_TABLE_NAME;
		
		RETURN NULL; -- boş dönüyoruz ki kayıt silinmesin == İşlem iptali anlamına geliyor.
	END;
$$

-- 2. Lets bind the function at AFTER DELETE

CREATE TRIGGER trg_disallow_delete
AFTER DELETE -- silme işleminden sonra
ON test_delete
FOR EACH ROW
EXECUTE PROCEDURE fn_generic_cancel_op();

-- 3. Now lets delete a record

DELETE FROM test_delete WHERE id=1;

-- Did the data get deleted?

SELECT * FROM test_delete;



-- 5. Now lets create another trigger but this time BEFORE DELETE

CREATE TRIGGER trg_skip_delete
BEFORE DELETE 
ON test_delete
FOR EACH ROW
EXECUTE PROCEDURE fn_generic_cancel_op();

DELETE FROM test_delete where id=1;


--Did the data get deleted ?

SELECT * FROM test_delete;


-- This time , the BEFORE trigger canceled the delete and the AFTER trigger , although still there , was not reached.

-- The same trigger can also be used to enforce a no-update policy or even disallow inserts to a table that needs
-- to have immutable contents.


------------------

--- The audit trigger
-- ######################################################

/*

	1. One of the most common uses of triggers is to log data changes to table in a consistent and transparent manner .
	
	2. when creating an audit trigger , we first must decide what we want to log.
	
	3. A logical set of things that can be logged are;
		- who changed the data
		- when the data was changed,
		- and which operation changed the data.


*/


-- 1. Lets create a master table 'audit'

CREATE TABLE audit (
 id INT
)

-- 2. Lets create an audit_log table

CREATE TABLE audit_log(
	username TEXT,
	add_time TIMESTAMP,
	table_name TEXT,
	operation TEXT,
	row_before JSON,
	row_after JSON
)

-- 2. We will populate the above table with some internal variables
/*

	username 			SESSION_USER
	
	add_time 			Event time converted into UTC (Universal Time Coordinated) with day light saving etc.
						CURRENT_TIMESTAMP AT TIME ZORE 'UTC'
	
	table_name          TG_TABLE_SCHEMA ||'.'||TG_TABLE_NAME  public.audit
	
	
	operation 			TG_OP      INSERT ,UPDATE , DELETE
	
	row_before          Finally , the before and after images of rows are stored as rows converted to json,
	,row_after			which is available as its own data type 


*/

-- 3. Lets create the trigger function

-- Please note that NEW and OLD are not NULL for the DELETE and INSERT triggers correspondinally

CREATE OR REPLACE FUNCTION fn_audit_trigger()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
	DECLARE 
		old_row json=NULL;
		new_row json=NULL;
	BEGIN
		-- TG_OP
		
		-- UPDATE , DELETE
			-- old_row
		
		IF TG_OP IN ('UPDATE' ,'DELETE') THEN
			old_row =row_to_json(OLD);
		END IF;
		
		
		-- INSERT , UPDATE
			-- new row
		
		IF TG_OP IN ('INSERT' ,'UPDATE') THEN
			new_row =row_to_json(NEW);
		END IF;	
			
			
		-- INSERT audit_log
		
		INSERT INTO audit_log(
			username,
			add_time ,
			table_name ,
			operation ,
			row_before ,
			row_after
		)
		VALUES
		(
			session_user,
			CURRENT_TIMESTAMP AT TIME ZONE 'UTC',
			TG_TABLE_SCHEMA||'.'||TG_TABLE_NAME,
			TG_OP,
			old_row,
			new_row
		);
	
	RETURN NEW;
	END;
$$



-- 4. Lets create our trigger statement

CREATE TRIGGER trg_audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON audit
FOR EACH ROW
EXECUTE PROCEDURE fn_audit_trigger();


-- 5. Lets test with some data

-- INSERT operation

INSERT INTO audit(id) VALUES(1);
INSERT INTO audit(id) VALUES(2);
INSERT INTO audit(id) VALUES(3);

SELECT * FROM audit;

SELECT * FROM audit_log;

-- UPDATE OPERATION

UPDATE audit SET id=4 WHERE id=1;


-- DELETE OPERATION

DELETE FROM audit WHERE id=4;




-- Creating conditional triggers
-- ###################################

/*

	1. We can create a conditional trigger by using a generic WHEN clause
	
	2. With a WHEN clause, you can write some conditions except a subquery ( because subquery tested before the trigger function is called)
	
	3. The when expresion should result into Boolean  value. IF the value is FALSE or NULL ( Which is automatically converted TO FALSE ) ,
		The trigger function is not called.
	

*/

-- Lets say we want to enfore " No INSERT/UPDATE/DELETE on Friday afternoon!"

-- We will use;

	-- 1. WHEN condition
	
	-- 2. We will use FOR EACH STATEMENT
	
	-- 3. We will pass a 'parameter' to EXECUTE PROCEDURE function_name(parameter)



-- 1. Lets create our master table

CREATE TABLE mytask (
	task_id SERIAL PRIMARY KEY,
	task TEXT
);


-- 2. We will create a generic function which will show a message and RETURN NULL.

CREATE OR REPLACE FUNCTION fn_cancel_with_message()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
	BEGIN
		
		RAISE EXCEPTION '%',TG_ARGV[0];
		
		RETURN NULL;
	END;
$$



-- 3. Lets create our trigger statement. We will run it on STATEMENT level and not row level
-- Cuma ve öğleden sonra ise  kayıt atılaması engellenecek.

CREATE TRIGGER trg_no_update_on_friday_afternoon
BEFORE INSERT OR UPDATE OR DELETE OR TRUNCATE
ON mytask

FOR EACH STATEMENT -- SATIR DÜZEYİNDE
WHEN 
(
	EXTRACT ('DOW' FROM CURRENT_TIMESTAMP) =2 --Gün cuma ise
	AND CURRENT_TIME > '12:00' -- ve öğleden sonra ise tetiklenecek 
)
EXECUTE PROCEDURE fn_cancel_with_message('No update are allowed at Friday Afternoon , so chill!! ');

DROP TRIGGER trg_no_update_on_friday_afternoon ON mytask

-- Lets test the insert ( Remember , for us it might not be  Friday afternoon, so we can always change the login in function !)

SELECT
	EXTRACT ('DOW' FROM CURRENT_TIMESTAMP),
	CURRENT_TIME;
	
INSERT INTO mytask (task) values('test');

INSERT INTO mytask (task) values('test2');




-- Disallow change on primay key data
-- ##########################################

-- Use case : We want raise an error each time whenever someone tries to change a primay key column 

-- 1. Lets create our master table

CREATE TABLE pk_table(
	id SERIAL PRIMARY KEY,
	t TEXT
);

-- 2. We will insert some data first

INSERT INTO pk_table(t) VALUES('t1'),('t2');

SELECT * FROM pk_table;


-- 3. Lets create our trigger statement
-- id kolunun değiştirilemesi durumunda hata verilmesi ver işlemin gerçekleşmesini engellemek.
CREATE TRIGGER disallow_pk_change
AFTER UPDATE OF id
ON pk_table
FOR EACH ROW
EXECUTE PROCEDURE fn_generic_cancel_op();

-- 4. Now lets try to update a primary key data

UPDATE pk_table
SET id=100
WHERE id=1;



-- Use  triggers very cautiously
-- ########################################


/*

	Yes, The triggers are powerful tools, as they can be used for;
		
		- Auditing
		- logging
		- enforcing complex constraints
		- replications and more
		
	However , if they are not used cautiously , they will to very hard to debug problem !!.
	
	Same good practices to follow here
	
	1. DO NOT change data in
	
		- Primary Key
		- Foreign Key
		- or unique key columns
	
	2. DO NOT update records in the tables that you normally read during the transaction
	
	3. DO NOT read data from a table that is udpating the same transaction
	
	4. DO NOT aggregate/summurized over the table that you are updating
	

*/



-- Event Triggers
-- ################################

/*

	1. Event triggers are data-specific and not bind or attached to a table.
	
	2. Unlike regular triggers they capture system level DDL events.
	
	3. Event triggers can be BEFORE or AFTER triggers
	
	4. Trigger function can be written in any language except SQL
	
	5. Event triggers are disabled in the single user mode abd can only be created by a superuser
	

*/



-- Event triggers usage scenarios
-- ###########################################


/*

	1. Audit trial - Users ,schema changes etc.
	
	2. Preventing changes a table
	
	3. Providing limited DDL (Data definition language) capabilities to developpers
	
	4. Enable /Disable certaing DDL commands based on bussiness logic
	
	5. Performance analysis of DDL start (ddl_command_start) and end (ddl_command_stop) process
	
	6. Replicating DDL changes/updates to remote locations
	
	7. Cascading DDL

*/









