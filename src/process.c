#include "random_char.h"

int handle_process(char *nbr, char *charac)
{
    int ind = my_getnbr(nbr);
    int i = 0;
    int len = my_strlen(charac);
    int rand = -1;

    srand(time(NULL));
    while(i < ind) {
        rand = my_random(len);
        printf("%c", charac[rand]);
        if (i != 0 && i % 100 == 0)
            printf("\n");
        i++;
    }
    printf("\n");
    return 0;
}

int process(char *nbr)
{
    char *charac;
    int i = 0;
    int ind = my_getnbr(nbr);
    int rand = -1;
    int len = -1;

    srand(time(NULL));
    while (i < ind) {
        charac = to_choose();
        len = my_strlen(charac);
        rand = my_random(len);
        printf("%c", charac[rand]);
        if (i != 0 && i % 100 == 0)
            printf("\n");
        i++;
    }
    printf("\n");
    return 0;
}