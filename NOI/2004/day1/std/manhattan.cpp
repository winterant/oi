#include <fstream>
#include <memory>

using namespace std;

const int max_m=20;
const int max_n=150;
const int max_k=150;
const int max_s=max_k*2;
const int maxlongint=2147483647;

struct TRequire
{
  int x1,y1,x2,y2;
};
struct TSegment
{
  int x,y;
};
typedef TSegment TArraySegment[max_s];
typedef int TArrayInt[max_n];

TRequire require[max_k];
TArraySegment usegment,dsegment;
TArrayInt ulast,dlast;
int origin_dir_x[max_m],origin_dir_y[max_n],dir_x[max_m],change_x[max_m],change_y[max_n];
int c[max_n+1][max_n+1][max_n+1];
char f[max_n+1][max_n+1][max_n+1];
int m,n,k,nu,nd;
int ans,ans_dir_x[max_m],ans_dir_y[max_n];

ifstream fin("manhattan.in");
ofstream fout("manhattan.out");

void input_data()
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
    fin>>require[i].x1>>require[i].y1>>require[i].x2>>require[i].y2;
    require[i].x1--; require[i].y1--; require[i].x2--; require[i].y2--;
  }
  fin.close();
}

inline int MIN(int a,int b) { return a<b?a:b; }

inline int MAX(int a,int b) { return a>b?a:b; }

void insert(int x,int y,int dir)
{
  if (dir==1)
  {
    usegment[nu].x=x; usegment[nu].y=y;
    nu++;
  }
  else if (dir==-1)
  {
    dsegment[nd].x=x; dsegment[nd].y=y;
    nd++;
  }
}

bool generate_segment()
{
  int i,x1,y1,x2,y2,x,dir_s;
  bool coincide_x1,coincide_x2,found;
  nu=0; nd=0;
  for (i=0; i<k; i++)
  {
    x1=require[i].x1; y1=require[i].y1; x2=require[i].x2; y2=require[i].y2;
    if (x1<x2) dir_s=1;
    else if (x1==x2) dir_s=0;
    else dir_s=-1;
    coincide_x1=(y2-y1)*dir_x[x1]>=0;
    coincide_x2=(y2-y1)*dir_x[x2]>=0;
    if (coincide_x1 && coincide_x2) insert(MIN(y1,y2),MAX(y1,y2),dir_s);
    else if (coincide_x1 && !coincide_x2) insert(y2,y2,dir_s);
    else if (!coincide_x1 && coincide_x2) insert(y1,y1,dir_s);
    else
    {
      found=false;
      for (x=MIN(x1,x2)+1; x<MAX(x1,x2); x++)
        if ((y2-y1)*dir_x[x]>=0)
        {
          found=true;
          break;
        }
      if (!found) return false;
      insert(y1,y1,dir_s);
      insert(y2,y2,dir_s);
    }
  }
  return true;
}

void simplify(TArraySegment& segment,int& s)
{
  bool remove[max_s];
  int i,j;
  for (i=0; i<s; i++)
  {
    remove[i]=false;
    for (j=0; j<s; j++)
      if (segment[i].x<=segment[j].x && segment[i].y>=segment[j].y &&
      (segment[i].y-segment[i].x!=segment[j].y-segment[j].x || j<i))
      {
        remove[i]=true;
        break;
      }
  }
  j=0;
  for (i=0; i<s; i++)
    if (!remove[i])
    {
      segment[j]=segment[i];
      j++;
    }
  s=j;
}

int Compare(const void *a,const void *b)
{
  return ((TSegment *)a)->x-((TSegment *)b)->x;
}

void get_last(TArraySegment& segment,int s,TArrayInt& last)
{
  int j,y;
  j=0;
  for (y=0; y<n; y++)
  {
    while (j<s && segment[j].x<=y) j++;
    last[y]=j-1;
  }
}
  
void dynamic_programming(int already)
{
  int y,ju,jd,ju1,jd1,temp;
  simplify(usegment,nu); qsort(usegment,nu,sizeof(TSegment),Compare); get_last(usegment,nu,ulast);
  simplify(dsegment,nd); qsort(dsegment,nd,sizeof(TSegment),Compare); get_last(dsegment,nd,dlast);
  for (y=0; y<=n; y++)
  {
    for (ju=0; ju<=nu; ju++)
    {
      for (jd=0; jd<=nd; jd++)
      {
        c[y][ju][jd]=maxlongint;
      }
    }
  }
  c[n][nu][nd]=0;
  for (y=n-1; y>=0; y--)
    for (ju=0; ju<=nu; ju++)
      for (jd=0; jd<=nd; jd++)
      {
        c[y][ju][jd]=maxlongint;
        if (ju<nu && usegment[ju].y<y || jd<nd && dsegment[jd].y<y) continue;
        ju1=ulast[y]+1; if (ju1>nu) ju1=nu;
        if (c[y+1][ju1][jd]<maxlongint)
        {
          temp=c[y+1][ju1][jd]; if (origin_dir_y[y]==-1) temp+=change_y[y];
          if (temp<c[y][ju][jd])
          {
            c[y][ju][jd]=temp;
            f[y][ju][jd]=1;
          }
        }
        jd1=dlast[y]+1; if (jd1>nd) jd1=nd;
        if (c[y+1][ju][jd1]<maxlongint)
        {
          temp=c[y+1][ju][jd1]; if (origin_dir_y[y]==1) temp+=change_y[y];
          if (temp<c[y][ju][jd])
          {
            c[y][ju][jd]=temp;
            f[y][ju][jd]=-1;
          }
        }
      }
  if (c[0][0][0]<maxlongint && already+c[0][0][0]<ans)
  {
    ans=already+c[0][0][0];
    memcpy(ans_dir_x,dir_x,sizeof(dir_x));
    y=0; ju=0; jd=0;
    while (y<n)
    {
      ans_dir_y[y]=f[y][ju][jd];
      if (f[y][ju][jd]==1)
      {
        ju=ulast[y]+1;
        if (ju>nu) ju=nu;
      }
      else
      {
        jd=dlast[y]+1;
        if (jd>nd) jd=nd;
      }
      y++;
    }
  }
}

void search(int x,int cost)
{
  if (x==m)
  {
    if (generate_segment())
      dynamic_programming(cost);
    return;
  }
  dir_x[x]=1;
  if (origin_dir_x[x]==1) search(x+1,cost); else search(x+1,cost+change_x[x]);
  dir_x[x]=-1;
  if (origin_dir_x[x]==-1) search(x+1,cost); else search(x+1,cost+change_x[x]);
}

void solve()
{
  ans=maxlongint;
  search(0,0);
}

void output_data()
{
  int x,y;
  if (ans==maxlongint) fout<<"impossible"<<endl;
  else
  {
    fout<<"possible"<<endl;
    fout<<ans<<endl;
    for (x=0; x<m; x++)
      if (ans_dir_x[x]==1) fout<<'E'; else fout<<'W';
    fout<<endl;
    for (y=0; y<n; y++)
      if (ans_dir_y[y]==1) fout<<'S'; else fout<<'N';
    fout<<endl;
  }
  fout.close();
}

int main()
{
  input_data();
  solve();
  output_data();
  return 0;
}

