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
           import_id BIGSERIAL PRIMARY KEY,
           import_dt TIMESTAMP NOT NULL,
           source_name VARCHAR,
           original_file_path VARCHAR,
           bucket_uri VARCHAR,
           md5_checksum VARCHAR);

       CREATE TABLE mart.account(
               account_id INT PRIMARY KEY,
               account_type VARCHAR,
               account_description VARCHAR);

       CREATE TABLE mart.transaction_type(
               transaction_type_id INT PRIMARY KEY,
               accont_type VARCHAR);

      CREATE TABLE mart.category(
              category_id INT PRIMARY KEY,
              category_description VARCHAR,
              category_essential VARCHAR);

        -- Create the calendar table
        CREATE TABLE mart.calendar (
            short_date DATE PRIMARY KEY,
            weekday_name VARCHAR(20) NOT NULL,
            day_month INTEGER NOT NULL,
            month_name VARCHAR(20) NOT NULL,
            quarter INTEGER NOT NULL,
            year INTEGER NOT NULL,
            weekday_number INTEGER NOT NULL,
            month_number INTEGER NOT NULL
        );

    '';
  };
}
