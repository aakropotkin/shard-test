.PHONY: clean all FORCE
.DEFAULT_GOAL = all

NIX_SYS   = nix
NIX_FLAGS = --extra-experimental-features nix-command  \
			--extra-experimental-features flakes
NIX_RFT   = $(NIX_SYS) $(NIX_FLAGS) run -f ./nix.nix rft --
NIX_PRE   = $(NIX_SYS) $(NIX_FLAGS) run -f ./nix.nix pre --
NIX       = $(NIX_SYS)
RM        = rm -f
TIME      = time

CLEANDIRS = unit

unit: gen.nix
	$(RM) -r unit;
	$(NIX) eval $(NIX_FLAGS) --write-to "$$PWD/unit" -f ./gen.nix unit;

clean: FORCE
	$(RM) -r $(CLEANDIRS)

all: unit
