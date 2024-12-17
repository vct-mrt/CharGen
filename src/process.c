#include "random_char.h"

int process(char *nbr, char **list)
{
    int i = 0;
    int ind = my_getnbr(nbr);
    char *charac;
    int len = -1;
    int rand = -1;

    srand(time(NULL));
    while(i < ind) {
        charac = to_choose(list);
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
