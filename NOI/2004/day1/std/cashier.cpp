#include <iostream>
#include <fstream>
#include <memory>

using namespace std;

ifstream fin("cashier.in");
ofstream fout("cashier.out");

struct Node {
	int value;
	int num;
	int nodenum;
};

const int LimitN = 500000;
const int LimitM = 100;
const int LimitL = 100000;
const int LimitAddValue = 1000;
const int LimitValue = 100000;
const int LimitTree = LimitValue * 10;
const int LimitAdd = LimitAddValue * LimitM;

Node t[LimitTree];
int N, Min, k;
int delta;
int thrownum;
char command;

void Build_tree(int now, int l, int r)
{
	int m = (l + r) / 2;
	t[now].value = m;
	if (l <= m - 1) Build_tree(now * 2, l, m - 1);
	if (m + 1 <= r) Build_tree(now * 2 + 1, m + 1, r);
}

void Init_tree()
{
	memset(t, 0, sizeof(t));
	Build_tree(1, -LimitAdd, LimitValue + LimitAdd);
}

void Insert_tree(int x)
{
	int now = 1;
	while (t[now].value != x) {
		t[now].nodenum++;
		if (t[now].value > x) now = now * 2;
		else now = now * 2 + 1;
	}
	t[now].nodenum++;
	t[now].num++;
}

void Update_tree(int k)
{
	if (t[k].nodenum == 0) return;
	if (2 * k < LimitTree) Update_tree(2 * k);
	if (t[k].value + 1 < Min - delta && 2 * k + 1 < LimitTree) Update_tree(2 * k + 1);
	if (t[k].value < Min - delta) {
		thrownum += t[k].num;
		t[k].num = 0;
	}
	t[k].nodenum = t[2 * k].nodenum + t[k].num + t[2 * k + 1].nodenum;
}

void Insert(int x)
{
	if (x < Min) return;
	x -= delta;
	Insert_tree(x);
}

void Add(int x)
{
	delta += x;
}

void Sub(int x)
{
	delta -= x;
	Update_tree(1);
}

void Find(int k)
{
	int now = 1;
	if (k > t[1].nodenum) {
		fout << -1 << endl;
		return;
	}
	k = t[1].nodenum + 1 - k;
	while (k > 0) {
		if (now * 2 < LimitTree && k <= t[now * 2].nodenum) {
			now = now * 2;
			continue;
		}
		else {
			if (now * 2 < LimitTree) k -= t[now * 2].nodenum;
			if (k <= t[now].num) break;
		}
		k -= t[now].num;
		now = now * 2 + 1;
	}
	fout << t[now].value + delta << endl;
}

int main()
{	
	fin >> N >> Min;
	delta = 0;
	thrownum = 0;
	Init_tree();
	for (int i = 0; i < N; i++) {
		fin >> command >> k;
		switch(command) {
			case 'I'/*Insert*/:Insert(k);break;
			case 'A'/*Add*/:Add(k);break;
			case 'S'/*Sub*/:Sub(k);break;
			case 'F'/*Find*/:Find(k);break;
		}
	}
	fout << thrownum << endl;
	return 0;
}
