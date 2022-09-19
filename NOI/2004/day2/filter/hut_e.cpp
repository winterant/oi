#include <iostream>
#include <fstream>
#include <cmath>
using namespace std;

int main(int argc, char * argv[])
{
	ifstream fout(argv[2]);
	ifstream fans(argv[3]);
	
	double ans1, ans2;
	char ch;
	const double zero = 1e-6;
	
	if(!fout){
		cout << "Output file not found!\n0\n";
	}else{
		if (!(fout >> ans1)) ans1 = -1;
		fans >> ans2;
		if (fabs(ans1 - ans2) < zero && !(fout >> ch))
			cout << "Correct!\n10\n";
		else
			cout << "Wrong Answer!\n0\n";
	}
    return 0;
}
