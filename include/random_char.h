#ifndef RANDOM_CHAR
    #define RANDOM_CHAR
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    #include <time.h>
    #include <limits.h>

void flag_help(void);
int my_random(int nb);
int process(char *nbr);
int my_getnbr(char *nbr);
int my_strlen(char *nbr);
int error(int ac, char **av);

#endif //RANDOM_CHAR