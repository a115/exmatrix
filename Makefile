ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS = -g -O3 -pedantic -Wall -Wextra -I$(ERLANG_PATH)

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

priv/lib_matrix.so: clean
	@$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ c_src/nif_matrix.c

clean:
	@$(RM) -r priv/*

