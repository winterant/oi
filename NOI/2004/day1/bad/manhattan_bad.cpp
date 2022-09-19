#include <fstream>

using namespace std;

struct TPair
{
    int x1,y1,x2,y2;
};

const int maxm=10;
const int maxn=60;
const int maxk=100;
const int maxlongint=2147483647;

TPair Pair[maxk];
int origin_dir_x[maxm],origin_dir_y[maxn],dir_x[maxm],dir_y[maxn],ans_dir_x[maxm],ans_dir_y[maxn];
int change_x[maxm],change_y[maxn];
int m,n,k,ans;

void Input_Data()
{
    int i,x,y;
    char ch;
    ifstream fin("manhattan.in");
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
    fin.close();
}

int MIN(int a,int b)
{
    if (a<b) return a; else return b;
}

int MAX(int a,int b)
{
    if (a>b) return a; else return b;
}

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

bool Check()
{
    int i,x1,y1,x2,y2;
    for (i=0; i<k; i++)
    {
        x1=Pair[i].x1; y1=Pair[i].y1; x2=Pair[i].x2; y2=Pair[i].y2;
        if ((y2-y1)*dir_x[x1]>=0 && (x2-x1)*dir_y[y2]>=0) continue;
        if ((x2-x1)*dir_y[y1]>=0 && (y2-y1)*dir_x[x2]>=0) continue;
        if ((y2-y1)*dir_x[x1]>=0 && (y2-y1)*dir_x[x2]>=0 && Exist_y(MIN(y1,y2)+1,MAX(y1,y2)-1,x2-x1)) continue;
        if ((x2-x1)*dir_y[y1]>=0 && (x2-x1)*dir_y[y2]>=0 && Exist_x(MIN(x1,x2)+1,MAX(x1,x2)-1,y2-y1)) continue;
        return false;
    }
    return true;
}

void Search_y(int y,int cost)
{
    if (y==n)
    {
        if (Check() && cost<ans)
        {
            ans=cost;
            memcpy(ans_dir_x,dir_x,sizeof(dir_x));
            memcpy(ans_dir_y,dir_y,sizeof(dir_y));
        }
        return;
    }
    dir_y[y]=1;
    if (origin_dir_y[y]==1) Search_y(y+1,cost); else Search_y(y+1,cost+change_y[y]);
    dir_y[y]=-1;
    if (origin_dir_y[y]==-1) Search_y(y+1,cost); else Search_y(y+1,cost+change_y[y]);
}

void Search_x(int x,int cost)
{
    if (x==m)
    {
        Search_y(0,cost);
        return;
    }
    dir_x[x]=1;
    if (origin_dir_x[x]==1) Search_x(x+1,cost); else Search_x(x+1,cost+change_x[x]);
    dir_x[x]=-1;
    if (origin_dir_x[x]==-1) Search_x(x+1,cost); else Search_x(x+1,cost+change_x[x]);
}

void Solve()
{
    ans=maxlongint;
    Search_x(0,0);
}

void Output_Data()
{
    int x,y;
    ofstream fout("manhattan.out");
    if (ans==maxlongint) fout<<"impossible"<<endl;
    else
    {
        fout<<"possible"<<endl;
        fout<<ans<<endl;
        for (x=0; x<m; x++)
        {
            if (ans_dir_x[x]==1) fout<<'E'; else fout<<'W';
        }
        fout<<endl;
        for (y=0; y<n; y++)
        {
            if (ans_dir_y[y]==1) fout<<'S'; else fout<<'N';
        }
        fout<<endl;
    }
    fout.close();
}

int main()
{
    Input_Data();
    Solve();
    Output_Data();
    return 0;
}
