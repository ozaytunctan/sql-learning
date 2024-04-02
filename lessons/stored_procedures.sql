-- Function vs Stored Procedures
--##########################
/*

	1. A user-defined functions ( CREATE FUNCTION ..) cannot execute 'transactions'
		i.e Inside a function , you cannot start a transaction
			
		CREATE FUNCTION
		BEGIN
			COMMIT;
		END;
	
	2. Stored procedure support transaction
	
	3. Stored procedure does not return value so you cannot use 'return'
	
		return value;
	
		However , you can use the return statement without the expression to stop the stored procedure immediately
		
			return;
		
		INOUT mode can be used return a value from stored procedures
		
	
	4. Con not be executed or called from within a SELECT.
		SELECT fn_.. from .. -- not called
		SELECT pr_(); -- not called
		
		CALL procedure_name();
	
	5. You can call a procedure as often as you like.
	
	6. They are compiled object
	
	7.Procedures may or may not use parameters (argument values).
	procedure(p1,p2) ..
	procedure();
	
	8. Executions
	
		- Explicit execution EXECUTE command , along with specific SP name and optional parameters.
		- Implicit execution using only SP name. CALL procedure_name();
		
	9. Declarations section can be empty. 
	
	10. Stored Procedures that do not have parameters (arguments) are called "static".
	
	11. Stored Procedures that use parameter values are called "dynamic".
	
**/

CREATE OR REPLACE PROCEDURE procedure_name(paremeter_list)
AS
$$
	DECLARE
		--variable declaration
	BEGIN
	
		--stored procedure body
	
	END;
$$ LANGUAGE PLPGSQL;


-- Create a transaction
-- ###################################

CREATE TABLE t_accounts(
	recid serial primary key,
	name varchar not null,
	balance decimal(15,2) not null
)


-- Insert some data

INSERT INTO t_accounts(name,balance)
VALUES
('Adam',100),
('Linda',100);

-- View the data

SELECT * FROM t_accounts;

-- Create our stored procedure

CREATE OR REPLACE PROCEDURE pr_money_transfer(
	sender int, 
	receiver int,
	amount decimal
) 
AS
$$

	DECLARE
	
	BEGIN
	  --subtract amount from the senders account
	  
	  UPDATE t_accounts
	  SET balance=balance - amount
	  WHERE recid=sender;
	  
	  -- adding amount receiver end
	  
	  UPDATE t_accounts
	  SET balance = balance + amount
	  WHERE recid=receiver;
	  
	  -- 
	  COMMIT;
	
	END;

$$ LANGUAGE PLPGSQL;



--  Lets execute our procedure
-- CALL procedure_name();

CALL pr_money_transfer(1,2, 100);


-- View updated data

SELECT * FROM t_accounts;


-- Understanding why to use stored procedures

/*

	1. To ensure data consistency by not requiring that a series of steps to be run or created over and over.
		Also if all the DBAs/developpers and even applciations use the same stored procedures , then the CAME code
		will always be used.
	2. To simply complex operations and encapsulating that into a single easy-to-use unit
	
	3. To simply overall 'Change Management' i.e if tables , columns or business logic needs to be changed then only 
	the stored procedures needs to be updated insteda of all changes at every level.
	
	4. To ensure security i.e Restricting access to underliying data via stored procedure wiil reduce the change to 
	data corrupt and more
	
	5. To fully utilize 'transaction' and its all benefits for data integrity and much more
	
	6. Performance , The code is compiled only when created , meaning no need to reqire at run-time,
		unless you change the program (stored procedure)
		
	7. Modularity . When you find yourself writing every similar queries multiple times in your code
		instead you cand choose to wite one stored procedure  - maybe with a parameter or two
		can be called over and over from your code  , with far less typing , potential types, and future maintance.
		
	8. Secuirty. Reduces potential for various kinds of hacking , including "SQL query injection".
	
	

*/



-- Returning a value 
-- #####################################

INOUT parameter mode

total_counts

CREATE OR REPLACE PROCEDURE pr_orders_count(INOUT total_count integer default 0)
AS
$$

	BEGIN	
		SELECT
		count (*) INTO total_count
		FROM orders;
	END;

$$ LANGUAGE PLPGSQL;

CALL pr_orders_count();


-- Drop a procedure.
-- ###########################

DROP PROCEDURE [if exists] procedure_name (argument_list)
[cascade|restrict]


DROP PROCEDURE pr_orders_count;

