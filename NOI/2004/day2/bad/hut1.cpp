#include <fstream>
#include <iostream>
#include <iomanip>
#include <cmath>

using namespace std;

const int range=100;
const int max_n=40;
const double max_num=1e+20;

double opt[range+1][max_n+1][max_n+1];
int fiopt[range+1][max_n+1][max_n+1],fkopt[range+1][max_n+1][max_n+1];
double s[range+1][range+1][max_n+1];
int fs[range+1][range+1][max_n+1];
double a,b,c,d;
double k1,k2;
int m,n;
/*
inline int MIN(int a,int b)
{
    return a<b?a:b;
}

inline int MAX(int a,int b)
{
    return a>b?a:b;
}
*/

void input_data()
{
    ifstream fin("hut.in");
    fin>>k1>>k2>>m>>n;
    fin.close();

}

double f1(int x)
{
    return k1*x;
}

double f2(int x)
{
    return k2*x;
}

double area1(int i,int j)
{
    return (j-i)*(f1(j)-f1(i));
}

double area2(int i,int j)
{
    return (j-i)*(f2(j)-f2(i));
}

void solve()
{
    int i,j,k,i1,j1,p,delta;
    double temp;
    //initialize
    for (i=0; i<=range; i++)
    {
        for (j=0; j<=range; j++)
        {
            for (k=0; k<=n; k++)
            {
                s[i][j][k]=max_num;
                fs[i][j][k]=0;
            }
        }
    }
    for (i=0; i<=range; i++)
    {
        s[i][i][0]=0;
        fs[i][i][0]=i;
    }
    for (delta=1; delta<=range; delta++)
    {
        for (i=0; i<=range-delta; i++)
        {
            j=i+delta;
            for (k=1; k<=n; k++)
            {
                for (j1=i; j1<=j; j1++)
                {
                    temp=s[i][j1][k-1]+area2(j1,j);
                    if (temp<s[i][j][k])
                    {
                        s[i][j][k]=temp;
                        fs[i][j][k]=j1;
                    }
                }
            }
        }
    }
    for (i=0; i<=range; i++)
    {
        for (j=i; j<=range; j++)
        {
            for (k=0; k<=n; k++)
            {
                s[i][j][k]+=area1(i,j);
            }
        }
    }
    //initialize
    for (i=0; i<=range; i++)
    {
        for (j=0; j<=n; j++)
        {
            for (k=0; k<=n; k++)
            {
                opt[i][j][k]=max_num;
                fiopt[i][j][k]=0; fkopt[i][j][k]=0;
            }
        }
    }
    opt[0][0][0]=0;
    for (i=1; i<=range; i++)
    {
        for (j=1; j<=n; j++)
        {
            for (k=j; k<=n; k++)
            {
                if (j>i || k>i) continue;
                for (i1=0; i1<=i-1; i1++)
                {
                    for (p=1; p<=k; p++)
                    {
                        temp=opt[i1][j-1][k-p]+s[i1][i][p];
                        if (temp<opt[i][j][k])
                        {
                            opt[i][j][k]=temp;
                            fiopt[i][j][k]=i1; fkopt[i][j][k]=k-p;
                        }
                    }
                }
            }
        }
    }
}

void print(int i,int j,int k)
{
    int backup_j;
    backup_j=j;
    while (j>i)
    {
        if (j<backup_j) cout<<j<<endl;
        j=fs[i][j][k]; k--;
    }
}

void output_data()
{
    ofstream fout("hut.out");
    fout<<setiosflags(ios::fixed)<<setprecision(1)<<opt[range][m][n]<< endl;
}

int main()
{
    input_data();
    solve();
    output_data();
    return 0;
}
