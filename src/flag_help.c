#include "random_char.h"

int flag_help(void)
{
    printf("Usage: ./my_random_char <options> <number>\n");
    printf("Options:\n");
    printf("\t-h\t\tDisplay this help message\n");
    printf("\t-a\t\tgenerates only numeric\n");
    printf("\t-c\t\tgenerates only letters of the alphabet\n");
    printf("\t<number>\tnumber of characters to generate\n");
    printf("By default :\n");
    printf("\t[./my_random_char <number>] generates alpha numeric with special characters\n");
    return 0;
}
