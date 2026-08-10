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
              md5_checksum VARCHAR
      );

    '';
  };
}
