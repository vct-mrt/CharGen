#include "random_char.h"

/* Returns 1 if ch is a valid flag letter, 0 otherwise. */
static int is_valid_flag_char(char ch)
{
    return (ch == 'n' || ch == 'c' || ch == 's' || ch == 'i' ||
            ch == 'a' || ch == 'h' || ch == 'v');
}

int error(int ac, char **av)
{
    char *nbr;
    int result = -1;
    bool has_c = false;
    bool has_i = false;
    bool has_a = false;

    if (ac == 1) {
        fprintf(stderr, "Error: Missing arguments\n");
        fprintf(stderr, "Try 'chargen --help' for more information.\n");
        return 84;
    }

    /* Check for help or version flags first (these don't need a number) */
    for (int i = 1; i < ac; i++) {
        if (str_compare(av[i], "-h") || str_compare(av[i], "--help") ||
            str_compare(av[i], "-v") || str_compare(av[i], "--version")) {
            return 0;
        }
    }

    /* Validate flag tokens: reject unknown flags and unknown long options. */
    for (int i = 1; i < ac; i++) {
        if (av[i][0] == '-') {
            if (av[i][1] == '-') {
                /* Long options: --help, --version (caught above), --secure are valid. */
                if (str_compare(av[i], "--secure")) {
                    continue;
                }
                fprintf(stderr, "chargen: unrecognized option '%s'\n", av[i]);
                fprintf(stderr, "Try 'chargen --help' for more information.\n");
                return 84;
            }
            /* Short flag token: check each character after '-'. */
            for (int j = 1; av[i][j] != '\0'; j++) {
                if (!is_valid_flag_char(av[i][j])) {
                    fprintf(stderr, "chargen: invalid option -- '%c'\n", av[i][j]);
                    fprintf(stderr, "Try 'chargen --help' for more information.\n");
                    return 84;
                }
                if (av[i][j] == 'c')
                    has_c = true;
                if (av[i][j] == 'i')
                    has_i = true;
                if (av[i][j] == 'a')
                    has_a = true;
            }
        }
    }

    /* -i and -a only make sense together with -c. */
    if ((has_i || has_a) && !has_c) {
        fprintf(stderr, "chargen: -i/-a require -c\n");
        fprintf(stderr, "Try 'chargen --help' for more information.\n");
        return 84;
    }

    nbr = find_nbr(av);
    if (nbr == NULL) {
        fprintf(stderr, "Error: No valid number provided\n");
        fprintf(stderr, "Try 'chargen --help' for more information.\n");
        return 84;
    }
    if (!is_nbr(nbr)) {
        fprintf(stderr, "Error: Invalid number format\n");
        return 84;
    }
    result = my_getnbr(nbr);
    if (result == INT_MAX || result == INT_MIN) {
        fprintf(stderr, "Error: Number out of range\n");
        return 84;
    }
    if (result <= 0) {
        fprintf(stderr, "Error: Number must be positive\n");
        return 84;
    }
    return 0;
}