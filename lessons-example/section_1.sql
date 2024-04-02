
--create city table
CREATE TABLE E_MUNICIPALITY.city (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  code VARCHAR(4)
)

ALTER TABLE E_MUNICIPALITY.city
ADD COLUMN active boolean DEFAULT false

-- Alter default value
ALTER TABLE E_MUNICIPALITY.city
ALTER COLUMN active set DEFAULT true

--insert  city
INSERT INTO E_MUNICIPALITY.CITY(name,code)
VALUES
('ADANA','01'),
('ANKARA','06'),
('BİTLİS','13');

-- show data list
SELECT * FROM E_MUNICIPALITY.city;

-- add city code constraints
ALTER TABLE E_MUNICIPALITY.city
ADD CONSTRAINT city_code_unique UNIQUE(code);


CREATE TABLE E_MUNICIPALITY.district(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  code VARCHAR(4),
  city_id INTEGER REFERENCES E_MUNICIPALITY.city(id),
  active BOOLEAN DEFAULT TRUE
)

ALTER TABLE E_MUNICIPALITY.district
ADD CONSTRAINT district_code_unique UNIQUE(code);


INSERT INTO E_MUNICIPALITY.district (name,code,city_id)
VALUES
('MERKEZ','1300',3),
('MUTKİ','1301',3),
('TATVAN','1302',3),
('GÜROYMAK','1303',3);

SELECT * FROM E_MUNICIPALITY.district;


--Belediye tablosu oluşturmak
CREATE TABLE E_MUNICIPALITY.MUNICIPALITY(
 id SERIAL PRIMARY KEY,
 name VARCHAR(150) NOT NULL ,
 description TEXT
)

ALTER TABLE E_MUNICIPALITY.MUNICIPALITY
ADD COLUMN city_id INTEGER

-- Alter column city id
ALTER TABLE E_MUNICIPALITY.MUNICIPALITY
ALTER COLUMN city_id SET NOT NULL;

--Add foreign key
ALTER TABLE E_MUNICIPALITY.MUNICIPALITY
ADD CONSTRAINT municipality_city_id_fkey
    FOREIGN KEY(city_id) REFERENCES E_MUNICIPALITY.city(id);



ALTER TABLE E_MUNICIPALITY.MUNICIPALITY
ADD CONSTRAINT municipality_district_id_fkey
    FOREIGN KEY(district_id) REFERENCES E_MUNICIPALITY.district(id);

ALTER TABLE E_MUNICIPALITY.MUNICIPALITY
DROP CONSTRAINT  municipality_district_id_fkey


ALTER TABLE E_MUNICIPALITY.MUNICIPALITY
ADD COLUMN detsis_no VARCHAR(50) UNIQUE NOT NULL ;

ALTER TABLE E_MUNICIPALITY.MUNICIPALITY
ADD COLUMN is_active boolean DEFAULT true,
ADD COLUMN agency_code VARCHAR(11) NOT NULL UNIQUE,
ADD COLUMN is_metropol boolean DEFAULT false

SELECT * FROM E_MUNICIPALITY.MUNICIPALITY;
--
INSERT INTO E_MUNICIPALITY.MUNICIPALITY(name,description,city_id,district_id,detsis_no,agency_code)
VALUES
('BİTLİS BELEDIYE BAŞKANLIĞI','Bitlis İl Belediyesi',3,1,'130000','48.13.02.01');

-- create financial period table
CREATE TABLE E_MUNICIPALITY.financial_period (
	id INTEGER PRIMARY KEY ,
	year INTEGER NOT NULL,
	municipality_id INTEGER REFERENCES E_MUNICIPALITY.MUNICIPALITY(id),
	is_active boolean DEFAULT 'y'
)

ALTER TABLE E_MUNICIPALITY.financial_period
ALTER COLUMN municipality_id SET NOT NULL;

ALTER TABLE E_MUNICIPALITY.financial_period
ADD CONSTRAINT financial_period_municipality_year_unique UNIQUE(year,municipality_id)

INSERT INTO e_municipality.financial_period(id,year,municipality_id)
VALUES(202313,2023,1),
VALUES(202413,2024,1)


SELECT * FROM e_municipality.financial_period;


select f.id,f.year,m."name",m.agency_code,m.detsis_no
              from e_municipality.financial_period f
              inner join e_municipality.municipality m on f.municipality_id = m.id
			  where  f.is_active
			  -- and f.id=202313

UPDATE e_municipality.financial_period set is_active=false	where id=202313;


ALTER TABLE e_municipality.financial_period
ADD CONSTRAINT year_positive_value_check CHECK (year>0)



