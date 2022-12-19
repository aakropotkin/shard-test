{ unitDirR ? ./unit
, unitDirP ? builtins.path { path = ./unit; recursive = true; }
, useP     ? false
, unitDir  ? if useP then unitDirP else unitDirR
}:
let
  shardDirs = let
    dents = builtins.readDir unitDir;
    keep  = n: dents.${n} == "directory";
  in builtins.filter keep ( builtins.attrNames dents );
  shardPkgNames = sd: let
    dents = builtins.readDir ( unitDir + ( "/" + sd ) );
    keep  = n: dents.${n} == "directory";
  in builtins.filter keep ( builtins.attrNames dents );
in {
  names = builtins.concatMap shardPkgNames shardDirs;
}
