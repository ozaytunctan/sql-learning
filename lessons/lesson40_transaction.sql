-- What is a transaction ?
-- ####################################

/*
	
	Key Points
	---------------------------
	
	
	
	
	-- ACID
	
	1. Atomicity
		Atomik olmalıdır. Ya hep ya hiç . Veritabanından tek işlemde yapılan select/update/delete işleminde herhangi bir hata alınması durumunda yapılan 
		işlemlerinin geri sarmalıdır.
	
	2. Consistency
		-- Tutarlılık
		
		Yapılan işlemin doğru işlendiğinden emin olunması. Bir hesaptan başka bir hesaba yapılan transfer işlemiminde gönderici hesabından para düşüldükten sonra
		alıcı hesaba sa para aktarılmış olması gerekmektedir. Göndereci hesabından para düşüldükten sonra alıcı hesaba para geçilmezse bu işlem tutarlı değildir.
		
	3. Isolation 
		-- Bir işlemin başka bir işlemi etkilememesidir. 
		
	4. Durability
		-- Dayanıklılık
		Yapılan işlemin gerçekten diske yazıldığı ve silme işlemi sonucunda verinin durmaması durumlarının kontrolü.
		Veri kayıt edilirken /update /delete işlemlerinin sonuclarının gerçekten yansıması. 
		Kayıt edilen veri herhangi bir işlem yapılmadan db de duruyor olması lazım.
	
		
*/

CREATE TABLE accounts(
	account_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL ,
	balance decimal(14,2) default 0.0
);

INSERT INTO accounts (name,balance)
VALUES
('Özay',100),
('Adam',100),
('Ada',100);

SELECT * FROM accounts;


-- Transaction analysis
--########################

-- 1. We connect to our POSTGRESQL server via 'connectio' e.q this query editor is say connection 3#

-- 2. Lets create another connection i.e Connection #2 by lanching another query editor window

-- 3. Lets create / open a transaction

 BEGIN; -- Yeni bir işlem başlatmak için
 
-- 4. Lets update the data in connection #1

BEGIN; -- işlem başlat

UPDATE accounts SET balance=balance-50
	WHERE name='Özay';
	
SELECT * FROM accounts;

--ROLLBACK; -- Hatalı işlem geri al.

COMMIT; -- yapılan işlemlerin kayıt edilmesi diske yazılması. Başka sessionların değişikliği görmesini sağlar.
	
	
	
-- Using SavePoints
-- What is a savepoint ?
-- ###############################

/*
	
	1. Simple ROLLBACK and COMMIT statement enable us to write or undo an ENTIRE TRANSACTION.
		However , we might want sometimes a support for a ROLLBACK of PARTIAL TRANSACTION.
		
	2. To Support the ROOLBACK of PARTIAL TRANSACTION , we must put PLACEHOLDERS at strategic location of the transaction block.
		Thus , if a rollback is required, you can read back on the said placholder.
		
	3. IN POSTGRESQL these placheholders are called 'Savepoints'
	
	4. Syntax
		
		SAVEPOINT savepoint_name;
		
	5. Each savepoints takes a unique name that identifies it so that, when you roll back, the DBMS knows where you are rolling
		back to.
		
	6. To rollback a transaction to a savepoint , we use the following syntax
		
		ROOLBACK TO savepoint_name;
		
	7. So full building block with transaction will ook like;
	
		BEGIN;
		
			<your valid_statment>
			
			SAVEPOINT savepoint1;
			
			<your error_statment>
		
			ROLLBACK TO savepoint1;
			
		COMMIT;
		
*/


-- Using savepoints with transaction
-- ####################################


-- Lets demonstrate a transaction block here ...


SELECT * FROM accounts;



	UPDATE accounts
	SET balance=200;

-- 2 güncellemeyi geri alınabilir.
BEGIN;
	
	UPDATE accounts
	SET balance=balance-50
	WHERE name ='Adam';
	
--	SELECT * FROM accounts;
	SAVEPOINT first_update;
	
	UPDATE accounts
	SET balance=balance-50
	WHERE name ='Adam';
	
	SELECT * FROM accounts;

	ROLLBACK TO first_update;
	
	SELECT * FROM accounts;
	
--ROLLBACK;
COMMIT;

----------------------------
	
	
	
	