//Generator for Problem Graduate

#include <fstream>
#include <iomanip>
#include <cstdlib>
#include <memory>
#include <ctime>

// 6: 80*20, 4 pieces
// 7: 100*100, 50 pieces

using namespace std;

ofstream fout("graduate7.txt");

const int dx[4]={-1,0,1,0};
const int dy[4]={0,1,0,-1};

const int size_v=100;
const int size_h=100;
const int n_piece=50;
const int n_square=10000;
const int n_best=1;
int grow_factor[n_piece];

struct TPiece
{
    int x,y;
    TPiece *next;
};
struct TVicinity
{
    int x,y,cost;
};

int color[size_v][size_h];
TPiece *piece[n_piece];
TVicinity vicinity[size_v*size_h];
int n_vicinity;
bool in_vicinity[size_v][size_h];

void set_grow_factor()
{
    int i;
    for (i=0; i<n_piece; i++) grow_factor[i]=1;
}

inline int MIN(int a,int b) { return a<b?a:b; };

void insert(int i,int x,int y)
{
    TPiece *d;
    
    d=new TPiece; d->x=x; d->y=y;
    d->next=piece[i]; piece[i]=d;
}

bool outside(int x,int y)
{
    return x<0 || x>=size_v || y<0 || y>=size_h;
}

int compute_1_cost(int x,int y,int i)
{
    int dir,ans,x1,y1;
    
    ans=0;
    for (dir=0; dir<4; dir++)
    {
        x1=x+dx[dir]; y1=y+dy[dir];
        if (!outside(x1,y1) && color[x1][y1]==i) ans++;
    }
    
    return ans;
}

int compute_2_cost(int x,int y,int i)
{
    int ans,temp;
    TPiece *p;
    
    ans=0;
    for (p=piece[i]; p!=0; p=p->next)
    {
        temp=abs(x-p->x)+abs(y-p->y);
        if (temp>ans) ans=temp;
    }
    
    return ans;
}

int compare_less(const void *a,const void *b)
{
    return *(int *)a-*(int *)b;
}

int compare_greater(const void *a,const void *b)
{
    return *(int *)b-*(int *)a;
}

bool grow(int u)
{
    TPiece *p;
    int x,y,x1,y1,dir,i,r;
    
    n_vicinity=0;
    memset(in_vicinity,0,sizeof(in_vicinity));
    for (p=piece[u]; p!=0; p=p->next)
    {
        x=p->x; y=p->y;
        for (dir=0; dir<4; dir++)
        {
            x1=x+dx[dir]; y1=y+dy[dir];
            if (!outside(x1,y1) && color[x1][y1]==-1 && !in_vicinity[x1][y1])
            {
                vicinity[n_vicinity].x=x1; vicinity[n_vicinity].y=y1;
                n_vicinity++;
                in_vicinity[x1][y1]=true;
            }
        }
    }
    
    if (n_vicinity==0) return false;
    
    for (i=0; i<n_vicinity; i++)
    {
        vicinity[i].cost=compute_2_cost(vicinity[i].x,vicinity[i].y,u);
    }
    
    qsort(vicinity,n_vicinity,sizeof(TVicinity),compare_greater);
    
    r=rand()%MIN(n_vicinity,n_best);
    x=vicinity[r].x; y=vicinity[r].y;
    color[x][y]=u;
    insert(u,x,y);
    
    return true;
}

int main()
{
    int x,y,i,j,r,sum_grow_factor,Time;
    bool succeed;
    
    set_grow_factor();

//    srand(time(0));
    for (x=0; x<size_v; x++)
    {
        for (y=0; y<size_h; y++)
        {
            color[x][y]=-1;
        }
    }
    
    memset(piece,0,sizeof(piece));
    for (i=0; i<n_piece; i++)
    {
        do
        {
            x=rand()%size_v; y=rand()%size_h;
        }
        while (color[x][y]!=-1);
        color[x][y]=i;
        insert(i,x,y);
    }
    
    sum_grow_factor=0;
    for (i=0; i<n_piece; i++) sum_grow_factor+=grow_factor[i];
    
    for (Time=0; Time<n_square-n_piece; Time++)
    {
        r=rand()%sum_grow_factor;
        for (i=0; i<n_piece; i++)
        {
            if (r<grow_factor[i]) break;
            r-=grow_factor[i];
        }
        succeed=false;
        for (j=i; j<n_piece; j++)
        {
            if (grow(j))
            {
                succeed=true;
                break;
            }
        }
        if (!succeed)
        {
            for (j=i-1; j>=0; j--)
            {
                if (grow(j)) break;
            }
        }
    }
    
	fout << size_v << " " << size_h << endl;
    for (x=0; x<size_v; x++)
    {
        for (y=0; y<size_h; y++) fout<<(char)(color[x][y]+'A');
        fout<<endl;
    }
    
    return 0;
}
