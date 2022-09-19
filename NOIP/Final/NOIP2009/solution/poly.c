#include <stdio.h>

int n;
int p[102] = {0};

int fileread()
{
    int i;
    FILE *fp;
    fp = fopen("poly.in", "r");
    fscanf(fp, "%d", &n);
    for (i = n; i >= 0; i--)
        fscanf(fp, "%d", &p[i]);
    fclose(fp);
    return;    
}

int work()
{
    int i, first = 1;
    FILE *fp;
    fp = fopen("poly.out", "w");
    for (i = n; i >= 0; i--)
    {
        if (p[i] == 0) continue;
        if (first == 1)
        {
            if (p[i] == 1) fprintf(fp, "x^%d", i);
            else if (p[i] == -1) fprintf(fp, "-x^%d", i);
            else fprintf(fp, "%dx^%d", p[i], i);
            first = 0;
        }
        else
        {
            if (p[i] == 1) fprintf(fp, "+");
            else if (p[i] == -1) fprintf(fp, "-");
            else if (p[i] > 0) fprintf(fp, "+%d", p[i]);
            else if (p[i] < 0) fprintf(fp, "%d", p[i]);
            if (i == 1) fprintf(fp, "x");
            else if (i == 0) {if (abs(p[i]) == 1) fprintf(fp, "1");}
            else fprintf(fp, "x^%d", i);
        }
    }
    fprintf(fp, "\n");
    fclose(fp);
    return;
}

int main()
{
    fileread();
    work();
    return 0;
}
