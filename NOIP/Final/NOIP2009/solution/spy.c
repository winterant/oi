#include <stdio.h>
#include <string.h>

unsigned char data[3][101] = {0};
unsigned char dict[26] = {0};
char failed = 0;

int fileread()
{
    char i;
    FILE *fp;
    fp = fopen("spy.in", "r");
    for (i = 0; i < 3; i++)
        fscanf(fp, "%s", data[i]);
    fclose(fp);
    return;    
}

int filewrite()
{
    char i;
    FILE *fp;
    fp = fopen("spy.out", "w");
    if (!failed)
        for (i = 0; data[2][i]; i++)
            fprintf(fp, "%c", data[2][i]);
    else
        fprintf(fp, "Failed");
    fprintf(fp, "\n");
    fclose(fp);
    return;
}

int work()
{
    char i, j, idx;
    for (i = 0; data[0][i] && !failed; i++)
    {
        idx = data[0][i] - 'A';  //ÃÜÎÄ 
        if (dict[idx] == 0)
            dict[idx] = data[1][i];  //Ã÷ÎÄ  
        else
            if (dict[idx] != data[1][i])
                failed = 1;
        for (j = 0; j < 26; j++)
            if ((dict[j] == data[1][i]) && (j != idx))
                failed = 1;
    }
    for (i = 0; i < 26 && !failed; i++)
        if (dict[i] == 0)
            failed = 1;
    for (i = 0; data[2][i] && !failed; i++)
        data[2][i] = dict[data[2][i] - 'A'];
    return;
}

int main()
{
    fileread();
    work();
    filewrite();
    return 0;
}
