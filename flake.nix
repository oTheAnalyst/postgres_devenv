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
  in {
    devShells.${system}.default = let
      pythonpkgs = (pkgs.python3.withPackages (ps:
        with ps; [
          numpy
          requests
          keyring
        ])).override {ignoreCollisions = true;};
    in
      pkgs.mkShell {
        packages = with pkgs; [
          cowsay
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
