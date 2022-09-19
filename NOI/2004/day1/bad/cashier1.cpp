#include <iostream>
#include <fstream>
#include <cstdlib>

using namespace std;

ifstream fin("cashier.in");
ofstream fout("cashier.out");

int a[100000];
int N, Min, thrownum, num;

int compare(const void *e1, const void *e2)
{
	return *(const int *)e2 - *(const int *)e1;
}

void find_nth(int r, int p, int n)
{
	int i = r, j = p;
	int t;
	int k = a[rand() % (p - r + 1) + r];
	while (1) {
		while (a[i] > k) i++;
		while (a[j] < k) j--;
		if (i < j) {
			t = a[i];
			a[i] = a[j];
			a[j] = t;		
			i++;
			j--;
		}
		else break;
	}
	if (r < j && n - 1 <= j) find_nth(r, j, n);
	if (j + 1 < p && j + 1 <= n - 1) find_nth(j + 1, p, n);
}

void Insert(int k)
{
	if (k < Min) return;
	a[num++] = k;
}

void Add(int k)
{
	for (int i = 0; i < num; i++)
		a[i] += k;
}

void Sub(int k)
{
	for (int i = 0; i < num; i++) {
		a[i] -= k;
	}
	qsort(a, num, sizeof(a[0]), compare);
	while (num > 0 && a[num - 1] < Min) {
		a[--num] = 0;
		thrownum++;
	}
}

void Find(int k)
{
	if (k > num) {
		fout << -1 << endl;
		return;
	}
	find_nth(0, num - 1, k);
	fout << a[k - 1] << endl;
}

int main()
{
	fin >> N >> Min;
	thrownum = 0;
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
