{ system ? builtins.currentSystem }: let
  nixpkgs = builtins.getFlake "nixpkgs/95aeaf83c247b8f5aa561684317ecd860476fcd6";
  pkgsFor = nixpkgs.legacyPackages.${system};
in pkgsFor."patchutils_0_4_2"
