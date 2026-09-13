# Borg and all package drones are pinned Git submodules under borg/.
# This follows Borg's seed bootstrap pattern, adapted to borg/ instead of lib/.

DRONES_DIR := $(shell git config --includes -f .gitmodules --get \
  borg.drones-directory || echo "lib")

-include $(DRONES_DIR)/borg/borg.mk

ifndef BORG_DIR

help helpall::
	$(info )
	$(info Bootstrapping)
	$(info -------------)
	$(info make bootstrap-borg  -- Make Borg and make targets available)
	@printf "\n"

GITDIR := $(shell realpath --relative-to=. "$$(git rev-parse --git-dir)")
SRCDIR ?= $(shell git config -f .gitmodules submodule.borg.path)
URL    ?= $(shell git config -f .gitmodules submodule.borg.url)

bootstrap-borg:
	mkdir -p "$(GITDIR)/modules"
	git clone $(URL) $(SRCDIR) --separate-git-dir "$(GITDIR)/modules/borg"

endif

# This configuration uses Borg for *source pinning*, not for building the
# drones: byte-code inside the submodules is what makes `git status` noisy
# and is not needed because native JIT compilation stays disabled and every
# drone is pinned to an immutable commit.  `make autoloads` refreshes the
# generated *-autoloads.el files, which are what makes autoloaded entry points
# (M-x magit-status and friends) available.  Run `make build` only when you
# deliberately want .elc files inside the drones.

autoloads:
	@printf "Generating autoloads (no byte-compilation)...\n"
	$(Q)$(EMACS_BATCH) $(BORG_ARGS) \
	--eval '(borg-do-drones (drone) (borg-update-autoloads drone))' 2>&1
	@printf "\n"

.PHONY: autoloads

help helpall::
	$(info )
	$(info Autoloads)
	$(info ---------)
	$(info make autoloads  -- Refresh drone autoloads without byte-compiling)
	@printf "\n"
