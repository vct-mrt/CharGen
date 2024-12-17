#include "random_char.h"

int flag_manager(char **av)
{
    char *nbr = find_nbr(av);

    for (int i = 0; av[i] != NULL; i++) {
        if (av[i][0] == '-' && av[i][1] == 'a')
            return handle_process(nbr, NUM);
        if (av[i][0] == '-' && av[i][1] == 'h')
            return flag_help();
    }
    return process(nbr);
}