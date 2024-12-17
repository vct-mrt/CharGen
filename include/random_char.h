#ifndef RANDOM_CHAR
    #define RANDOM_CHAR
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    #include <time.h>
    #include <limits.h>
    #include <stdbool.h>
    #define ALPHA_MIN "abcdefghijklmnopqrstuvwxyz"
    #define ALPHA_MAJ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    #define SPE_CHAR " !'#$&()*+-,_./:;<>=?{}@ø£[~|]"
    #define NUM "0123456789"

int flag_help(void);
int my_random(int nb);
bool is_nbr(char *nbr);
char **create_tab(void);
int my_getnbr(char *nbr);
int my_strlen(char *nbr);
int my_tablen(char **tab);
char *find_nbr(char **av);
int flag_manager(char **av);
char *to_choose(char **list);
int error(int ac, char **av);
int process(char *nbr, char **list);


#endif //RANDOM_CHAR