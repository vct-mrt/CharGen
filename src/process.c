#include "random_char.h"

int process(char *nbr, char **list, flags_t flags)
{
    int i = 0;
    int ind = my_getnbr(nbr);
    char *charac;
    int len = -1;
    int char_idx = -1;
    int set_idx = -1;
    int nsets = my_tablen(list);

    while(i < ind) {
        if (flags.secure)
            set_idx = my_secure_random(nsets);
        else
            set_idx = my_random(nsets);
        charac = list[set_idx];
        len = my_strlen(charac);
        if (flags.secure)
            char_idx = my_secure_random(len);
        else
            char_idx = my_random(len);
        printf("%c", charac[char_idx]);
        if (i != 0 && i % LINE_WIDTH == 0)
            printf("\n");
        i++;
    }
    printf("\n");
    return 0;
}
