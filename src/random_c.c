

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



int main(int ac, char **av)
{
}