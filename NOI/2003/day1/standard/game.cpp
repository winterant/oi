#include <fstream>
#include <memory>
using namespace std;
ifstream fin("game.in");
ofstream fout("game.out");

const int maxlen = 1000;

class CNumber
{
public:
	int length;
	int sign;
	int a[maxlen];
	CNumber()
	{
		length = 0;
		sign = 1;
		memset(a, 0, sizeof a);
	}
	void SetValue(char* str, int sn, int p, int q)
	{
		int i;
		sign = sn;
		length = q-p;
		for (i = 0; i < length; i++)
			a[i] = (int)str[q-1-i]-48;
		while (length > 0 && a[length-1] == 0) length--;
	}
	bool operator <(CNumber n)
	{
		if (length < n.length) return true;
		if (length > n.length) return false;
		int i = length-1;
		while (i >= 0 && a[i] == n.a[i]) i--;
		return (i >= 0 && a[i] < n.a[i]);
	}
	void Add(CNumber n)
	{
		int i, k;
		if (sign == n.sign)
		{
			k = 0;
			for (i = 0; i < n.length; i++)
			{
				a[i] += n.a[i] + k;
				k = a[i] / 10;
				a[i] %= 10;
			}
			i = n.length;
			while (k > 0)
			{
				a[i] += k;
				k = a[i] / 10;
				a[i] %= 10;
				i++;
			}
			if (i > length) length = i;
		}
		else
		{
			int xs = 1;
			if (*this < n) xs = -1;
			k = 0;
			for (i = 0; i < n.length; i++)
			{
				a[i] = (a[i]-n.a[i])*xs+k;
				if (a[i] < 0)
				{
					a[i] += 10; k = -1;
				}
				else k = 0;
			}
			i = n.length;
			while (k != 0)
			{
				a[i] = a[i]*xs+k;
				if (a[i] < 0)
				{
					a[i] += 10; k = -1;
				}
				else k = 0;
				i++;
			}
			if (n.length > length) length = n.length;
			while (length > 0 && a[length-1] == 0) length--;
			if (xs < 0) sign = -sign;
		}
	}
};

int nmap[10][10] = {{0}};
char str[maxlen];
int fh[maxlen];
int f1;
int dif[3][maxlen][19];

void pair2(int x, int y)
{
	nmap[x][y] = 1; nmap[y][x] = 2;
}
void pair3(int x, int y)
{
	nmap[x][y] = nmap[y][x] = 3;
}

bool check(int w1, int d1, int w2, int d2)
{
	int k;
	if (dif[0][w1][d1*f1+9] >= 0 && dif[1][w2][d2*f1+9] >= 0)
	{
		k = dif[0][w1][d1*f1+9];
		str[k] += d1*f1*fh[k];
		k = dif[1][w2][d2*f1+9];
		str[k] += d2*f1*fh[k];
		fout << str;
		return true;
	}
	if (dif[1][w1][d1*f1+9] >= 0 && dif[0][w2][d2*f1+9] >= 0)
	{
		k = dif[1][w1][d1*f1+9];
		str[k] += d1*f1*fh[k];
		k = dif[0][w2][d2*f1+9];
		str[k] += d2*f1*fh[k];
		fout << str;
		return true;
	}
	return false;
}

int main()
{
	pair2(1,7); pair2(3,9); pair2(5,6); pair2(5,9); pair2(0,8); pair2(6,8); pair2(9,8);
	pair3(0,6); pair3(0,9); pair3(6,9); pair3(2,3); pair3(3,5);
	CNumber sum, tmp;
	fin >> str;
	int i, j, f2;
	int i1, i2, k;
	memset(dif, 255, sizeof(dif));
	i = 0;
	f1 = f2 = 1;
	while (str[i] != '#')
	{
		if (str[i] >= '0' && str[i] <= '9')
		{
			j = i;
			while (str[j] >= '0' && str[j] <= '9') j++;
			for (i1 = i; i1 < j; i1++)
			{
				fh[i1] = f2;
				k = (int)str[i1]-48;
				for (i2 = 0; i2 < 10; i2++)
					if (nmap[k][i2] > 0)
						dif[nmap[k][i2]-1][j-i1-1][(i2-k)*f2+9] = i1;
			}
			tmp.SetValue(str, f2, i, j);
			sum.Add(tmp);
			i = j;
		}
		else
		{
			if (str[i] == '=')
				f2 = f1 = -f1;
			else
				if (str[i] == '+')
					f2 = f1;
				else f2 = -f1;
			i++;
		}
	}
	if (sum.length == 0) fout << "Error!" << endl;
	f1 = -sum.sign;
	i = 0;
	while (i < sum.length && sum.a[i] == 0) i++;
	if (i == sum.length - 1 && dif[2][i][sum.a[i]*f1+9] >= 0)
	{
		k = dif[2][i][sum.a[i]*f1+9];
		str[k] += sum.a[i]*f1*fh[k];
		fout << str;
		return 0;
	}
	if (i == sum.length - 1)
		for (i1 = sum.a[i]; i1 < 10; i1++)
			if (check(i, i1, i, sum.a[i]-i1)) return 0;
	if (i >= sum.length - 2 && sum.a[i] + sum.a[i+1]*10 < 19)
	{
		i1 = sum.a[i]+sum.a[i+1]*10;
		for (i2 = 0; i2 < 10; i2++)
		{
			if (i1-i2 < 0 || i1-i2 > 9) continue;
			if (check(i, i2, i, i1-i2)) return 0;
		}
	}
	if (i < sum.length - 1)
	{
		j = i+1;
		while (sum.a[j] == 0) j++;
		if (j == sum.length - 1)
			if (check(i, sum.a[i], j, sum.a[j])) return 0;
	}
	j = i+1;
	while (j < sum.length && sum.a[j] == 9) j++;
	if (check(j, sum.a[j]+1, i, sum.a[i]-10)) return 0;
	fout << "No";
	return 0;
}
