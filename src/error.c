#include "random_char.h"

int error(int ac, char **av)
{
    char *nbr = av[1];

    if (ac == 1)
        return 84;
    if (ac > 2)
        return 84;
    if (ac == 2) {
        for (int i = 0; nbr[i] != '\0'; i++) {
            if (nbr[i] < 48 || nbr[i] > 57)
                return 84;
        }
    }
    return 0;
}