# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    #       ↑ Swap it for your system if needed
    #       "aarch64-linux" / "x86_64-darwin" / "aarch64-darwin"
    pkgs = nixpkgs.legacyPackages.${system};
    fmart =
      pkgs.writeShellScriptBin "fmart"
      ''pgcli -h localhost -d fmart'';
    sendb =
      pkgs.writeShellScriptBin "sendb"
      ''psql -h localhost -d fmart'';
    redev =
      pkgs.writeShellScriptBin "redev"
      ''rm -rf .devenv && devenv up'';
    ingest =
      pkgs.writeShellScriptBin "ingest"
      ''
        cd "$(git rev-parse --show-toplevel)" && 
         duckdb < sql/ingestion.sql &&
                        echo "ingestion completed!" | cowsay'';
    etl =
      pkgs.writeShellScriptBin "etl"
      # bash
      ''
        cd "$(git rev-parse --show-toplevel)" && 
         sendb < sql/intermediate/full_table.sql &&
         sendb < sql/intermediate/clean_category.sql &&
         sendb < sql/intermediate/clean_transaction.sql &&
         sendb < sql/mart/insert_account.sql &&
         sendb < sql/mart/insert_calender.sql &&
         sendb < sql/mart/insert_transaction.sql &&
         sendb < sql/mart/insert_category.sql &&
         sendb < sql/mart/insert_fact.sql &&
         sendb < sql/mart/view_expenditures.sql &&
         sendb < sql/mart/view_net_income.sql &&
         sendb < sql/mart/view_revenue.sql &&
         sendb < sql/mart/view_transaction_type.sql &&
                        echo "ETL completed!" | cowsay'';
  in {
    devShells.${system}.default = let
      pythonpkgs = (pkgs.python3.withPackages (ps:
        with ps; [
          numpy
          dash
          pandas
          streamlit
          requests
          keyring
        ])).override {ignoreCollisions = true;};
    in
      pkgs.mkShell {
        packages = with pkgs; [
          cowsay
          etl
          sendb
          fmart
          redev
          ingest
          postgresql
          pgcli
          pythonpkgs
          sqlfluff
          duckdb
          devenv
        ];
        shellHook = ''
          echo fish
        '';
      };
  };
}
