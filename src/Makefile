#
# Makefile -- 関数の単体テスト
#
TOP_DIR	      = ..
CURRENT_DIR   = .

FUNCS_DIR     = $(CURRENT_DIR)/funcs
MODULES_DIR   = $(CURRENT_DIR)/modules     
CLASS_DIR     = $(CURRENT_DIR)/class      

TARGETS = \
        ${FUNCS_DIR} \
        ${MODULES_DIR} \
        ${CLASS_DIR} \
#

SHELL          = /bin/bash -o pipefail

all:
	for d in $(TARGETS); do \
	    (cd $$d; make $@) \
	done; \

clean:
	for d in $(TARGETS); do
	    (cd $$d; make $@)
	done;

var_dump:
	@echo $(CURRENT_DIR)
	@echo $(TOP_DIR)
	@echo $(TARGETS)
