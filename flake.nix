# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dataform.url = "path:/home/pretender/Public/dataform_nix";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    #       ↑ Swap it for your system if needed
    #       "aarch64-linux" / "x86_64-darwin" / "aarch64-darwin"
    pkgs = nixpkgs.legacyPackages.${system};
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
          postgresql
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
