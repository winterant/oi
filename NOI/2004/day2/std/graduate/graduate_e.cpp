#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define SCORE_FILE	"/tmp/_eval.score"

#define ERR_NO		0
#define ERR_SIZE	1
#define ERR_BAD		2
#define ERR_OUT		3
#define ERR_OVER	4

#define STR_SIZE	"height and width should be between 1 to 500."
#define STR_BAD		"Invalid turn angle or coordinate."
#define STR_OUT		"Some toys are out of board."
#define STR_OVER	"Some toys are overlapping."

#define MAX_FN		100
#define MAXTOY		5000
#define MAXLINE		151
#define MAXL		151
#define MAXM		501

char old[MAXL][MAXL];

int b_height, b_width;
char map[MAXM][MAXM];

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
	int paint(){
		int i, j;
		if(x >= 0 && y >= 0)
		for(i = 0; i < height; i++)
			for(j = 0; j < width; j++)
				if(shape[i][j] == '*'){
					if(x+i >= b_height || y+j >= b_width) return ERR_OUT;
					else if(map[x+i][y+j] == ' ') map[x+i][y+j] = '*';
					else return ERR_OVER;
				}
		return ERR_NO;
	}
};

int placed[MAXTOY];
char line[MAXLINE];

int n_toy;
CToy toy[MAXTOY];

int check(FILE* fin, FILE* fout, int& area)
{
	fgets(line, MAXLINE, fin);
	sscanf(line, "%d", &n_toy);
	fscanf(fout, "%d%d", &b_height, &b_width);
	if(b_height > 500 || b_width > 500 || b_height <= 0 || b_width <= 0) return ERR_SIZE;

	int i, j, k;
	for(i = 0; i < b_height; i++)
		for(j = 0; j < b_width; j++)
			map[i][j] = ' ';

	for(i = 0; i < n_toy; i++){
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

		fscanf(fout, "%d%d%d", &toy[i].turn, &toy[i].x, &toy[i].y);
		if(toy[i].x < 0 || toy[i].y < 0 || toy[i].turn < 0 || toy[i].turn > 3) return ERR_BAD;
		toy[i].maketurn();

		int res = toy[i].paint();
		if (res != ERR_NO) return res;
	}
	area = b_height * b_width;
	return ERR_NO;
}

/*
  Parameters:  .in  .out  .ans
  Eval: 
  - first line:  score
  - second line: message
*/

void main(int argc, char * argv[])
{
	FILE *in, *out, *ans, *eval;
	int area, min_area;

	in = fopen(argv[1], "r");
	out = fopen(argv[2], "r");
	ans = fopen(argv[3], "r");
	eval = fopen(SCORE_FILE, "w");
	if(out == NULL){
		fprintf(eval, "0\nOutput file not found!\n");
	}else{
		int res = check(in, out, area);
		if(res != ERR_NO){
			switch(res){
				case ERR_SIZE:
					fprintf(eval, "0\n%s", STR_SIZE);
					break;
				case ERR_BAD:
					fprintf(eval, "0\n%s", STR_BAD);
					break;
				case ERR_OUT:
					fprintf(eval, "0\n%s", STR_OUT);
					break;
				case ERR_OVER:
					fprintf(eval, "0\n%s", STR_OVER);
					break;
			}
		}else{
			fscanf(ans, "%d", &min_area);
			int score = min_area * 9 / area + 1;
			if(score > 10) score = 10;
			fprintf(eval, "%d\n Your area = %d, Min area = %d\n", score, area, min_area);
		}
	}
    fclose(out);
    fclose(ans);
	fclose(eval);
}
