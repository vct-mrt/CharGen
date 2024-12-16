#include "random_char.h"

int main(int ac, char **av)
{
    if (ac == 1 || ac > 2) {
        flag_help();
        return 84;
    }
    else if (error(ac, av) == 84) {
        flag_help();
        return 84;
    }
    else
        return process(av[1]);
}