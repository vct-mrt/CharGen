#include "random_char.h"

int main(int ac, char **av)
{
    if (error(ac, av) == 84) {
        flag_help();
        return 84;
    } else if (ac == 2 && av[1][0] == '-' && av[1][1] == 'h') {
        flag_help();
        return 0;
    } else {
        return process(av[1]);
    }
}