#include <fstream>
#include <iostream>
#include <iomanip>
#include <cstdlib>

using namespace std;

ifstream fin("rainfall.in");

const int max_n=10;
const double step=1e-4;
const double Zero=1e-6;

struct TBoard
{
    double x,l,v;
};
struct TSegment
{
    double x,y;
};

TBoard Board[max_n];
TSegment Segment[max_n];
int n;
double w,t,v,ans;

void input_data()
{
    int i;
    fin>>n>>w>>t>>v;
    for (i=0; i<n; i++) fin>>Board[i].x>>Board[i].l>>Board[i].v;
}

int Compare(const void *a,const void *b)
{
    if (((TSegment *)a)->x<((TSegment *)b)->x) return -1;
    else if (((TSegment *)a)->x==((TSegment *)b)->x) return 0;
    else return 1;
}

void solve()
{
    int i,j;
    double now,max,tot_len;
    ans=0;
    for (now=0; now<=t; now+=step)
    {
        for (i=0; i<n; i++)
        {
            Segment[i].x=Board[i].x;
            Segment[i].y=Board[i].x+Board[i].l;
        }
        qsort(Segment,n,sizeof(TSegment),Compare);
        tot_len=0;
        i=0;
        while (i<n)
        {
            max=Segment[i].y;
            j=i+1;
            while (j<n && Segment[j].x<=max+Zero)
            {
                if (Segment[j].y>max) max=Segment[j].y;
                j++;
            }
            tot_len+=max-Segment[i].x;
            i=j;
        }
        ans+=tot_len*step;
        for (i=0; i<n; i++)
        {
            if (Board[i].v>0 && Board[i].x+Board[i].l+Zero>=w) Board[i].v=-Board[i].v;
            if (Board[i].v<0 && Board[i].x<=Zero) Board[i].v=-Board[i].v;
            Board[i].x+=Board[i].v*step;
        }
    }
    ans=(w*t-ans)*v;
}

void output_data()
{
    cout<<setiosflags(ios::fixed)<<setprecision(2);
    cout<<ans<<endl;
}

int main()
{
    input_data();
    solve();
    output_data();
    system("pause");
    return 0;
}
