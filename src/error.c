#include "random_char.h"

int error(int ac, char **av)
{
    char *nbr;
    int result = -1;

    if (ac == 1) {
        fprintf(stderr, "Error: Missing arguments\n");
        fprintf(stderr, "Try 'chargen --help' for more information.\n");
        return 84;
    }
    
    // Check for help or version flags first (these don't need a number)
    for (int i = 1; i < ac; i++) {
        if (str_compare(av[i], "-h") || str_compare(av[i], "--help") ||
            str_compare(av[i], "-v") || str_compare(av[i], "--version")) {
            return 0;
        }
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