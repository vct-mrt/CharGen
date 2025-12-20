# Makefile for CharGen
VERSION = 1.0.0

SRC = 	src/main.c			\
		src/lib.c			\
		src/error.c			\
		src/process.c		\
		src/flag_help.c		\
		src/flag_manager.c

NAME = chargen
CC = gcc
CPPFLAGS = -I include
CFLAGS = -W -Wall -Wextra -O2
LDFLAGS =

# Installation directories
PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1

# Installation with DESTDIR support (for packaging)
DESTDIR ?=

all: $(NAME)

$(NAME): $(SRC)
	$(CC) -o $(NAME) $(SRC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)

install: $(NAME)
	@echo "Installing $(NAME) to $(DESTDIR)$(BINDIR)"
	install -D -m 0755 $(NAME) $(DESTDIR)$(BINDIR)/$(NAME)
	@if [ -f "$(NAME).1" ]; then \
		echo "Installing man page to $(DESTDIR)$(MANDIR)"; \
		install -D -m 0644 $(NAME).1 $(DESTDIR)$(MANDIR)/$(NAME).1; \
	fi

uninstall:
	@echo "Uninstalling $(NAME) from $(DESTDIR)$(BINDIR)"
	rm -f $(DESTDIR)$(BINDIR)/$(NAME)
	rm -f $(DESTDIR)$(MANDIR)/$(NAME).1

clean:
	rm -f $(NAME)

debug: CFLAGS += -g3 -DDEBUG
debug: clean $(NAME)

re: clean all

.PHONY: all clean install uninstall debug re
