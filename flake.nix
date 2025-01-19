{
  description = "quard-star develop environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        callPackage = pkgs.callPackage;
        quardstar-qemu = callPackage ./qemu-custom.nix { };
      in
      {
        packages.default = quardstar-qemu;
        # 如果需要，也可以暴露 devShell
        devShells.default = pkgs.mkShell {
          buildInputs = [ quardstar-qemu ];
        };
      }
    );
}
