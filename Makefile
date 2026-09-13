# Borg in secondary mode (see README.org and borg/README.org).
#
# Borg itself is installed by package.el into elpa/; assimilated drones live
# in borg/ as Git submodules pinned to exact commits.
#
# The Borg settings (BORG_SECONDARY_P, DRONES_DIR) and EMACS_EXTRA live in
# etc/borg/config.mk, which borg.mk includes before it branches on them.
#
# Without elpa/borg-*/borg.mk (Borg not installed yet) this file defines no
# targets; install Borg with package.el first, e.g.
#   emacs -Q --batch --eval '(progn (package-initialize) (package-install (quote borg)))'

BORG_MK:=$(lastword $(sort $(wildcard elpa/borg-[0-9]*/borg.mk)))

include $(BORG_MK)
