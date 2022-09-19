#include <iostream>
#include <fstream>
using namespace std;

int main(int argc, char *argv[])
{
	ifstream fin(argv[1]);
	ifstream fout(argv[2]);
	ifstream fans(argv[3]);
	if (!fout) {
		cout << "Output file not found!\n0\n";
	}
	else {
		int n, tmp, i;
		char ch;
		fin >> n >> tmp;
		int asknum = 0;
		for (i = 0; i < n; i++) {
			fin >> ch >> tmp;
			if (ch == 'F') asknum++;
		}
		bool check = true;
		int ans1, ans2;
		for (i = 0; i < asknum; i++) {
			if (fout.eof()) {
				cout << "Wrong Answer!\n0\n";
				return 0;
			}
			fout >> ans1;
			fans >> ans2;
			if (ans1 != ans2) {
				check = false;
			}
		}
		fans >> ans2;
		if (fout >> ans1) {
			if (ans1 == ans2) {
				if (check)
					cout << "Correct!\n10\n";
				else
					cout << "Only the second part is correct!\n4\n";
			}
			else {
				if (check)
					cout << "Only the first part is correct!\n6\n";
				else
					cout << "Wrong Answer!0\n";
			}
		}
		else {
			if (check)
				cout << "Only the first part is correct!\n6\n";
			else
				cout << "Wrong Answer!\n0\n";
		}
	}
	return 0;
}
