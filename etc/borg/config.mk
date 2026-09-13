# Borg primary mode: Borg and its drones live in lib/.  Keep this explicit so
# the build path matches .borgconfig.
DRONES_DIR:=lib

EMACS_EXTRA = --eval "(setq load-prefer-newer t)"
