#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static int my_random(int nb)
{
    return rand() % nb;
}

static int my_getnbr(char *nbr)
{
    int nb = 0;
    int i = 0;

    while (nbr[i + 1] != '\0') {
        nb += ((int)nbr[i] - 48);
        nb *= 10;
        i++;
    }
    nb += ((int)nbr[i] - 48);
    return nb;
}

static int my_strlen(char *nbr)
{
    int i = 0;

    while (nbr[i] != '\0') {
        i++;
    }
    return i;
}

int main(int ac, char **av)
{
    char alpha[] = "abcdefghijklmnopqrs tuvwxyz0123456789 ";
    int i = 0;
    int ind = -1;
    int rand = -1;
    int len = my_strlen(alpha);

    if (ac == 1 || ac > 2)
        return 84;
    srand(time(NULL));
    ind = my_getnbr(av[1]);
    while (i < ind) {
        rand = my_random(len);
        printf("%c", alpha[rand]);
        if (i != 0 && i % 100 == 0)
            printf("\n");
        i++;
    }
    printf("\n");
    return 0;
}