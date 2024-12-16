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