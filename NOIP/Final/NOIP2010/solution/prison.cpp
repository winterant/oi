#include <iostream>
#include <fstream>

using namespace std;
struct edge{
	int v,w;
	edge *next;
};const int maxn=20000,maxm=100000;
int n,m,ans;
edge *g[maxn+1];
int a[maxm+1];
int q[maxm*10];
int color[maxn+1];

void add(int u,int v,int w)
{
	edge* p;
	p=new edge;
	p->v=v;p->w=w;p->next=g[u];
	g[u]=p;
}

void qsort(int l,int r)
{
	int i,j,k,tmp;
	i=l;j=r;k=a[(i+j)/2];
	while(i<=j){
		while(a[i]<k) i++;
		while(a[j]>k) j--;
		if(i<=j){
			tmp=a[i];a[i]=a[j];a[j]=tmp;
			i++;j--;
		}
	}
	if(i<r) qsort(i,r);
	if(j>l) qsort(l,j);
}

void init()
{
	ifstream infile("prison.in",ios::in);
	memset(g,0,sizeof(g));
	int u,v,w;
	infile>>n>>m;
	for(int i=1;i<=m;i++){
		infile>>u>>v>>w;
		add(u,v,w);add(v,u,w);
		a[i]=w;
	}
	qsort(1,m);
	infile.close();
}

void over()
{
	ofstream outfile("prison.out",ios::out);
	outfile<<ans<<endl;
	outfile.close();
}

bool bfs(int weight)
{
	int f,r,u,v,w;
	edge* p;
	memset(color,0,sizeof(color));
	for(int k=1;k<=n;k++) if(color[k]==0){
		f=1;r=0;
		r++;q[r]=k;color[k]=1;
		while(f<=r){
			u=q[f];f++;
			p=g[u];
			while(p!=NULL){
				v=p->v;w=p->w;
				if(w>weight){
					if((color[v]==color[u])&&(color[v]!=0))
						return false;
					else if(color[v]==0){
						r++;q[r]=v;
						color[v]=(color[u]%2)+1;
					}
				}
				p=p->next;
			}
		}
	}
	return true;
}
int main()
{
	int l,r,mid;
	init();
	l=1;r=m;
	while(l<=r){
		mid=(l+r)/2;
		if(bfs(a[mid])) r=mid-1;
		else l=mid+1;
	}
	if(r<=0) ans=0;
	else ans=a[l];
	over();
	return 0;
}
