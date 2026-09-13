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
