{ system  ? builtins.currentSystem
, nixRFT  ? builtins.getFlake "github:aakropotkin/nix/read-file-type"
, nixBase ? builtins.getFlake "github:NixOS/nix"
, useRFT  ? true
, nix     ? if useRFT then nixRFT else nixBase
}: nix.packages.${system}.nix
