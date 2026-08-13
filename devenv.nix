{pkgs, ...}: {
  packages = [pkgs.coreutils];
  services.postgres = {
    enable = true;
    extensions = extensions: [extensions.postgis];

    initialDatabases = [{name = "fmart";}];

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
               accont_type VARCHAR(70)
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

    '';
  };
}
