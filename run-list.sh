#! /usr/bin/env bash
# ============================================================================ #
#
#
#
# ---------------------------------------------------------------------------- #

: "${NIX_SYS:=nix}";
: "${BASH:=bash}";
: "${TR:=tr}";
: "${BC:=bc}";
: "${REALPATH:=realpath}";
: "${TIME:=time}";
: "${DATE:=date}";

if test -z "${NIX_FLAGS:-}"; then
  NIX_FLAGS='--extra-experimental-features nix-command';
  NIX_FLAGS="$NIX_FLAGS --extra-experimental-features flakes";
fi

trap '_es="$?"; exit "$_es";' HUP EXIT INT QUIT ABRT;

: "${SPATH:=$( $REALPATH "${BASH_SOURCE[0]}"; )}";
: "${SDIR:=${SPATH%/*}}"
_as_me="${SPATH##*/}";

: "${NIX_RFT:=$NIX_SYS $NIX_FLAGS run -f "$SDIR/nix.nix" rft --}";
: "${NIX_PRE:=$NIX_SYS $NIX_FLAGS run -f "$SDIR/nix.nix" pre --}";


# ---------------------------------------------------------------------------- #

# list_with (true|false) [NIX]
# ----------------------------
list_with() {
  local _NIX _COPY_TO_STORE _T;
  _COPY_TO_STORE="$1";
  shift;
  _NIX="${@:-$NIX_SYS}";

  case "$_COPY_TO_STORE" in
    true)  # intentionally invalidate any previous store paths
      $DATE +%s > ./unit/.stamp;
    ;;
    false) :; ;;
    *)
      echo "$_as_me:list_with: first arg must be 'true' or 'false'." >&2;
      exit 1;
    ;;
  esac
  
  $_NIX --version >/dev/null;  # Don't include building Nix in timer.

  # Obviously not a perfect timer; but it's a start.

  {
    {
      echo 'scale=3; ( ( 0.0';
      for i in 0 1 2 3 4 5 6 7 8 9; do
        echo ' + ';
        $BASH -c "$TIME               \
          $_NIX eval $NIX_FLAGS       \
          --no-eval-cache             \
          -f ./list.nix names         \
          --arg useP $_COPY_TO_STORE  \
        >/dev/null;" 2>&1;
      done
      echo ' ) / 10.0 ) ';
    }|$TR $'\n' ' ';
    echo '';
  }|$BC;
}


# ---------------------------------------------------------------------------- #

export TIMEFORMAT='%3R';
echo "list_with copy latest:";
list_with true $NIX_PRE;

echo "list_with copy patched:";
list_with true $NIX_RFT;

echo "list_with raw latest:";
list_with false $NIX_PRE;

echo "list_with raw patched:";
list_with false $NIX_RFT;


# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
