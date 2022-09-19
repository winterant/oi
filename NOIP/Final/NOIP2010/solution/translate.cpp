#include <iostream>
#include <fstream>

const int maxn=1000;
int f,r,n,m,ans;
int q[maxn+1],a[maxn+1];using namespace std;

void push(int x)
{
	if(a[x]!=0) return;
	r++;q[r]=x;a[x]=1;
	ans++;
	if(r-f+1>m){
		a[q[f]]=0;
		f++;
	}
}
int main()
{
	ifstream infile("translate.in",ios::in);
	ofstream outfile("translate.out",ios::out);
	memset(a,0,sizeof(a));
	int x;
	infile>>m>>n;
	f=1;r=0;ans=0;
	for(int i=1;i<=n;i++){
		infile>>x;
		push(x);
	}
	outfile<<ans<<endl;
	infile.close();
	outfile.close();
	return 0;}
