/*
	NOI 2004 Day 2 Problem 3
	Graduate

	Sample Solution
	by Rujia Liu
	
	liurujia@163.net
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#define MAXFN		100
#define MAXTOY		5000	// extracted from input files
#define MAXLINE		150		// maximal length of a line
#define MAXL		150		// how many rows/columns does a toy have?
#define MAXB		10000	// how many squares does a toy have at most?
#define MAXM		501		// map

class TMap{
public:
	int height;
	int width;
	int least_area;
	char map[MAXM][MAXM];
	void clear(int height, int width){
		this->height = height;
		this->width = width;
		for(int i = 0; i < height; i++)
			for(int j = 0; j < width; j++)
				map[i][j] = ' ';
	}
	void get_actual_dim(int& h, int& w){
		h = 0; w = 0;
		for(int i = 0; i < height; i++)
			for(int j = 0; j < width; j++)
				if(map[i][j] == '*'){
					if(i > h) h = i;
					if(j > w) w = j;
				}
	}
	void print(){
		int i, j;
		for(i = 0; i < height; i++){
			for(j = 0; j < width; j++)
				printf("%c", map[i][j]);
			printf("\n");
		}
	}
};

// map definition
TMap map;
int _x[MAXB], _y[MAXB], _count;			// memory... for quick recovery

class CPlace{
public:
	int x;
	int y;
	int turn;
};

char old[MAXL][MAXL];					// for CToy::turn()

class CToy{
public:
	int no;
	int size;
	int height;
	int width;
	char shape[MAXL][MAXL];
	CPlace p;

	void print(){											// for debug
		int i, j;
		printf("shape %d:\n", no);
		for(i = 0; i < height; i++){
			for(j = 0; j < width; j++)
				printf("%c", shape[i][j]);
			printf("\n");
		}
	}
	void turn(){
		int t, xx, yy;
		memcpy(old, shape, sizeof(old));
		for(xx = 0; xx < height; xx++) 
			for(yy = 0; yy < width; yy++) 
				shape[yy][xx] = ' ';
		for(xx = 0; xx < height; xx++)
			for(yy = 0; yy < width; yy++) 
				shape[yy][height-1-xx] = old[xx][yy];		// clockwise
		t = width; 
		width = height;
		height = t;
	}
	void paint(){											// place it
		int t, i, j;
		for(t = 0; t < p.turn; t++) turn();
		for(i = 0; i < height; i++)
			for(j = 0; j < width; j++)
				if(shape[i][j] == '*')
					map.map[p.x+i][p.y+j] = '*';
	}

	int testpaint(int x, int y){							// try to place, calculate the enclosing area
		int i, j;
		_count = 0;
		for(i = 0; i < height; i++)
			for(j = 0; j < width; j++)
				if(shape[i][j] == '*'){
					if(x+i >= map.height || y+j >= map.width) return 0;
					else if(map.map[x+i][y+j] == ' '){
						map.map[x+i][y+j] = '*';
						_x[_count] = x+i;
						_y[_count] = y+j;
						_count++;
					}
					else return 0;
				}
		int h, w;
		map.get_actual_dim(h, w);
		return (h+1)*(w+1);
	}

	void restore(){							// quick recovery ^_^
		for(int i = 0; i < _count; i++)
			map.map[_x[i]][_y[i]] = ' ';
	}

	void findplace(int sx, int sy){			// searching from (sx, sy)
		int x, y, t, area, min = MAXM * MAXM;
		x = sx;
		y = sy;
		for(;;)for(;;){
			for(t = 0; t < 4; t++){
				area = testpaint(x, y);
				restore();
				turn();
				if(area > 0 && area < min){		// if more than one turn is possible, choose the best one
					min = area;	
					p.x = x;
					p.y = y;
					p.turn = t;
				}
			}
			if(min < MAXM * MAXM) return;		// place it on the FIRST position found
			if(++y == map.width){ x++; y = 0; }	// next position
			if(x == map.height) x = 0;
		}
	}
};

// toy definition
int n_toy;
CToy toy[MAXTOY];
int perm[MAXTOY];

// size
int comp1(const void *a,const void *b){ return toy[*(int *)b].size-toy[*(int *)a].size; }

// enclosing area
int comp2(const void *a,const void *b){ return toy[*(int *)b].width*toy[*(int *)b].height-toy[*(int *)a].width*toy[*(int *)a].height; }

// file manipulation
FILE *fin, *fout;
void openfile(int c)
{
	char fname_in[MAXFN];
	char fname_out[MAXFN];
	sprintf(fname_in, "graduate%d.in", c);
	sprintf(fname_out, "graduate%d.out", c);
	fin = fopen(fname_in, "r");
	fout = fopen(fname_out, "w");
	assert(fin != NULL && fout != NULL);
}

void closefile()
{
	fclose(fin);
	fclose(fout);
}

// main procedure
void solve(int c, int height, int width)
{
	int i, j, k;
	char line[MAXLINE];

	fgets(line, MAXLINE, fin);
	sscanf(line, "%d", &n_toy);

	map.clear(height, width);

	for(i = 0; i < n_toy; i++){
		fgets(line, MAXLINE, fin);
		sscanf(line, "%d", &toy[i].height);
		toy[i].width = 0;
		toy[i].no = i;
		toy[i].size = 0;
		memset(toy[i].shape, 0, sizeof(toy[i].shape));
		for(j = 0; j < toy[i].height; j++){
			fgets(toy[i].shape[j], MAXLINE, fin);
			if((int)strlen(toy[i].shape[j]) > toy[i].width) toy[i].width = strlen(toy[i].shape[j]);
		}

		// append spaces at the end of each row
		toy[i].width--;
		for(j = 0; j < toy[i].height; j++)
			for(k = 0; k < toy[i].width; k++)
				if(toy[i].shape[j][k] != '*') toy[i].shape[j][k] = ' ';
				else toy[i].size++;
		if(toy[i].width*toy[i].height > map.least_area) map.least_area = toy[i].width*toy[i].height;
	}

	// in what order do we consider the toys?
	for(i = 0; i < n_toy; i++) perm[i] = i;

	/* 
		Best order for test 7.
		Found with the help of this program.
		Consider two or three toys each time
		S has a length of 100, it should be placed first.
		then consider two toys together.
		Do an enumeration, we see(though not easily) placing O and T together perfectly matches S, so they come next
		continue this procedure until we can find a solution of 100*100.
		
		Note: random permutation can reduce the length of required hand-craft order
	*/
	char *s = "SOTqMHl^L\\AYWEDc[jfhFXZIJ]rbk`Qnpe_GUVgiPoCNBaRmdK";

	// two special cases
	switch(c){
		case 5:
			qsort(perm, n_toy, sizeof(int), comp2);
			break;
		case 7:
			for(i = 0; i < n_toy; i++) perm[i] = s[i] - 'A';
			break;
		default:
			qsort(perm, n_toy, sizeof(int), comp1);
	}
	
	// main loop
	for(i = 0; i < n_toy; i++){
		if(i > 0 && toy[perm[i]].size == toy[perm[i-1]].size)
			toy[perm[i]].findplace(toy[perm[i-1]].p.x, toy[perm[i-1]].p.y);
		else	
			toy[perm[i]].findplace(0, 0);		
		toy[perm[i]].paint();	
	}

	// output
	int h, w;
	map.get_actual_dim(h, w);
	fprintf(fout, "%d %d\n", h+1, w+1);
	for(i = 0; i < n_toy; i++)
		fprintf(fout, "%d %d %d\n", toy[i].p.turn, toy[i].p.x, toy[i].p.y);
}

