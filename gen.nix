{ nixpkgs ? builtins.getFlake "nixpkgs"
, system  ? builtins.currentSystem
, lib     ? nixpkgs.lib
, pkgsFor ? nixpkgs.legacyPackages.${system}
}: let
  keep   = _: v: ( builtins.tryEval ( lib.isDerivation v ) ).success;
  drvs   = lib.filterAttrs keep pkgsFor;
  names  = map lib.toLower ( builtins.attrNames drvs );
  shards = builtins.groupBy ( builtins.substring 0 4 ) names;
  defPkg = name: {
    inherit name;
    value."dummy.nix" = ''
      { name = "${name}"; }
    '';
  };
  mkShardDir = ns: builtins.listToAttrs ( map defPkg ns );
in {
  unit = builtins.mapAttrs ( _: mkShardDir ) shards;
}
