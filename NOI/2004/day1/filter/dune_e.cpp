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
		return 0;
	}
	int ansn, ansm, anscount, n, m, count;
	fin >> ansn;
	fin >> ansn >> ansm;
	fout >> count;
	if (count == -1) {
		cout << "Invalid command.\n0\n";
		return 0;
	}	
	else {
		fout >> n >> m;
		int score = 0;
		if (ansn == n && ansm == m) {
			cout << "The number of caves and channels are correct!\n";
			fans >> anscount;
			if (count < anscount) count = anscount;
			score = 5 + int((double)anscount / count * 5 + 0.5);
			cout << score << endl;
		}
		else {
			if (ansn == n) cout << "The number of caves is correct. The number of channels is NOT correct.\n3\n";
			if (ansm == m) cout << "The number of caves is NOT coorect. The number of channels is correct.\n3\n";
			if (ansn != n && ansm != m) cout << "The number of caves and channels are NOT correct.\n0\n";
		}
	}
	return 0;
}
