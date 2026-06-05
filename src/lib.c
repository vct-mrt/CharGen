#define _GNU_SOURCE
#include "random_char.h"
#include <sys/random.h>
#include <fcntl.h>
#include <errno.h>

int my_random(int nb)
{
    unsigned int limit;
    unsigned int r;

    if (nb <= 0)
        return 0;
    limit = (unsigned int)RAND_MAX + 1u;
    limit -= limit % (unsigned int)nb;
    do {
        r = (unsigned int)rand();
    } while (r >= limit);
    return (int)(r % (unsigned int)nb);
}

int my_secure_random(int nb)
{
    unsigned int r;
    unsigned int limit;
    unsigned char buf[4];
    ssize_t ret;
    int fd;

    if (nb <= 0)
        return 0;
    limit = UINT_MAX - (UINT_MAX % (unsigned int)nb);
    do {
        /* Try getrandom(), retrying on EINTR. */
        do {
            ret = getrandom(buf, sizeof(buf), 0);
        } while (ret == -1 && errno == EINTR);

        if (ret == -1) {
            /* Fallback: read from /dev/urandom. */
            fd = open("/dev/urandom", O_RDONLY);
            if (fd == -1) {
                fprintf(stderr, "chargen: secure RNG unavailable\n");
                exit(84);
            }
            ret = read(fd, buf, sizeof(buf));
            close(fd);
            if (ret != (ssize_t)sizeof(buf)) {
                fprintf(stderr, "chargen: secure RNG unavailable\n");
                exit(84);
            }
        }
        r = ((unsigned int)buf[0])
          | ((unsigned int)buf[1] << 8)
          | ((unsigned int)buf[2] << 16)
          | ((unsigned int)buf[3] << 24);
    } while (r > limit);
    return (int)(r % (unsigned int)nb);
}

bool is_nbr(char *nbr)
{
    for (int i = 0; nbr[i] != '\0'; i++) {
        if (nbr[i] < 48 || nbr[i] > 57)
            return false;
    }
    return true;
}

bool str_compare(char *str1, char *str2)
{
    int i = 0;

    while (str1[i] != '\0' && str2[i] != '\0') {
        if (str1[i] != str2[i])
            return false;
        i++;
    }
    if (str1[i] != '\0' || str2[i] != '\0')
        return false;
    return true;
}

char *find_nbr(char **av)
{
    for (int i = 0; av[i] != NULL; i++) {
        if (is_nbr(av[i]))
            return av[i];
    }
    return NULL;
}

int my_strlen(char *nbr)
{
    int i = 0;

    while (nbr[i] != '\0') {
        i++;
    }
    return i;
}

int my_tablen(char **tab)
{
    int ind = 0;

    while(tab[ind] != NULL) {
        ind++;
    }
    return ind;
}

char *to_choose(char **list)
{
    int ind = my_random(my_tablen(list));

    return list[ind];
}

char **create_tab(void)
{
    static char *tab[5];

    tab[0] = NUM;
    tab[1] = SPE_CHAR;
    tab[2] = ALPHA_MIN;
    tab[3] = ALPHA_MAJ;
    tab[4] = NULL;
    return tab;
}

int my_getnbr(char *nbr)
{
    int nb = 0;
    int i = 0;
    int flag = 0;

    if (nbr[0] == '-') {
        i = 1;
        flag = 1;
    }

    while (nbr[i] != '\0') {
        if (nb > INT_MAX / 10 || (nb == INT_MAX / 10 && (nbr[i] - '0') > INT_MAX % 10)) {
            return (flag == 1) ? INT_MIN : INT_MAX;
        }
        nb = nb * 10 + (nbr[i] - '0');
        i++;
    }
    if (flag == 1)
        return -nb;
    return nb;
}
