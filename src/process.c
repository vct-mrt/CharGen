#include "random_char.h"

static int my_random(int nb)
{
    return rand() % nb;
}

static int my_strlen(char *nbr)
{
    int i = 0;

    while (nbr[i] != '\0') {
        i++;
    }
    return i;
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

int process(char *nbr)
{
    char alpha[] = "abcdefghijklmnopqrs tuvwxyz0123456789 ";
    int i = 0;
    int ind = my_getnbr(nbr);
    int rand = -1;
    int len = my_strlen(alpha);

    srand(time(NULL));
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