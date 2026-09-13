# Borg, used in secondary mode alongside package.el (see README.org).
#
#   * Borg itself is installed with package.el into elpa/.
#   * Assimilated drones live in borg/ as Git submodules (pinned commits).
#   * DRONES_DIR is set explicitly: borg.mk would otherwise default to
#     "elpa" while borg.el resolves "borg" from .borgconfig, and the two
#     must agree.
#
# Prerequisite (fresh clone): install Borg with package.el, e.g.
#   emacs -Q --batch --eval '(progn (package-initialize) (package-install (quote borg)))'

BORG_SECONDARY_P = true
DRONES_DIR       = borg

BORG_MK := $(lastword $(sort $(wildcard elpa/borg-[0-9]*/borg.mk)))

ifeq ($(BORG_MK),)
  $(warning Borg is not installed under elpa/ yet: see the top of this Makefile.)
else
  include $(BORG_MK)
endif
