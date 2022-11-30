#
# Makefile -- 
#
TOP_DIR     = .
CURRENT_DIR = .

SRC_DIR     = $(CURRENT_DIR)/src
TEST_DIR    = $(CURRENT_DIR)/test
LOG_DIR	    = $(CURRENT_DIR)/log

TARGETS = \
        ${SRC_DIR} \
        ${TEST_DIR} \
#

SHELL          = /bin/bash -o pipefail

all:
	for d in $(TARGETS); do \
	    (cd $$d; make $@)   \
	done;

clean:
	rm -rf $(LOG_DIR)

commit: clean
	EDITOR=vi git commit -a

push:
	cat ~/.git_token
	git push -u origin main

pull:
	git pull
