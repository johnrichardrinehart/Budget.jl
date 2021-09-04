{
  description = "estimate future investment profits";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = import nixpkgs {
          inherit system;
          config = {
            allowBroken = true;
          };
        };
        in
        {
          defaultPackage = (import ./default.nix) {
            inherit pkgs;
          };
          defaultApp = pkgs.hello;
        }
    );
}
