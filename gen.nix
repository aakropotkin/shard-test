{ nixpkgs ? builtins.getFlake "nixpkgs"
, system  ? builtins.currentSystem
, lib     ? nixpkgs.lib
, pkgsFor ? nixpkgs.legacyPackages.${system}
}: let
  keep   = _: v: ( builtins.tryEval ( lib.isDerivation v ) ).success;
  drvs   = lib.filterAttrs keep pkgsFor;
  names  = builtins.attrNames drvs;
  sdirN  = c: n: builtins.substring 0 c ( lib.toLower n );
  shards = c: builtins.groupBy ( sdirN c ) names;
  defPkg = name: {
    name = lib.toLower name;
    value."default.nix" = ''
      { system ? builtins.currentSystem }: let
        nixpkgs = builtins.getFlake "nixpkgs/${nixpkgs.rev}";
        pkgsFor = nixpkgs.legacyPackages.''${system};
      in pkgsFor."${name}"
    '';
  };
  mkShardDir = ns: builtins.listToAttrs ( map defPkg ns );
  self = {
    unit5 = builtins.mapAttrs ( _: mkShardDir ) ( shards 5 );
    unit4 = builtins.mapAttrs ( _: mkShardDir ) ( shards 4 );
    unit3 = builtins.mapAttrs ( _: mkShardDir ) ( shards 3 );
    unit2 = builtins.mapAttrs ( _: mkShardDir ) ( shards 2 );
    unit1 = builtins.mapAttrs ( _: mkShardDir ) ( shards 1 );
    unit  = self.unit4;
  };
in self
