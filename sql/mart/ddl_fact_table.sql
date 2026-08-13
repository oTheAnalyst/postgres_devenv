CREATE TABLE  mart.transaction_facts(
  transaction_id serial NOT NULL ,
  account_id INT NOT NULL REFERENCES mart.account (account_id) ,
  category_id INT NULL REFERENCES mart.category (category_id) ,
  date_id INT NOT NULL REFERENCES mart.date (date_id),
  transaction_amount DECIMAL NOT NULL
);
 CREATE INDEX fk_transactions_accounts_idx ON mart.transaction_facts (account_id );
 CREATE INDEX fk_transactions_categories1_idx ON mart.transaction_facts (category_id);
 CREATE INDEX fk_transactions_date1_idx ON mart.transaction_facts (date_id);
