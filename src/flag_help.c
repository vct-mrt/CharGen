#include "random_char.h"

int flag_help(void)
{
    printf("CharGen v%s - Random Character Generator\n\n", VERSION);
    printf("Usage: chargen [options] <number>\n\n");
    printf("Options:\n");
    printf("  -h, --help     Display this help message\n");
    printf("  -v, --version  Display version information\n");
    printf("  -n             Generate only numeric characters\n");
    printf("  -c             Generate only alphabetic characters\n");
    printf("  -s             Generate only special characters\n");
    printf("  -i             Use lowercase letters (with -c)\n");
    printf("  -a             Use uppercase letters (with -c)\n\n");
    printf("Arguments:\n");
    printf("  <number>       Number of characters to generate\n\n");
    printf("Examples:\n");
    printf("  chargen 16         Generate 16 random characters (default)\n");
    printf("  chargen -n 8       Generate 8 numeric characters\n");
    printf("  chargen -ci 12     Generate 12 lowercase letters\n");
    printf("  chargen -ncs 20    Generate 20 chars (numbers + special)\n\n");
    printf("By default: generates alphanumeric with special characters\n");
    return 0;
}

int flag_version(void)
{
    printf("CharGen version %s\n", VERSION);
    printf("Copyright (C) 2025 vct-mrt\n");
    printf("License GPLv3+: GNU GPL version 3 or later\n");
    printf("This is free software: you are free to change and redistribute it.\n");
    return 0;
}
