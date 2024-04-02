-- How to INNER JOIN tables with different columns data types
--##########################################

-- 1. Lets create a table with INT data type

CREATE TABLE t1 (test INT)

-- 2. Lets create a table with VARCHAR data type

CREATE TABLE t2 ( test VARCHAR(10))

-- 3. Can we join them ?

SELECT
*
FROM t1 
INNER JOIN t2 ON t1.test=t2.test


-- 4. If different columns data type , how can we join ?
-- we will use CAST

SELECT
*
FROM t1 
INNER JOIN t2 ON t1.test=CAST(t2.test as integer );

SELECT
*
FROM t1 
INNER JOIN t2 ON CAST(t1.test as VARCHAR)=t2.test;


-- 5. Test with some sample dtaa fpr join 

INSERT INTO t1 (test) values (1),(2);

INSERT INTO t2 (test) values (1),(2),('aa'),('bb');

select * from t2;