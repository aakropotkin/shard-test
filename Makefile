.PHONY: clean all FORCE
.DEFAULT_GOAL = all

NIX       = nix
NIX_FLAGS = --extra-experimental-features 'nix-command' --impure
RM        = rm -f

CLEANDIRS = unit

unit: gen.nix
	$(RM) -r unit;
	$(NIX) eval $(NIX_FLAGS) --write-to "$$PWD/unit" -f ./gen.nix unit;

clean: FORCE
	$(RM) -r $(CLEANDIRS)

all: unit
