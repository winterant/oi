/***************************************/
/*                                     */     
/*            NOI  2003                */
/*          Day 2 Problem 1            */ 
/*             Jerry.cpp               */
/*            by Lin Xide              */
/*                                     */ 
/***************************************/
#include<stdio.h>
#include<stdlib.h>
#include<fstream.h>
#include<assert.h>

FILE *oup;
ifstream fin("hookey.in");
ofstream fou("NUL");
struct point{long x,c;point *n;} *g[200100];
double a[200100],b[200100];
double e[200100],f[200100];
long   c[200100],d[200100];
long   s[200100],h[200100];
long   p[200100],p1,p2;
double max;
long   n,m;
void DFS(long k,long f){
	long x;a[k]=0;
	point *p=g[k];
	while (p!=NULL){
		x=p->x;
		if (x!=f){
			DFS(x,k);
			h[x]=s[k];s[k]=x;c[x]=p->c;
			if (a[k]<a[x]+c[x])
                a[k]=a[x]+c[x];
		};
		p=p->n;
	}
}
void Init(){
	point *p;
	long i,u,v,c;	
	fin>>n>>m;
	for (i=1;i<=n;i++){
		g[i]=NULL;s[i]=h[i]=0;
	}
	for (i=1;i<=m;i++){
		fin>>u>>v>>c;
		p=new point;p->x=v;p->c=c;p->n=g[u];g[u]=p;
		p=new point;p->x=u;p->c=c;p->n=g[v];g[v]=p;
		if (i>=1000000){
			i++;i--;
		};
	}
	DFS(1,0);
	max=0;b[1]=0;
}
void Search(){
	long i,m,x,k,tot=0;
	double L1,L2,L3,w;
    p1=1;p2=1;p[1]=1;
    while (p1<=p2){
	    k=p[p1];m=0;x=s[k];
		if (s[k]==0) tot++;
	    while (x!=0){
			p[++p2]=x;d[++m]=x;x=h[x];
		}
	    e[0]=0;f[m+1]=0;
	    for (i=1;i<=m;i++){
		    x=d[i];
		    if (a[x]+c[x]<e[i-1])
			    e[i]=e[i-1];else
			    e[i]=a[x]+c[x];
		}
	    for (i=m;i>=1;i--){
		    x=d[i];
		    if (a[x]+c[x]<f[i+1])
			    f[i]=f[i+1];else
			    f[i]=a[x]+c[x];
		}
	    L1=b[k],L2=0,L3=0,w;
	    x=s[k];i=0;
	    while (x!=0){
		    i++;
		    b[x]=c[x]+b[k];
		    if (b[x]<e[i-1]+c[x]) 
			    b[x]=e[i-1]+c[x];
		    if (b[x]<f[i+1]+c[x])
			    b[x]=f[i+1]+c[x];
		    w=a[x]+c[x];
		    if (w>L1){
			    L3=L2;L2=L1;L1=w;
			}else{
		        if (w>L2){
				    L3=L2;L2=w;
				}else{
				    if (w>L3) L3=w;
				};
			};
		    x=h[x];
		}
	    w=L1+L2*2+L3;
	    if (w>max) max=w;
		p1++;
	}
}
int main(){
	Init();	
	Search();
	oup=fopen("hookey.out","w");assert(oup);
	fprintf(oup,"%0.0lf\n",max);
	return 0;
}