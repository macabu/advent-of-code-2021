#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ARRAY_LEN(x) sizeof(x)/sizeof(x[0])

static int INPUT[2000];

int part_one()
{
    int increases = 0;

    for (int i = 1; i < ARRAY_LEN(INPUT); i++)
    {
        if (INPUT[i] > INPUT[i-1]) 
        {
            increases++;
        }
    }

    return increases;
}

int part_two()
{
    int increases = 0, prev_sliding_sum = 0, curr_sliding_sum = 0;

    for (int i = 2; i < ARRAY_LEN(INPUT); i++)
    {
        curr_sliding_sum = INPUT[i-2] + INPUT[i-1] + INPUT[i];

        if (i != 2 && curr_sliding_sum > prev_sliding_sum)
        {
            increases++;
        }

        prev_sliding_sum = curr_sliding_sum;
    }

    return increases;
}

int parse_input()
{
    FILE *fd = fopen("input.txt", "r");
    if (fd == NULL) {
        return -1;
    }

    char *line = NULL;
    size_t len = 0;
    ssize_t r;

    int i = 0;
    while ((r = getline(&line, &len, fd)) != -1)
    {
        INPUT[i] = atoi(line);
        i++;
    }

    fclose(fd);

    if (line)
    {
        free(line);
    }

    return 0;
}

int main()
{
    if (parse_input() < 0)
    {
        return -1;
    }

    printf("Part One: %d\n", part_one());
    printf("Part Two: %d\n", part_two());

    return 0;
}
