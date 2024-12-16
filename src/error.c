#include "random_char.h"

int error(int ac, char **av)
{
    char *nbr = av[1];
    int result = -1;

    if (ac == 1)
        return 84;
    if (ac > 2)
        return 84;
    for (int i = 0; nbr[i] != '\0'; i++) {
        if ((nbr[i] < '0' || nbr[i] > '9') && nbr[i] != '-')
            return 84;
    }
    result = my_getnbr(nbr);
    if (result == INT_MAX || result == INT_MIN)
        return 84;
    return 0;
}