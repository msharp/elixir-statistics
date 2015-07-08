MIX = mix
# CFLAGS = -g -O3 -ansi -pedantic -Wall -Wextra -Wno-unused-parameter
CFLAGS = -g -O2 -Wall -fno-builtin

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -I$(ERLANG_PATH)

ifeq ($(wildcard deps/cephes),)
	CEPHES_PATH = ../cephes
else
	CEPHES_PATH = deps/cephes
endif

CFLAGS += -I$(CEPHES_PATH)

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

.PHONY: all cmath clean

all: cmath

cmath:
	$(MIX) compile

priv/cmath.so: src/cmath.c
	$(MAKE) -C $(CEPHES_PATH) libmd.a
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ src/cmath.c $(CEPHES_PATH)/libmd.a

clean:
	$(MIX) clean
	$(MAKE) -C $(CEPHES_PATH) clean
	$(RM) priv/cmath.so
