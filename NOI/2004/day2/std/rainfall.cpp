//*************************************
//*                                   *
//*           NOI 2004                *
//*        Day ? Problem ?            *
//*         rainfall.cpp              *
//*         by Wu Jingyue             *
//*                                   *
//*************************************

#include <fstream>
#include <cstdlib>
#include <cmath>
#include <iomanip>

using namespace std;

struct TBoard
{
    double x,l,v;
};
struct TSegment
{
    double x1,y1,x2,y2;
    int uorl,order;
};
struct TInterval
{
    double x,y;
};

const int maxn=10;
const int maxm=500;
const int maxk=250000;
const double Zero=1e-6;

ifstream fin("rainfall.in");
ofstream fout("rainfall.out");

TBoard Board[maxn]; int n;
TSegment Segment[maxm]; int m;
double Time[maxk]; int k;
TInterval Interval[maxm]; int r;
double w,t,v,ans;

void Input_Data()
{
    int i;
    fin>>n>>w>>t>>v;
    for (i=0; i<n; i++) fin>>Board[i].x>>Board[i].l>>Board[i].v;
    fin.close();
}

double Multi(double x1,double y1,double x2,double y2)
{
    return x1*y2-x2*y1;
}

double MAX(double a,double b)
{
    if (a>b) return a; else return b;
}

double MIN(double a,double b)
{
    if (a<b) return a; else return b;
}

bool Intersect(TSegment a,TSegment b)
{
    if (MAX(a.x1,a.x2)<MIN(b.x1,b.x2)-Zero || MAX(b.x1,b.x2)<MIN(a.x1,a.x2)-Zero ||
        MAX(a.y1,a.y2)<MIN(b.y1,b.y2)-Zero || MAX(b.y1,b.y2)<MIN(a.y1,a.y2)-Zero) return false;
    return Multi(b.x1-a.x1,b.y1-a.y1,a.x2-a.x1,a.y2-a.y1)*Multi(b.x2-a.x1,b.y2-a.y1,a.x2-a.x1,a.y2-a.y1)<=Zero
        && Multi(a.x1-b.x1,a.y1-b.y1,b.x2-b.x1,b.y2-b.y1)*Multi(a.x2-b.x1,a.y2-b.y1,b.x2-b.x1,b.y2-b.y1)<=Zero;
}

double GetIntersection(TSegment s1,TSegment s2)
{
    double a1,b1,c1,a2,b2,c2;
    a1=s1.y1-s1.y2; b1=s1.x2-s1.x1; c1=s1.x1*s1.y2-s1.x2*s1.y1;
    a2=s2.y1-s2.y2; b2=s2.x2-s2.x1; c2=s2.x1*s2.y2-s2.x2*s2.y1;
    return (b1*c2-b2*c1)/(a1*b2-a2*b1);
}

int CompareDouble(const void *a,const void *b)
{
    if (*(double *)a<*(double *)b) return -1;
    else if (*(double *)a==*(double *)b) return 0;
    else return 1;
}

int CompareInterval(const void *a,const void *b)
{
    if (((TInterval *)a)->x<((TInterval *)b)->x) return -1;
    else if (((TInterval *)a)->x==((TInterval *)b)->x) return 0;
    else return 1;
}

double GetLen(double x)
{
    double ans,max;
    int i,j;
    r=0;
    for (i=0; i<m; i++)
        if (Segment[i].uorl==0 && Segment[i].x1<=x+Zero && x<=Segment[i].x2+Zero)
        {
            Interval[r].x=((Segment[i].y1-Segment[i].y2)*x+Segment[i].x1*Segment[i].y2-Segment[i].x2*Segment[i].y1)/(Segment[i].x1-Segment[i].x2);
            Interval[r].y=Interval[r].x+Board[Segment[i].order].l;
            r++;
        }
    qsort(Interval,r,sizeof(TInterval),CompareInterval);
    ans=0;
    i=0;
    while (i<r)
    {
        max=Interval[i].y;
        j=i+1;
        while (j<r && Interval[j].x<=max+Zero)
        {
            if (Interval[j].y>max) max=Interval[j].y;
            j++;
        }
        ans+=(max-Interval[i].x);
        i=j;
    }
    return ans;
}

void Solve()
{
    int i,j;
    double curx,curv,curt,it,l,l1;
    m=0;
    for (i=0; i<n; i++)
    {
        curx=Board[i].x; curv=Board[i].v; curt=0;
        if (Board[i].l==w) curv=0;
        if (curv==0)
        {
            Segment[m].x1=0; Segment[m].x2=t; Segment[m].y1=curx; Segment[m].y2=curx;
            Segment[m].order=i; Segment[m].uorl=0; m++;
            Segment[m].x1=0; Segment[m].x2=t; Segment[m].y1=curx+Board[i].l; Segment[m].y2=curx+Board[i].l;
            Segment[m].order=i; Segment[m].uorl=1; m++;
            continue;
        }
        while (curt<t)
        {
            Segment[m].x1=curt; Segment[m].y1=curx;
            if (curv>0)
            {
                curt+=(w-Board[i].l-curx)/fabs(curv);
                curx=w-Board[i].l;
            }
            else
            {
                curt+=curx/fabs(curv);
                curx=0;
            }
            Segment[m].x2=curt; Segment[m].y2=curx;
            Segment[m].uorl=0; Segment[m].order=i;
            if (Segment[m].x1<Segment[m].x2-Zero)
            {
                m++;
                Segment[m].x1=Segment[m-1].x1; Segment[m].y1=Segment[m-1].y1+Board[i].l;
                Segment[m].x2=Segment[m-1].x2; Segment[m].y2=Segment[m-1].y2+Board[i].l;
                Segment[m].uorl=1; Segment[m].order=i;
                m++;
            }
            curv=-curv;
        }
    }
//    fout<<"NSegment="<<m<<endl;
    /*
    for (i=0; i<m; i++)
    {
        Time[k]=Segment[i].x1; k++;
        Time[k]=Segment[i].x2; k++;
    }
    */
    k=0;
    Time[k]=0; k++;
    for (i=0; i<m; i++)
        for (j=i+1; j<m; j++)
            if (Intersect(Segment[i],Segment[j]))
            {
                it=GetIntersection(Segment[i],Segment[j]);
                if (it>Zero && it<t-Zero)
                {
                    Time[k]=it;
                    k++;
                }
            }
    Time[k]=t; k++;
//    fout<<"NTime="<<k<<endl;
    qsort(Time,k,sizeof(double),CompareDouble);
    j=0;
    for (i=0; i<k; i++)
        if (i==k-1 || Time[i]<Time[i+1]-Zero)
        {
            Time[j]=Time[i];
            j++;
        }
    k=j;
    ans=v*w*t;
    l=GetLen(Time[0]);
    for (i=0; i<k-1; i++)
    {
        l1=GetLen(Time[i+1]);
        ans-=v*(l+l1)/2*(Time[i+1]-Time[i]);
        l=l1;
    }
}

void Output_Data()
{
    fout<<setiosflags(ios::fixed)<<setprecision(2)<<ans+Zero<<endl;
    fout.close();
}

int main()
{
    Input_Data();
    Solve();
    Output_Data();
    return 0;
}

