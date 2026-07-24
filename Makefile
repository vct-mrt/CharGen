# Makefile for CharGen
VERSION = 1.0.6
DISTNAME = chargen-$(VERSION)

SRC = 	src/main.c			\
		src/lib.c			\
		src/error.c			\
		src/process.c		\
		src/flag_help.c		\
		src/flag_manager.c

NAME = chargen
CC ?= cc
WARNFLAGS = -W -Wall -Wextra
CFLAGS ?= -O2

# Security hardening floor. `override` so it survives a command-line CFLAGS
# override (CI's strict build) and is ADDED to any distro-provided
# CPPFLAGS/LDFLAGS (dpkg-buildflags / rpm optflags) instead of clobbering them.
# FORTIFY_SOURCE is added only when the compiler does not already predefine it:
# Debian/Ubuntu/Fedora gcc inject -D_FORTIFY_SOURCE=2 at -O2 via specs, and a
# second explicit define collides and breaks -Werror. Vanilla gcc (Arch), clang,
# and Snap builds get the floor from us instead.
FORTIFY := $(shell echo | $(CC) -O2 -dM -E - 2>/dev/null | grep -q _FORTIFY_SOURCE || echo -D_FORTIFY_SOURCE=2)
override CPPFLAGS += -I include $(FORTIFY)
override CFLAGS   += -fstack-protector-strong -fPIE
override LDFLAGS  += -pie -Wl,-z,relro,-z,now

# Installation directories
PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1

# Installation with DESTDIR support (for packaging)
DESTDIR ?=

all: $(NAME)

$(NAME): $(SRC)
	$(CC) -o $(NAME) $(SRC) $(WARNFLAGS) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)

install: $(NAME)
	@echo "Installing $(NAME) to $(DESTDIR)$(BINDIR)"
	mkdir -p "$(DESTDIR)$(BINDIR)"
	install -m 0755 "$(NAME)" "$(DESTDIR)$(BINDIR)/$(NAME)"
	@if [ -f "$(NAME).1" ]; then \
		echo "Installing man page to $(DESTDIR)$(MANDIR)"; \
		mkdir -p "$(DESTDIR)$(MANDIR)"; \
		install -m 0644 "$(NAME).1" "$(DESTDIR)$(MANDIR)/$(NAME).1"; \
	fi

uninstall:
	@echo "Uninstalling $(NAME) from $(DESTDIR)$(BINDIR)"
	rm -f "$(DESTDIR)$(BINDIR)/$(NAME)"
	rm -f "$(DESTDIR)$(MANDIR)/$(NAME).1"

clean:
	rm -f $(NAME)
	rm -f chargen-*.tar.gz

debug: CFLAGS += -g3 -DDEBUG
debug: clean $(NAME)

re: clean all

# Run the test suite (builds first)
check: all
	cd tests && ./test.sh

# Source tarball from committed HEAD (excludes .git and build artifacts)
dist:
	git archive --format=tar.gz --prefix=$(DISTNAME)/ -o $(DISTNAME).tar.gz HEAD

.PHONY: all clean install uninstall debug re check dist
