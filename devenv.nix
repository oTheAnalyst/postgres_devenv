{pkgs, ...}: {
  packages = [pkgs.coreutils];
  services.postgres = {
    enable = true;
    extensions = extensions: [extensions.postgis];

    initialDatabases = [{name = "fmart";}];

    listen_addresses = "localhost";

    initialScript = ''
        \c fmart
           CREATE SCHEMA staging;
           CREATE SCHEMA inter;
           CREATE SCHEMA mart;

      CREATE TABLE staging.stg_imports(
          import_id serial PRIMARY KEY,
          import_dt TIMESTAMP NOT NULL,
          source_name VARCHAR,
          original_file_path VARCHAR,
          bucket_uri VARCHAR,
          md5_checksum VARCHAR);

      CREATE TABLE mart.account(
              account_id serial PRIMARY KEY,
              account_type VARCHAR(45),
              account_description VARCHAR(200)
              );

      CREATE TABLE mart.transaction_type(
              transaction_type_id serial PRIMARY KEY,
              account_type VARCHAR(70)
              );

      CREATE TABLE mart.category(
              category_id serial PRIMARY KEY,
              category_description VARCHAR(100),
              category_essential SMALLINT
              );

       -- Create the calendar table
       CREATE TABLE mart.date (
           date_id serial PRIMARY KEY,
           short_date DATE,
           weekday_name VARCHAR(9) NOT NULL,
           day_month INTEGER NOT NULL,
           month_name VARCHAR(9) NOT NULL,
           quarter INTEGER NOT NULL,
           year INTEGER NOT NULL,
           weekday_number INTEGER NOT NULL,
           month_number INTEGER NOT NULL
       );

       CREATE TABLE  mart.transaction_facts(
         transaction_id INT NOT NULL REFERENCES mart.transaction_type (transaction_type_id),
         account_id INT NOT NULL REFERENCES mart.account (account_id) ,
         category_id INT NULL REFERENCES mart.category (category_id) ,
         date_id INT NOT NULL REFERENCES mart.date (date_id),
         transaction_amount DECIMAL NOT NULL
       );

       CREATE INDEX fk_transactions_accounts_idx ON mart.transaction_facts (account_id );
       CREATE INDEX fk_transactions_categories1_idx ON mart.transaction_facts (category_id);
       CREATE INDEX fk_transactions_date1_idx ON mart.transaction_facts (date_id);

    '';
  };
}
