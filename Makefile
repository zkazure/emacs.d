# Borg and all package drones are pinned Git submodules under lib/, the default
# drone directory of Borg's seed bootstrap pattern.

DRONES_DIR := $(shell git config --includes -f .gitmodules --get \
  borg.drones-directory || echo "lib")

-include $(DRONES_DIR)/borg/borg.mk

# `borg-update-autoloads' writes "<drone>-autoloads.el" inside the drone, which
# dirties all 150 submodules.  Load our override so that every borg.mk target
# (`autoloads', `build/<drone>', `native/<drone>', ...) collects the autoloads
# into var/autoloads/autoloads.el instead.  This has to be appended here: borg.mk assigns
# BORG_ARGS itself, after including etc/borg/config.mk.
BORG_ARGS += --load etc/borg/autoloads.el

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
# drone is pinned to an immutable commit.  `make autoloads` scrapes the
# autoload cookies of all drones into the single file
# var/autoloads/autoloads.el (outside the drones, ignored by git), which is
# what makes autoloaded entry points (M-x magit-status and friends) available.
# Run `make build` only when you deliberately want .elc files inside the drones.

autoloads:
	@printf "Generating autoloads (no byte-compilation)...\n"
	@mkdir -p var/autoloads
	$(Q)$(EMACS_BATCH) $(BORG_ARGS) \
	--eval '(my/borg-update-all-autoloads)' 2>&1
	@printf "\n"

.PHONY: autoloads

help helpall::
	$(info )
	$(info Autoloads)
	$(info ---------)
	$(info make autoloads  -- Refresh var/autoloads/autoloads.el without byte-compiling)
	@printf "\n"
