#include "random_char.h"

int my_random(int nb)
{
    return rand() % nb;
}

bool is_nbr(char *nbr)
{
    for (int i = 0; nbr[i] != '\0'; i++) {
        if (nbr[i] < 48 || nbr[i] > 57)
            return false;
    }
    return true;
}

char *find_nbr(char **av)
{
    for (int i = 0; av[i] != NULL; i++) {
        if (is_nbr(av[i]))
            return av[i];
    }
    return NULL;
}

int my_strlen(char *nbr)
{
    int i = 0;

    while (nbr[i] != '\0') {
        i++;
    }
    return i;
}

char *to_choose(void)
{
    int ind = my_random(4);
    if (ind == 1)
        return ALPHA_MAJ;
    if (ind == 2)
        return ALPHA_MIN;
    if (ind == 3)
        return NUM;
    else
        return SPE_CHAR;
}

int my_getnbr(char *nbr)
{
    int nb = 0;
    int i = 0;
    int flag = 0;

    if (nbr[0] == '-') {
        i = 1;
        flag = 1;
    }

    while (nbr[i] != '\0') {
        if (nb > INT_MAX / 10 || (nb == INT_MAX / 10 && (nbr[i] - '0') > INT_MAX % 10)) {
            return (flag == 1) ? INT_MIN : INT_MAX;
        }
        nb = nb * 10 + (nbr[i] - '0');
        i++;
    }
    if (flag == 1)
        return -nb;
    return nb;
}
