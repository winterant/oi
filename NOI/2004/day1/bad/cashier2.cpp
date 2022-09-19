#include <iostream>
#include <fstream>
#include <cstring>

using namespace std;

ifstream fin("cashier.in");
ofstream fout("cashier.out");

const int MAXN = 100000;

int a[MAXN];
int N, Min, thrownum, num, delta;

void Insert(int k)
{
	if (k < Min) return;
	k += delta;
	int i;
	for (i = 0; i <= num; i++) {
		if (k >= a[i] || i == num) break;
	}
	memmove(&a[i + 1], &a[i], sizeof(a[0]) * (num - i));
	a[i] = k;
	num++;
}

void Add(int k)
{
	delta -= k;
}

void Sub(int k)
{
	delta += k;
	while (num > 0 && a[num - 1] - delta < Min) {
		a[num - 1] = 0;
		num--;
		thrownum++;
	}
}

void Find(int k)
{
	if (k > num) {
		fout << -1 << endl;
		return;
	}
	fout << a[k - 1] - delta << endl;
}

int main()
{
	fin >> N >> Min;
	thrownum = 0;
	delta = 0;
	num = 0;
	int k;
	char command;
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
