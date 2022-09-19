#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<assert.h>
#define	MAX_LINE_LEN	2000
#define MAX_SHAPE_LEN	1000

int line[MAX_LINE_LEN][MAX_LINE_LEN];
int shape[4][MAX_SHAPE_LEN][MAX_SHAPE_LEN];

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
	int ch;
	bool found;

	FILE *fp = fopen("graduate9.txt", "r");
	assert(fp != NULL);

	fscanf(fp, "%d%d", &n, &m);
	for(i = 0; i < n; i++)
		for(j = 0; j < m; j++)
			fscanf(fp, "%d", &line[i][j]);
	fclose(fp);

	fp = fopen("graduate9.in", "w");
	assert(fp != NULL);

	for(ch = 0; ch <= 10000; ch++){
		found = false;

		// extract
		top = n+1;
		bottom = -1;
		left = m+1;
		right = -1;
		for(i = 0; i < n; i++)
			for(j = 0; j < m; j++)
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
					shape[0][i][j] = -1;
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
				fprintf(fp, "%c", shape[time][i][j] == -1 ? ' ' : '*');
			fprintf(fp, "\n");
		}		
	}
	return 0;
}