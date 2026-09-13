# Borg secondary mode: Borg itself comes from package.el while drones live in
# borg/ (see Makefile / .borgconfig).  DRONES_DIR must be set explicitly here:
# borg.mk would default it to "elpa" while borg.el resolves "borg".
BORG_SECONDARY_P:=true
DRONES_DIR:=borg

EMACS_EXTRA = --eval "(setq load-prefer-newer t)"
