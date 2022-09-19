#include <fstream>
#include <string>

using namespace std;

ifstream fin("dune.in");
ofstream fout;

static const int MaxN = 101;
static const int MaxM = 4001;

static int n, m, nowpos, nowroad, Count, score;
static bool stone;
static bool havestone[MaxN];
static bool cave, channel;
static int g[MaxN][MaxM], h[MaxN][MaxM];
static int d[MaxN];
static bool Initialized = false, isInTest = false;

static void Error(string message)
{
	if (!isInTest) fout << message << endl;
	else fout << -1 << endl;
    exit(0);
}

void init()
{
	if (Initialized) {
		Error("You have called init() twice!");
	}
    Initialized=true;
    fin >> n;
    if (n == 0) {
    	isInTest = true;
    	fin >> n >> m;
    	fout.open("dune.out");
    }
    else fout.open("dune.log");
	if (!isInTest) fout << "init()" << endl;
    m = 0;
    int i, j, k;
    for (i = 1; i <= n; i++) {
        fin >> d[i];
        m += d[i];
        for (j = 0; j < d[i]; j++) {
            fin >> g[i][j];
        }
    }
    m /= 2;
    for (i = 1; i <= n; i++) {
        for (j = 0; j < d[i]; j++) {
            for (k = 0; k < d[g[i][j]]; k++) {
                if (g[g[i][j]][k] == i) break;
            }
            h[i][j] = k;
        }
    }
    nowpos = 1;
    nowroad = 0;
    stone = true;
    memset(havestone, 0, sizeof(havestone));
    Count = 0;
    score = 0;
    cave = channel = false;
}

void put_sign()
{
	if (!isInTest) fout << "put_sign()" << endl;
    if (!Initialized) Error("You must call init() first!");
    if (!stone) Error("Error in put_sign()!");
    stone = false;
    havestone[nowpos] = true;
}

void take_sign()
{
	if (!isInTest) fout << "take_sign()" << endl;
    if (!Initialized) Error("You must call init() first!");
    if (!havestone[nowpos]) Error("Error in take_sign()!");
    stone = true;
    havestone[nowpos] = false;
}

void walk(int k)
{
	if (!isInTest) fout << "walk(" << k << ")" << endl;
    if (!Initialized) Error("You must call init() first!");
    int nextpos = g[nowpos][(nowroad + k) % d[nowpos]];
    nowroad = h[nowpos][(nowroad + k) % d[nowpos]];
    nowpos = nextpos;
    Count++;
}

void look(int &roadnum, bool &stone)
{
	if (!isInTest) fout << "look(d, sign), returned with d=" << d[nowpos] << ", sign=" << havestone[nowpos] << endl;
    if (!Initialized) Error("You must call init() first!");
    roadnum = d[nowpos];
    stone = havestone[nowpos];
}

void report(int ncave, int nchannel)
{
	if (!isInTest) fout << "report(" << ncave << ", " << nchannel << ")" << endl;
    if (!Initialized) Error("You must call init() first!");
    if (!isInTest) {
	    if (ncave == n) fout << "The number of caves is correct!" << endl;
	    else fout << "The number of caves is NOT correct!" << endl;
	    if (nchannel == m) fout << "The number of channels is correct!" << endl;
	    else fout << "The number of channels is NOT correct!" << endl;
	    fout << "You have walked " << Count << " time(s)!" << endl;
	}
	else {
		fout << Count << endl;
		fout << ncave << ' ' << nchannel << endl;
	}
    exit(0);
}
