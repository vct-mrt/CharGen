#include "random_char.h"

int process(char *nbr, char **list)
{
    int i = 0;
    int ind = my_getnbr(nbr);
    char *charac;
    int len = -1;
    int char_idx = -1;

    while(i < ind) {
        charac = to_choose(list);
        len = my_strlen(charac);
        char_idx = my_random(len);
        printf("%c", charac[char_idx]);
        if (i != 0 && i % LINE_WIDTH == 0)
            printf("\n");
        i++;
    }
    printf("\n");
    return 0;
}
