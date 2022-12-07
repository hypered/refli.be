{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    buildInputs = [
      pkgs.bats
      pkgs.ghcid
      (pkgs.haskellPackages.ghcWithPackages (hpkgs: [
        hpkgs.Decimal
        hpkgs.yaml
      ]))
    ];
}
