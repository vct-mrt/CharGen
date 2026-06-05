#ifndef RANDOM_CHAR
    #define RANDOM_CHAR
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    #include <time.h>
    #include <unistd.h>
    #include <sys/types.h>
    #include <limits.h>
    #include <stdbool.h>
    
    #define VERSION "1.0.0"
    #define LINE_WIDTH 100
    #define ALPHA_MIN "abcdefghijklmnopqrstuvwxyz"
    #define ALPHA_MAJ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    #define SPE_CHAR "!'#$%&()*+,-./:;<=>?@[\\]^_`{|}~"
    #define NUM "0123456789"

typedef struct FLAGS {
    bool n;
    bool c;
    bool s;
    bool a;
    bool i;
} flags_t;


/* Print usage/help text to stdout; returns 0. */
int flag_help(void);
/* Print version string to stdout; returns 0. */
int flag_version(void);
/* Unbiased random integer in [0, nb); returns 0 if nb <= 0. */
int my_random(int nb);
/* Returns true if every character of nbr is a decimal digit. */
bool is_nbr(char *nbr);
/* Returns the default char-set table (all four sets, NULL-terminated). */
char **create_tab(void);
/* Parse decimal string nbr into int; returns INT_MAX/INT_MIN on overflow. */
int my_getnbr(char *nbr);
/* Returns the length of string nbr (reimplementation of strlen). */
int my_strlen(char *nbr);
/* Returns the number of non-NULL entries in a NULL-terminated char* array. */
int my_tablen(char **tab);
/* Scans argv and returns the first all-digit token (the count), or NULL. */
char *find_nbr(char **av);
/* Parse flags from argv, build char-set list, and run the generation loop. */
int flag_manager(char **av);
/* Pick a random char-set string from the NULL-terminated list. */
char *to_choose(char **list);
/* Validate argc/argv; returns 84 on any error, 0 if arguments are valid. */
int error(int ac, char **av);
/* Generate nbr random characters from list, printing LINE_WIDTH per line. */
int process(char *nbr, char **list);
/* Returns true if str1 and str2 are identical (reimplementation of strcmp==0). */
bool str_compare(char *str1, char *str2);


#endif //RANDOM_CHAR