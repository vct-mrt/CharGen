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

static void add_flag_to_list(char **list, int *ind, const char *flag)
{
    list[*ind] = flag;
    (*ind)++;
}

static char **init_list(flags_t flags)
{
    static char *list[5];
    int ind = 0;

    if (flags.n)
        add_flag_to_list(list, &ind, NUM);
    if (flags.c && flags.i)
        add_flag_to_list(list, &ind, ALPHA_MIN);
    if (flags.s)
        add_flag_to_list(list, &ind, SPE_CHAR);
    if (flags.c && flags.a)
        add_flag_to_list(list, &ind, ALPHA_MAJ);
    if (flags.c && !flags.a && !flags.i)
        add_flag_to_list(list, &ind, ALPHA_MIN);

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