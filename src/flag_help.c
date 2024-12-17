#include "random_char.h"

int flag_help(void)
{
    printf("Usage: ./chargen <options> <number>\n");
    printf("Options:\n");
    printf("\t-h\t\tDisplay this help message\n");
    printf("\t-n\t\tgenerates only numeric\n");
    printf("\t-c\t\tgenerates only letters of the alphabet\n");
    printf("\t-s\t\tgenerates only special characters\n");
    printf("\t-i\t\tletters are in lower case (required -c)\n");
    printf("\t-a\t\tletters are in upper case (required -c)\n");
    printf("\t<number>\tnumber of characters to generate\n");
    printf("By default :\n");
    printf("\t[./chargen <number>] generates alpha numeric with special characters\n");
    return 0;
}
