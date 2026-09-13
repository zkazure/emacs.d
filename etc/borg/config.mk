# Borg primary mode: Borg and its drones live in borg/.  Keep this explicit so
# the build path matches .borgconfig.
DRONES_DIR:=borg

EMACS_EXTRA = --eval "(setq load-prefer-newer t)"
