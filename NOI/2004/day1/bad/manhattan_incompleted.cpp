//**********************************
//*                                *
//*            NOI 2004            *
//*         Day ? Problem ?        *
//*          manhattan.cpp         *
//*          By Wu Jingyue         *
//*                                *
//**********************************

#include <fstream>
#include <memory>

using namespace std;

ifstream fin("manhattan.in");
ofstream fout("manhattan.out");

const int maxm=10;
const int maxn=100;
const int maxk=100;
const int maxs=maxk*2;

struct TPair
{
    int x1,y1,x2,y2;
};
struct TSegment
{
    int x,y,dir,len;
};

TPair Pair[maxk];
int dirx[maxm];
int diry[maxn];
TSegment Segment[maxs];
int m,n,k,s;
bool ans;

void Input_Data()
{
    int i;
    fin>>m>>n>>k;
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

bool Check()
{
    int i,j,p,x,y,dirs,curdir;
    bool OK,coincidex1,coincidex2;
    s=0;
    for (i=0; i<k; i++)
    {
        coincidex1=(Pair[i].y2-Pair[i].y1)*dirx[Pair[i].x1]>=0;
        coincidex2=(Pair[i].y2-Pair[i].y1)*dirx[Pair[i].x2]>=0;
        if (Pair[i].x2-Pair[i].x1>0) dirs=1; else dirs=-1;
        if (coincidex1 && coincidex2)
        {
            if (Pair[i].x1!=Pair[i].x2)
            {
                Segment[s].x=MIN(Pair[i].y1,Pair[i].y2); Segment[s].y=MAX(Pair[i].y1,Pair[i].y2); Segment[s].dir=dirs;
                s++;
            }
        }
        else if (coincidex1 && !coincidex2)
        {
            Segment[s].x=Pair[i].y2; Segment[s].y=Pair[i].y2; Segment[s].dir=dirs;
            s++;
        }
        else if (!coincidex1 && coincidex2)
        {
            Segment[s].x=Pair[i].y1; Segment[s].y=Pair[i].y1; Segment[s].dir=dirs;
            s++;
        }
        else
        {
            OK=false;
            for (x=MIN(Pair[i].x1,Pair[i].x2)+1; x<MAX(Pair[i].x1,Pair[i].x2); x++)
                if ((Pair[i].y2-Pair[i].y1)*dirx[x]>=0)
                {
                    OK=true;
                    break;
                }
            if (!OK) return false;
            Segment[s].x=Pair[i].y1; Segment[s].y=Pair[i].y1; Segment[s].dir=dirs;
            s++;
            Segment[s].x=Pair[i].y2; Segment[s].y=Pair[i].y2; Segment[s].dir=dirs;
            s++;
        }
    }
    for (i=0; i<s; i++) Segment[i].len=Segment[i].y-Segment[i].x+1;
    memset(diry,0,sizeof(diry));
    for (i=0; i<s; i++)
    {
        for (j=0; j<s; j++)
            if (Segment[j].len==1) break;
        if (j==s) break;
        for (y=Segment[j].x; y<=Segment[j].y; y++)
            if (diry[y]==0) break;
        for (p=0; p<s; p++)
            if (Segment[p].x<=y && y<=Segment[p].y)
            {
                if (Segment[p].dir==Segment[j].dir) Segment[p].len=0;
                else if (Segment[p].len==1) return false;
                else Segment[p].len--;
            }
        diry[y]=Segment[j].dir;
    }
    curdir=-1;
    for (y=0; y<n; y++)
        if (diry[y]==0)
        {
            diry[y]=curdir;
            curdir=-curdir;
        }
    return true;
}

void Search(int x)
{
    if (x==m)
    {
        if (Check()) ans=true;
        return;
    }
    dirx[x]=-1; Search(x+1); if (ans) return;
    dirx[x]=1; Search(x+1);
}

void Solve()
{
    ans=false;
    Search(0);
}

void Output_Data()
{
    int x,y;
    if (!ans) fout<<"possible"<<endl;
    else
    {
        fout<<"possible"<<endl;
        for (x=0; x<m; x++)
            if (dirx[x]==1) fout<<'E'; else fout<<'W';
        fout<<endl;
        for (y=0; y<n; y++)
            if (diry[y]==1) fout<<'S'; else fout<<'N';
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
