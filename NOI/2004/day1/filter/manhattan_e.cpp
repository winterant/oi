#include <fstream>
#include <iostream>
#include <string>

using namespace std;

ifstream fin;
ifstream fout;
ifstream fans;

struct TPair
{
    int x1,y1,x2,y2;
};

const int maxm=10;
const int maxn=1000;
const int maxk=1000;

TPair Pair[maxk];
int origin_dir_x[maxm],origin_dir_y[maxn],dir_x[maxm],dir_y[maxn];
int change_x[maxm],change_y[maxn];
int m,n,k,your_ans,std_ans;
bool std_impossible,your_impossible;

void result(int score)
{
    if (score==0) cout<<"Wrong Answer!"<<endl;
    else if (score==4) cout<<"Feasible but NOT Correct!"<<endl;
    else cout<<"Correct!"<<endl;
    cout<<score<<endl;
}

void Read_from_fin()
{
    int i,x,y;
    char ch;
    fin>>m>>n;
    for (x=0; x<m; x++)
    {
        fin>>ch;
        if (ch=='E') origin_dir_x[x]=1; else origin_dir_x[x]=-1;
    }
    for (y=0; y<n; y++)
    {
        fin>>ch;
        if (ch=='S') origin_dir_y[y]=1; else origin_dir_y[y]=-1;
    }
    for (x=0; x<m; x++) fin>>change_x[x];
    for (y=0; y<n; y++) fin>>change_y[y];
    fin>>k;
    for (i=0; i<k; i++)
    {
        fin>>Pair[i].x1>>Pair[i].y1>>Pair[i].x2>>Pair[i].y2;
        Pair[i].x1--; Pair[i].y1--; Pair[i].x2--; Pair[i].y2--;
    }
}

void Read_from_fout()
{
    string st;
    char ch;
    int x,y;
    if (!(fout>>st))
    {
        result(0);
        exit(0);
    }
    if (st=="impossible")
    {
        your_impossible=true;
        return;
    }
    your_impossible=false;
    if (!(fout>>your_ans))
    {
        result(0);
        exit(0);
    }
    for (x=0; x<m; x++)
    {
        if (!(fout>>ch))
        {
            result(0);
            exit(0);
        }
        if (ch=='E') dir_x[x]=1; else dir_x[x]=-1;
    }
    for (y=0; y<n; y++)
    {
        if (!(fout>>ch))
        {
            result(0);
            exit(0);
        }
        if (ch=='S') dir_y[y]=1; else dir_y[y]=-1;
    }
}

void Read_from_fans()
{
    string st;
    fans>>st;
    if (st=="impossible")
    {
        std_impossible=true;
        return;
    }
    std_impossible=false;
    fans>>std_ans;
}

int MIN(int a,int b) { return a<b?a:b; };

int MAX(int a,int b) { return a>b?a:b; };

bool Exist_x(int x1,int x2,int dy)
{
    int x;
    for (x=x1; x<=x2; x++)
        if (dir_x[x]*dy>=0) return true;
    return false;
}

bool Exist_y(int y1,int y2,int dx)
{
    int y;
    for (y=y1; y<=y2; y++)
        if (dir_y[y]*dx>=0) return true;
    return false;
}

void Check()
{
    int i,x,y,x1,y1,x2,y2,tot;
    if (your_impossible!=std_impossible)
    {
        result(0);
        return;
    }
    if (std_impossible)
    {
        result(10);
        return;
    }
    for (i=0; i<k; i++)
    {
        x1=Pair[i].x1; y1=Pair[i].y1; x2=Pair[i].x2; y2=Pair[i].y2;
        if ((y2-y1)*dir_x[x1]>=0 && (x2-x1)*dir_y[y2]>=0) continue;
        if ((x2-x1)*dir_y[y1]>=0 && (y2-y1)*dir_x[x2]>=0) continue;
        if ((y2-y1)*dir_x[x1]>=0 && (y2-y1)*dir_x[x2]>=0 && Exist_y(MIN(y1,y2)+1,MAX(y1,y2)-1,x2-x1)) continue;
        if ((x2-x1)*dir_y[y1]>=0 && (x2-x1)*dir_y[y2]>=0 && Exist_x(MIN(x1,x2)+1,MAX(x1,x2)-1,y2-y1)) continue;
        result(0);
        return;
    }
    tot=0;
    for (x=0; x<m; x++)
    {
        if (origin_dir_x[x]!=dir_x[x]) tot+=change_x[x];
    }
    for (y=0; y<n; y++)
    {
        if (origin_dir_y[y]!=dir_y[y]) tot+=change_y[y];
    }
    if (tot!=your_ans) result(0);
    else if (your_ans!=std_ans) result(4);
    else result(10);
}

int main(int argc,char *argv[])
{
    fin.open(argv[1]);
    fout.open(argv[2]);
    fans.open(argv[3]);
    if (!fout)
    {
        cout<<"Output file not found!"<<endl;
        cout<<0<<endl;
    }
    else
    {
        Read_from_fin();
        Read_from_fout();
        Read_from_fans();
        Check();
    }
    return 0;
}
