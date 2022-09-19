/*
忽然大悟，补上第三题解题报告，膜拜给程序的C++神牛
解题步骤：
(1).找环，把它压成点，不要问我为什么，压成点后不要问我买入卖出如何处理
(2).反复执行(1)，直到不满足条件
(3).此时我们得到一个Dag(有向无环图)
(4).SPFA
(5).AC.
*/
#include <cstdio>
#define NMax 50000
#define MMax 100000

using namespace std;

struct edge{
     int e;
     char c;
     edge *next;
}epool[MMax<<1],*etop;
edge *E[NMax];

int N,price[NMax];
char vi[NMax],vi2[NMax];
int stack[NMax];

void dfs1(){
     int tp,x;
     vi[stack[0]=0]=1;tp=1;
     while (tp){x=stack[--tp];
         for (edge *p=E[x];p;p=p->next)if (p->c!=0 && vi[p->e]==0)
             vi[stack[tp++]=p->e]=1;
     }
}
void dfs2(){
     int tp,x;
     vi2[stack[0]=N-1]=1;tp=1;
     while (tp){x=stack[--tp];
         for (edge *p=E[x];p;p=p->next)if (p->c!=1 && vi2[p->e]==0)
             vi2[stack[tp++]=p->e]=1;
     }
}
int best[NMax];
void dfs3(int u){
     int tp,x;
     if (best[u]<price[u])best[u]=price[u];
     stack[0]=u;tp=1;
     while (tp){x=stack[--tp];
         for (edge *p=E[x];p;p=p->next)if (p->c!=1 && vi[p->e] && vi2[p->e] && best[p->e]<price[u])
             best[stack[tp++]=p->e]=price[u];
     }
}
int rk[NMax];
void qs(int b,int e){int j,t;
     if (b>=e)return;
     t=rk[b];rk[b]=rk[(b+e)>>1];rk[(b+e)>>1]=t;
     for (int i=j=b+1;i<=e;i++)if (price[rk[i]]>price[rk[b]] ||
         price[rk[i]]==price[rk[b]] && rk[i]<rk[b]){
             t=rk[i];rk[i]=rk[j];rk[j]=t;j++;
         }
     --j;
     t=rk[j];rk[j]=rk[b];rk[b]=t;
     qs(b,j-1);qs(j+1,e);
}
int main()
{        
     FILE *fin=fopen("trade.in","r"),*fout=fopen("trade.out","w");
     etop=epool;
     int M,x,y,z;
     fscanf(fin,"%d %d",&N,&M);
     for (int i=0;i<N;i++)fscanf(fin,"%d",price+i),E[i]=NULL;
     for (int i=0;i<M;i++){
         fscanf(fin,"%d %d %d",&x,&y,&z);x--;y--;
         if (z==1){
             etop->e=y;etop->next=E[x];E[x]=etop;etop->c=1;etop++;
             etop->e=x;etop->next=E[y];E[y]=etop;etop->c=0;etop++;
         }else{
             etop->e=y;etop->next=E[x];E[x]=etop;etop->c=2;etop++;
             etop->e=x;etop->next=E[y];E[y]=etop;etop->c=2;etop++;
         }
     }
     for (int i=0;i<N;i++)vi[i]=vi2[i]=0;
     dfs1();
     dfs2();
     for (int i=0;i<N;i++)best[rk[i]=i]=-1;
     qs(0,N-1);
     for (int i=0;i<N;i++)if (vi[rk[i]] && vi2[rk[i]])dfs3(rk[i]);
     int ret;
     ret=0;
     for (int i=0;i<N;i++)if (vi[i] && vi2[i] && best[i]-price[i]>ret)ret=best[i]-price[i];
     fprintf(fout,"%d\n",ret);
     fclose(fin);fclose(fout);
     return 0;
}
