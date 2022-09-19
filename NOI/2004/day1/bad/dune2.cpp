#include <cstring>
#include "dune_lib.h"

const int MAXN = 101;
const int MAXM = 1000;

int now, n, m, from;
bool havestone;
bool check;
int d[MAXN], p[MAXN], fa[MAXN], fap[MAXN];
int g[MAXN][MAXM], h[MAXN][MAXM];

void dfs(int k)
{
	int _d;
	look(_d, havestone);
	if (havestone && k != n) {
		take_sign();
		check = true;
		if (k != 1) {
			walk(0);
			from = fap[k];
		}
		else from = p[k];
		return;
	}
	int last = 0;
	if (k == 1) last = p[1];
	int start = 1;
	if (k == 1) start = 0;
	for (int i = start; i < d[k]; i++) {
		if (g[k][i] > 0 && g[k][i] != n) {
			walk((i - last + d[k]) % d[k]);
			dfs(g[k][i]);
			last = i;
			if (check) break;
		}
	}
	if (k != 1) {
		from = fap[k];
		walk((d[k] - last) % d[k]);
	}
}

bool isnew(int now)
{
	put_sign();
	int num = 0;
	int way[MAXN];
	int next = 0;
	while (now != 1) {
		walk(d[now] - next);
		way[num++] = fap[now];
		next = fap[now];
		now = fa[now];
	}
	check = false;
	dfs(1);
	int i, j;
	for (j = d[1] - 1; g[1][j] == 0; j--);
	for (i = num - 1; i >= 0; i--) {
		if (i == num - 1) walk(d[1] - from + way[i]);
		else walk(way[i]);
	}
	return (!check);
}

int main()
{
	init();
	now = 1;
	n = 1;
	m = 0;
	memset(d, 0, sizeof(d));
	memset(p, 0, sizeof(p));
	p[1] = -1;
	memset(fa, 0, sizeof(fa));
	memset(fap, 0, sizeof(fap));
	fa[1] = -1;
	look(d[now], havestone);
	while (now != -1) {
		walk(1);
		p[now]++;
		if (p[now] == d[now]) {
			now = fa[now];
			if (now == -1) break;
			continue;
		}
		n++;
		look(d[n], havestone);
		fa[n] = now;
		fap[n] = p[now];;
		g[now][p[now]] = n;
		g[n][0] = now;
		if (!isnew(n)) {
			fa[n] = 0;
			fap[n] = 0;
			d[n] = 0;
			g[now][p[now]] = -1;
			g[n][0] = -1;
			n--;
			walk(0);
		}
		else {
			now = n;
			m += d[n];
			take_sign();
		}
	}
	m += d[1];
	m /= 2;
	report(n, m);
	return 0;
}
