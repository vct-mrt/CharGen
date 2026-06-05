#include "random_char.h"

int main(int ac, char **av)
{
    srand((unsigned int)(time(NULL) ^ getpid())); /* seed: mix pid so same-second runs differ */
    if (error(ac, av) == 84) {
        flag_help();
        return 84;
    } else {
        return flag_manager(av);
    }
}