#include "random_char.h"

static flags_t init_flag(void)
{
    flags_t flags;

    memset(&flags, 0, sizeof(flags));
    flags.n = false;
    flags.c = false;
    flags.s = false;
    flags.i = false;
    flags.a = false;
    return flags;
}

static char **init_list(flags_t flags)
{
    static char *list[5];
    int ind = 0;

    if (flags.n) {
        list[ind] = NUM;
        ind++;
    }
    if (flags.s) {
        list[ind] = SPE_CHAR;
        ind++;
    }
    if (flags.c) {
        if (flags.i) {
            list[ind] = ALPHA_MIN;
            ind++;
        }
        if (flags.a) {
            list[ind] = ALPHA_MAJ;
            ind++;
        }
        // Si ni -i ni -a, utiliser les deux
        if (!flags.i && !flags.a) {
            list[ind] = ALPHA_MIN;
            ind++;
            list[ind] = ALPHA_MAJ;
            ind++;
        }
    }
    list[ind] = NULL;
    return list;
}

int flag_manager(char **av)
{
    flags_t flags = init_flag();
    char *nbr = find_nbr(av);
    char **list;

    for (int i = 0; av[i] != NULL; i++) {
        if (str_compare(av[i], "-h") || str_compare(av[i], "--help"))
            return flag_help();
        if (str_compare(av[i], "-v") || str_compare(av[i], "--version"))
            return flag_version();
        if (av[i][0] == '-') {
            for (int j = 0; av[i][j] != '\0'; j++) {
                if (av[i][j] == 'n') {
                    flags.n = true;
                } else if (av[i][j] == 'c') {
                    flags.c = true;
                } else if (av[i][j] == 's') {
                    flags.s = true;
                } else if (av[i][j] == 'i') {
                    flags.i = true;
                } else if (av[i][j] == 'a') {
                    flags.a = true;
                }
            }
        }
    }
    list = init_list(flags);
    if (!flags.n && !flags.c && !flags.s)
        return process(nbr, create_tab());
    else
        return process(nbr, list);
}