int main(int argc, char* argv[])
{
	if(argc != 2){
		printf("Usage graduate_c <test_no>\neg. graduate 7\n");
		return -1;
	}else{
		time_t start, end;
		start = time(0);
		int c = atoi(argv[1]);
		openfile(c);
		switch(c){
			case 1:		// hand-craft
				fprintf(fout, "4 9\n1 0 0\n0 0 3\n0 0 6\n");
				break;
			case 3:		// hand-craft
				fprintf(fout, "6 6\n1 4 1\n1 3 0\n2 3 3\n0 2 1\n3 1 0\n0 2 5\n0 0 0\n0 0 4\n2 1 3\n");
				break;
			case 10:	// 20*20 of case 3
				int i, j;
				fprintf(fout, "120 120\n");
				for(i = 0; i < 20; i++)
					for(j = 0; j < 20; j++)
						fprintf(fout, "0 %d %d\n", 4 + i*6, 1 + j*6);
				for(i = 0; i < 20; i++)
					for(j = 0; j < 20; j++){
						fprintf(fout, "1 %d %d\n", 3 + i*6, 0 + j*6);
						fprintf(fout, "2 %d %d\n", 1 + i*6, 0 + j*6);
					}
				for(i = 0; i < 20; i++)
					for(j = 0; j < 20; j++){
						fprintf(fout, "1 %d %d\n", 2 + i*6, 5 + j*6);
						fprintf(fout, "0 %d %d\n", 0 + i*6, 0 + j*6);
					}
				for(i = 0; i < 20; i++)
					for(j = 0; j < 20; j++){
						fprintf(fout, "0 %d %d\n", 2 + i*6, 1 + j*6);
						fprintf(fout, "0 %d %d\n", 0 + i*6, 4 + j*6);
					}
				for(i = 0; i < 20; i++)
					for(j = 0; j < 20; j++){
						fprintf(fout, "3 %d %d\n", 3 + i*6, 3 + j*6);
						fprintf(fout, "1 %d %d\n", 1 + i*6, 3 + j*6);
				}
				break;
			case 2:		// to know how we tune these parameters, read document 
				solve(c, 9, 9);
				break;
			case 4:
				solve(c, 7, 36);
				break;
			case 5:
				solve(c, 18, 121);
				break;
			case 6:
				solve(c, 80, 20);
				break;
			case 7:
			case 8:
			case 9:
				solve(c, 100, 100);
				break;
		}
		end = time(0);
		printf("%d seconds passed...\n", (int)(end - start));

		closefile();
		return 0;
	}
}
