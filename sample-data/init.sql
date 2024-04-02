--create financial_period table
CREATE TABLE financial_period {
 id INTEGER PRIMARY KEY ,
 year INTEGER ,
 municipality_id INTEGER REFERENCES municipality (id)
}

-- create entry_no table
CREATE TABLE entry_no {
  id INTEGER PRIMARY KEY ,
  journal_entry_no INTEGER NOT NULL DEFAULT 0 ,
  dummy_journal_entry_no INTEGER NOT NULL DEFAULT 0,
  financial_period_id INTEGER REFERENCES financial_period (id)
}