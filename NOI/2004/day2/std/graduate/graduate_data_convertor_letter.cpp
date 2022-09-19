#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<assert.h>
#define	MAX_LINE_LEN	2000
#define MAX_SHAPE_LEN	1000

char line[MAX_LINE_LEN][MAX_LINE_LEN];
char shape[4][MAX_SHAPE_LEN][MAX_SHAPE_LEN];

int top, bottom, left, right, height, width;

void output(int k)
{
	int i, j;
	printf("k = %d\n", k);
	for(i = 0; i < height; i++){
		for(j = 0; j < width; j++)
			printf("%c", shape[k][i][j]);
		printf("\n");
	}
}

int main()
{
	int i, j, n, m, tmp;
	char ch;
	bool found;

	FILE *fp = fopen("graduate7.txt", "r");
	assert(fp != NULL);

	fgets(line[0], MAX_LINE_LEN, fp);
	sscanf(line[0], "%d%d", &n, &m);
	for(i = 0; i < n; i++)
		fgets(line[i], MAX_LINE_LEN, fp);
	fclose(fp);

	fp = fopen("graduate7.in", "w");
	assert(fp != NULL);

	for(ch = 'A'; ch <= 'A'+50; ch++){
		found = false;

		// extract
		top = n+1;
		bottom = -1;
		left = m+1;
		right = -1;
		for(i = 0; i < n; i++)
			for(j = 0; j < strlen(line[i]); j++)
				if(line[i][j] == ch){
					found = true;
					if(i < top) top = i;
					if(i > bottom) bottom = i;
					if(j < left) left = j;
					if(j > right) right = j;
				}
		if(!found) break;

		// turn
		int time = rand() % 4;
		width = right - left + 1;
		height = bottom - top + 1;
		for(i = 0; i < height; i++)
			for(j = 0; j < width; j++)
				if(line[i+top][j+left] == ch)
					shape[0][i][j] = line[i+top][j+left];
				else
					shape[0][i][j] = ' ';
		//output(0);

		for(int t = 1; t <= time; t++){
			for(i = 0; i < height; i++)
				for(j = 0; j < width; j++)
					shape[t][j][height-1-i] = shape[t-1][i][j];
			tmp = width;
			width = height;
			height = tmp;
			//output(t);
		}

		// output
		fprintf(fp, "%d\n", height);
		for(i = 0; i < height; i++){
			for(j = 0; j < width; j++)
				fprintf(fp, "%c", shape[time][i][j] == ' ' ? ' ' : '*');
			fprintf(fp, "\n");
		}		
	}
	return 0;
}