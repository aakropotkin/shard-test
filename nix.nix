{ system ? builtins.currentSystem
, nixRFT ? builtins.getFlake "github:aakropotkin/nix/read-file-type"
, nixPre ? builtins.getFlake "github:NixOS/nix"
}: {
  pre = nixPre.packages.${system}.nix;
  rft = nixRFT.packages.${system}.nix;
}
