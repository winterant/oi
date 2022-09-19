#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>

using namespace std;

ifstream fin("manhattan.in");
ofstream fout("manhattan.out");

struct elem {
    int x1, x2;
};

const int MAXM = 11;
const int MAXN = 101;
const int MAXK = 101;
const int INFI = 100000000;
const int max_Count =1000000;
int min(int a, int b) { return a>b ? b : a; }
int max(int a, int b) { return a>b ? a : b; }

int m, n, k;
int original_street[MAXM], original_road[MAXN];
int street[MAXM], road[MAXN];
int street_cost[MAXM], road_cost[MAXN];
int ans_street[MAXM], ans_road[MAXN];
int xx1[MAXK], xx2[MAXK], yy1[MAXK], yy2[MAXK];
elem f[2][MAXK];
int num[2];
int ans, now;
int Count;

void Read_data()
{
    fin >> m >> n;
    int i;
    char ch;
    for (i = 0; i < m; i++) {
        fin >> ch;
        original_street[i] = (ch == 'E');
    }
    for (i = 0; i < n; i++) {
        fin >> ch;
        original_road[i] = (ch == 'S');
    }
    for (i = 0; i < m; i++) fin >> street_cost[i];
    for (i = 0; i < n; i++) fin >> road_cost[i];
    fin >> k;
    for (i = 0; i < k; i++) {
        fin >> xx1[i] >> yy1[i] >> xx2[i] >> yy2[i];
        xx1[i]--; yy1[i]--; xx2[i]--; yy2[i]--;
    }
}

int compare(const void *e1, const void *e2)
{
    if (((const elem *)e1)->x1 != ((const elem *)e2)->x1)
        return ((const elem *)e1)->x1 - ((const elem *)e2)->x1;
    return ((const elem *)e1)->x2 - ((const elem *)e2)->x2;
}

void print_ans()
{
    int i;
    if (ans == INFI) {
        fout << "impossible" << endl;
    }
    else {
        fout << "possible" << endl;
        fout << ans << endl;
        for (i = 0; i < m; i++) {
            if (ans_street[i] == 0) fout << 'W';
            else fout << 'E';
        }
        fout << endl;
        for (i = 0; i < n; i++) {
            if (ans_road[i] == 0) fout << 'N';
            else fout << 'S';
        }
        fout << endl;
    }
}

void search(int k, int p0, int p1)
{
    Count++;
    if (Count>max_Count)
    {
        print_ans();
        exit(0);
    }
    if (k >= n) {
        if (p0 == num[0] + 1 && p1 == num[1] + 1 && now < ans) {
            ans = now;
//****************************************************
//            cout << "I have got one of them." <<endl;
//****************************************************
            memmove(ans_street, street,sizeof(street));
            memmove(ans_road, road, sizeof(road));
        }
        return;
    }
    if (p0 <= num[0] && k > f[0][p0].x2) return;
    if (p1 <= num[1] && k > f[1][p1].x2) return;
    if (now >= ans) return;
    int last = now;
    if (road[k] != -1) {
        now += (road[k] != original_road[k]) * road_cost[k];
        if (road[k] == 0) while (p0 <= num[0] && f[0][p0].x1 <= k && k <= f[0][p0].x2) p0++;
        else while (p1 <= num[1] && f[1][p1].x1 <= k && k <= f[1][p1].x2) p1++;
        search(k + 1, p0, p1);
        now = last;
        return;
    }
    road[k] = 0;
    int pp0 = p0;
    while (pp0 <= num[0] && f[0][pp0].x1 <= k && k <= f[0][pp0].x2) pp0++;
    now += (road[k] != original_road[k]) * road_cost[k];
    search(k + 1, pp0, p1);
    now = last;
    road[k] = 1;
    int pp1 = p1;
    while (pp1 <= num[1] && f[1][pp1].x1 <= k && k <= f[1][pp1].x2) pp1++;
    now += (road[k] != original_road[k]) * road_cost[k];
    search(k + 1, p0, pp1);
    now = last;
    road[k] = -1;
}

int main()
{
    Read_data();
    ans = INFI;
    int street_value, dir, i, j;
    bool valid;
    for (street_value = 0; street_value < (1 << m); street_value++) {
        now = 0;
        for (i = 0; i < m; i++) {
            street[i] = (street_value >> i) & 1;
            now += (street[i] != original_street[i]) * street_cost[i];
        }
        memset(road, 0xff, sizeof(road));
        memset(num, 0, sizeof(num));
        valid = true;
        for (i = 0; i < k; i++) {
            if (yy1[i] == yy2[i]) {
                if (xx1[i] == xx2[i]) continue;
                if (road[yy1[i]] != -1 && road[yy1[i]] != (xx2[i] > xx1[i])) {
                    valid = false;
                    break;
                }
                road[yy1[i]] = (xx2[i] > xx1[i]);
                continue;
            }
            if (xx1[i] == xx2[i]) {
                if (street[xx1[i]] != (yy2[i] > yy1[i])) {
                    valid = false;
                    break;
                }
                else continue;
            }
            if (street[xx1[i]] == street[xx2[i]]) {
                if (street[xx1[i]] == (yy2[i] > yy1[i])) {
                    dir = (xx2[i] > xx1[i]);
                    num[dir]++;
                    f[dir][num[dir]].x1 = min(yy1[i], yy2[i]);
                    f[dir][num[dir]].x2 = max(yy1[i], yy2[i]);
                }
                else {
                    valid = false;
                    for (j = min(xx1[i], xx2[i]) + 1; j < max(xx1[i], xx2[i]); j++) {
                        if (street[j] == (yy2[i] > yy1[i])) {
                            valid = true;
                            break;
                        }
                    }
                    if (!valid) break;
                    if (road[yy1[i]] != -1 && road[yy1[i]] != (xx2[i] > xx1[i])) {
                        valid = false;
                        break;
                    }
                    if (road[yy2[i]] != -1 && road[yy2[i]] != (xx2[i] > xx1[i])) {
                        valid = false;
                        break;
                    }
                    road[yy1[i]] = road[yy2[i]] = (xx2[i] > xx1[i]);
                }
            }
            else {
                if (street[xx1[i]] == (yy2[i] > yy1[i])) {
                    if (road[yy2[i]] != -1 && road[yy2[i]] != (xx2[i] > xx1[i])) {
                        valid = false;
                        break;
                    }
                    road[yy2[i]] = (xx2[i] > xx1[i]);
                }
                else {
                    if (road[yy1[i]] != -1 && road[yy1[i]] != (xx2[i] > xx1[i])) {
                        valid = false;
                        break;
                    }
                    road[yy1[i]] = (xx2[i] > xx1[i]);
                }
            }
        }
        if (!valid) continue;
        qsort(f[0] + 1, num[0], sizeof(f[0][0]), compare);
        qsort(f[1] + 1, num[1], sizeof(f[1][0]), compare);
        search(0, 1, 1);
    }
    
    print_ans();
    return 0;
}
