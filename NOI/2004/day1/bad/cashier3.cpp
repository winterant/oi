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
	Node *left, *right;
};

const int LimitN = 100000;
const int LimitM = 100;
const int LimitL = 100000;
const int LimitAddValue = 1000;
const int LimitValue = 100000;
const int LimitTree = LimitValue * 10;
const int LimitAdd = LimitAddValue * LimitM;

Node *root;
int N, Min, k;
int delta;
int thrownum;
char command;

void Insert_tree(int x)
{
	if (root == 0) {
		root = new Node;
		root->value = x;
		root->num = 1;
		root->nodenum = 1;
		root->right = 0;
		root->left = 0;
		return;
	}
	Node *now = root;
	Node *last;
	while (now != 0 && now->value != x) {
		last = now;
		now->nodenum++;
		if (now->value > x) now = now->left;
		else now = now->right;
	}
	if (now == 0) {
		now = new Node;
		now->value = x;
		now->num = 1;
		now->nodenum = 1;
		now->right = 0;
		now->left = 0;
		if (last->value > x) last->left = now;
		else last->right = now;
	}
	else {
		now->num++;
		now->nodenum++;
	}
}

void Update_tree(Node *now)
{
	if (now->nodenum == 0) {
		now == 0;
		return;
	}
	if (now->left != 0) Update_tree(now->left);
	if (now->value + 1 < Min - delta && now->right != 0) Update_tree(now->right);
	if (now->value < Min - delta) {
		thrownum += now->num;
		now->num = 0;
	}
	now->nodenum = now->left->nodenum + now->num + now->right->nodenum;
	if (now->nodenum == 0) {
		now == 0;
		return;
	}
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
	if (root != 0) Update_tree(root);
}

void Find(int k)
{
	Node *now = root;
	if (now == 0 || k > now->nodenum) {
		fout << -1 << endl;
		return;
	}
	k = now->nodenum + 1 - k;
	while (k > 0) {
		if (now->left != 0 && k <= now->left->nodenum) {
			now = now->left;
			continue;
		}
		else {
			if (now->left != 0) k -= now->left->nodenum;
			if (k <= now->num) break;
		}
		k -= now->num;
		now = now->right;
	}
	fout << now->value + delta << endl;
}

int main()
{	
	fin >> N >> Min;
	delta = 0;
	thrownum = 0;
	root = 0;
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
