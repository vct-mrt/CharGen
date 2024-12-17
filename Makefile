SRC = 	src/main.c			\
		src/lib.c			\
		src/error.c			\
		src/process.c		\
		src/flag_help.c		\
		src/flag_manager.c	\

NAME = random

CPPFLAGS = -I include
WFLAGS =  -W -Wall -Wextra
OPTIFLAG = -O2

all : $(NAME)
$(NAME): $(SRC)
	gcc -o $(NAME) $(SRC) $(WFLAGS) $(CPPFLAGS)

clean:
	rm -f $(NAME)

debug: CPPFLAGS += -g3
debug: re

re: clean all
