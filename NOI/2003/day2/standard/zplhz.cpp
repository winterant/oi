/*
	NOI 2003 Chain
	By Rujia Liu
*/

#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<assert.h>
#define DEBUG
#define MAXN 101
#define MAXNODE 500			// can be adjusted

int enemy[MAXN][2];
int hero[MAXN][2];

int cankill[MAXN][MAXN];
int last[MAXN][MAXN];		// last[a][b] means the last person a can kill if hero a is facing hero b

int used[MAXN];
int last_temp[MAXN];		// this is TEMPORARILY used by function 'search'

int n_enemy, n_hero, e_dist;
int d[MAXN];
int ans[MAXN];

int maxdepth = 0;
int node_count;

int sqr_dist(int x1, int y1, int x2, int y2)
{
	return (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
}

void init()
{
	int i, j;
	FILE *fp;
	fp = fopen("zplhz.in","r");
	assert(fp != NULL);
	fscanf(fp, "%d%d%d", &n_enemy, &n_hero, &e_dist);
	for(i = 0; i < n_enemy; i++)
		fscanf(fp, "%d%d", &enemy[i][0], &enemy[i][1]);
	for(i = 0; i < n_hero; i++)
		fscanf(fp, "%d%d", &hero[i][0], &hero[i][1]);
	fclose(fp);
	
	for(i = 0; i < n_hero; i++)
		for(j = 0; j < n_enemy; j++)
			if (sqr_dist(hero[i][0], hero[i][1], enemy[j][0], enemy[j][1])<= e_dist*e_dist)
				cankill[i][j] = 1;
			else
				cankill[i][j] = 0;
	
	for(i = 0; i < n_hero; i++){
		if(cankill[i][n_enemy-1])
			last[i][n_enemy-1] = n_enemy-1;
		else
			last[i][n_enemy-1] = -1;
		for(j = n_enemy-2; j >=0; j--){
			if(!cankill[i][j])
				last[i][j] = -1;
			else if(!cankill[i][j+1])
				last[i][j] = j;
			else
				last[i][j] = last[i][j+1];
		}
	}
}

int lowerbound(int ene)
{
	int i;
	int l, max, now, c = 0;
	if(ene >= n_enemy) return 0;
	now = ene;
	while(1){
		max = -1;
		for(i = 0; i < n_hero; i++)
			if(!used[i] && cankill[i][now]){
				l = last[i][now]+1;
				if(l>max) max = l;
			}
		if(max == -1) return -1;
		now = max;
		c++;
		if(now >= n_enemy) return c;
	}
}

int search(int ene, int count)
{
	int i, j, c = 0, lb;
	int sorted[MAXN];

	node_count++;
	if(node_count > MAXNODE) return 0;

	if(ene >= n_enemy){
			for(i = 0; i < maxdepth; i++)
				ans[i] = d[i];
			return 1;
	}else{
		for(i = 0; i < n_hero; i++)
			if(!used[i] && cankill[i][ene]){
				sorted[c] = i;
				last_temp[c++] = last[i][ene]+1;
			}

		// I used to sort, but now i don't :)
		for(j = 0; j < c; j++){
			i = sorted[j];
			used[i] = 1;
			d[count] = i;
			lb = lowerbound(last[i][ene]+1);
			if(lb >= 0 && count + 1 + lb <= maxdepth)
				if(search(last[i][ene]+1, count+1)) return 1;
			used[i] = 0;
		}
	}
	return 0;
}

void solve()
{
	int i;
	memset(used, 0, sizeof(used));

	while(1){
		maxdepth++;
		node_count = 0;
		if(search(0, 0)) break;
		if(maxdepth >= n_hero) break;
	}
	FILE *fp;
	fp = fopen("zplhz.out", "w");
	assert(fp != NULL);
	fprintf(fp, "%d\n", maxdepth);
	fprintf(fp, "%d", ans[0]+1);
	for(i = 1; i < maxdepth; i++)
		fprintf(fp, " %d", ans[i]+1);
	fprintf(fp, "\n");
	fclose(fp);
}

int main()
{
	init();
	solve();
	return 0;
}
