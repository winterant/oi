#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define MAXFN		100
#define MAXTOY		5000
#define MAXLINE		151		// one line
#define MAXL		151
#define MAXM		501

char old[MAXL][MAXL];

int b_height, b_width;
char map[MAXM][MAXM];

int missing = 0;
int out_of_board = 0;
int overlapped = 0;

void print_map();

class CToy{
public:
	int no;
	int height;
	int width;
	int x;
	int y;
	int turn;
	char shape[MAXL][MAXL];
	void maketurn(){
		int i, t, xx, yy;
		for(i = 0; i < turn; i++){
			memcpy(old, shape, sizeof(old));
			for(xx = 0; xx < height; xx++)
				for(yy = 0; yy < width; yy++)
					shape[yy][xx] = ' ';
			for(xx = 0; xx < height; xx++)
				for(yy = 0; yy < width; yy++)
					shape[yy][height-1-xx] = old[xx][yy];
			t = width;
			width = height;
			height = t;
		}
		turn = 0;
	}
	void print(){
		int i, j;
		printf("shape %d:\n", no);
		for(i = 0; i < height; i++){
			for(j = 0; j < width; j++)
				printf("%c", shape[i][j]);
			printf("\n");
		}
	}
	void paint(){
		int i, j;
		int out = 0, ol = 0;
		if(x >= 0 && y >= 0)
		for(i = 0; i < height; i++)
			for(j = 0; j < width; j++)
				if(shape[i][j] == '*'){
					if(x+i >= b_height || y+j >= b_width) out = 1;
					else if(map[x+i][y+j] == ' ') map[x+i][y+j] = '*';
					else{
						ol = 1;
						map[x+i][y+j] = '!';
					}
				}
		if(out){
			printf("Error: toy %d is OUT OF BOARD!\n", no);
			out_of_board = 1;
		}
		if(ol){
			printf("Error: toy %d is overlapping some previously placed toy!\n", no);
			overlapped = 1;
		}
	}
};

int placed[MAXTOY];
char line[MAXLINE];

int n_toy;
CToy toy[MAXTOY];

void print_map()
{
	int i, j;
	for(i = 0; i < b_height; i++){
		for(j = 0; j < b_width; j++)
			printf("%c", map[i][j]);
		printf("\n");
	}
}

void check_for_errors()
{
	int correct = 1;
	if(missing == 1){
		printf("Some toys are MISSING...\n");
		correct = 0;
	}
	if(out_of_board == 1){
		printf("Some toys are OUT OF BOARD...\n");
		correct = 0;
	}
	if(overlapped == 1){
		printf("Some toys are overlapping some others...\n");
		correct = 0;
	}
	if(correct)
		printf("Correct! area = %d\n", b_height*b_width);
}

void check(int c)
{
	char fname_in[MAXFN];
	char fname_out[MAXFN];
	sprintf(fname_in, "graduate%d.in", c);
	sprintf(fname_out, "graduate%d.out", c);
	FILE *fin = fopen(fname_in, "r");
	FILE *fout = fopen(fname_out, "r");
	if(fin == NULL){
		printf("Cannot open %s\n", fname_in);
		exit(-1);
	}else if(fout == NULL){
		printf("Cannot open %s\n", fname_out);
		exit(-1);
	}
	fgets(line, MAXLINE, fin);
	sscanf(line, "%d", &n_toy);
	fscanf(fout, "%d%d", &b_height, &b_width);
	if(b_height <= 0 || b_width <= 0 || b_height > 500 || b_width > 500){
		printf("Fatal error: invalid HEIGHT or WIDTH, should be between 1 and 500.\n");
		exit(-1);
	}

	int i, j, k;
	for(i = 0; i < b_height; i++)
		for(j = 0; j < b_width; j++)
			map[i][j] = ' ';

	printf("Gathering information... (toys are numbered 0,1,2,...)\n");
	for(i = 0; i < n_toy; i++){
		// read toy description
		fgets(line, MAXLINE, fin);
		sscanf(line, "%d", &toy[i].height);
		toy[i].width = 0;
		toy[i].no = i;
		memset(toy[i].shape, 0, sizeof(toy[i].shape));
		for(j = 0; j < toy[i].height; j++){
			fgets(toy[i].shape[j], MAXLINE, fin);
			if((int)strlen(toy[i].shape[j]) > toy[i].width) toy[i].width = strlen(toy[i].shape[j]);
		}
		toy[i].width--;
		for(j = 0; j < toy[i].height; j++)
			for(k = 0; k < toy[i].width; k++)
				if(toy[i].shape[j][k] != '*') toy[i].shape[j][k] = ' ';

		// read placement description
		fscanf(fout, "%d%d%d", &toy[i].turn, &toy[i].x, &toy[i].y);
		if(toy[i].x < 0 || toy[i].y < 0) missing = 1;
		toy[i].maketurn();
		toy[i].paint();
	}
	print_map();
	check_for_errors();
}

int main(int argc, char* argv[])
{
	if(argc != 2){
		printf("Usage graduate_check <test_no>\neg. graduate_check 3\n");
		return -1;
	}else{
		check(atoi(argv[1]));
		return 0;
	}
}