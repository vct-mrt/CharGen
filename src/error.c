#include "random_char.h"

int error(int ac, char **av)
{
    char *nbr;
    int result = -1;

    if (ac == 1)
        return 84;
    nbr = find_nbr(av);
    if (is_nbr(nbr)) {
        result = my_getnbr(nbr);
        if (result == INT_MAX || result == INT_MIN)
            return 84;
        return 0;
    } else
        return 84;
}