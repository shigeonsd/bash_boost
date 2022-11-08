#
# Makefile -- 関数の単体テスト
#
TOP_DIR	    = ..
CURRENT_DIR = .

TARGETS = \
	funcs \
	modules \
	class \
#

SHELL          = /bin/bash -o pipefail

all:
	for d in $(TARGETS); do
	    (cd $$d; make $@)
	done;

clean:
	for d in $(TARGETS); do
	    (cd $$d; make $@)
	done;

var_dump:
	@echo $(CURRENT_DIR)
	@echo $(TOP_DIR)
	@echo $(TARGETS)
