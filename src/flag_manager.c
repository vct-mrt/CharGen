#include "random_char.h"

int flag_manager(char **av)
{
    char *nbr = find_nbr(av);
    bool flag_a = false;
    bool flag_c = false;
    bool flag_s = false;
    int len = 0;
    char *list[5];
    int ind = 0;

    for (int i = 0; av[i] != NULL; i++) {
        if (av[i][0] == '-' && av[i][1] == 'h')
            return flag_help();
        if (av[i][0] == '-') {
            for (int j = 0; av[i][j] != '\0'; j++) {
                if (av[i][j] == 'a') {
                    flag_a = true;
                    len += 1;
                } else if (av[i][j] == 'c') {
                    flag_c = true;
                    len += 1;
                } else if (av[i][j] == 's') {
                    flag_s = true;
                    len += 1;
                }
            }
        }
    }
    if (flag_a) {
        list[ind] = NUM;
        ind++;
    } if (flag_c) {
        list[ind] = ALPHA_MIN;
        ind++;
    } if (flag_s) {
        list[ind] = SPE_CHAR;
        ind++;
    }
    list[ind] = NULL;
    if (!flag_a && !flag_c && !flag_s)
        return process(nbr, create_tab());
    else
        return process(nbr, list);
}