#include <iostream>
#include <fstream>
using namespace std;

const int maxn=500;const int dx[4]={1,-1,0,0};
const int dy[4]={0,0,1,-1};
int n,m,ans;
int q[maxn*maxn*2][2],s[maxn+1][maxn+1],h[maxn+1][maxn+1];
int st[maxn+1],ed[maxn+1],dp[maxn+1];
bool flag;
void judge()
{
	int f,r;
	int x,y,tx,ty;
	memset(s,0,sizeof(s));
	for(int k=1;k<=m;k++) if(s[1][k]==0){
		f=1;r=0;
		r++;q[r][0]=1;q[r][1]=k;s[1][k]=1;
		while(f<=r){
			x=q[f][0];y=q[f][1];f++;
			for(int i=0;i<4;i++){
				tx=x+dx[i];ty=y+dy[i];
				if((tx>=1)&&(tx<=n)&&(ty>=1)&&(ty<=m)) 
					if((s[tx][ty]==0)&&(h[tx][ty]<h[x][y])){
						r++;q[r][0]=tx;q[r][1]=ty;s[tx][ty]=1;
					}
			}
		}
	}
	flag=true;ans=0;
	for(int i=1;i<=m;i++)
		if(s[n][i]==0){
			flag=false;ans++;
		}
}

void work(){
	int x,y,tx,ty,f,r;
	for(int k=1;k<=m;k++){
		f=1;r=0;
		memset(s,0,sizeof(s));
		r++;q[r][0]=1;q[r][1]=k;s[1][k]=1;
		while(f<=r){
			x=q[f][0];y=q[f][1];f++;
			for(int i=0;i<4;i++){
				tx=x+dx[i];ty=y+dy[i];
				if((tx>=1)&&(tx<=n)&&(ty>=1)&&(ty<=m)) if((s[tx][ty]==0)&&(h[tx][ty]<h[x][y])){
					r++;q[r][0]=tx;q[r][1]=ty;s[tx][ty]=1;
				}
			}
		}
		for(int i=1;i<=m;i++)
			if(s[n][i]!=0){st[k]=i;break;}
		for(int i=m;i>=1;i--)
			if(s[n][i]!=0){ed[k]=i;break;}
	}
	memset(dp,0,sizeof(dp));
	dp[0]=0;
	int min;
	for(int i=1;i<=m;i++){
		min=100000000;
		for(int j=1;j<=m;j++) if((st[j]<=i)&&(ed[j]>=i))
			if(dp[st[j]-1]<min) min=dp[st[j]-1];
		dp[i]=min+1;
	}
	ans=dp[m];
}

int main()
{
	ifstream infile("flow.in",ios::in);
	ofstream outfile("flow.out",ios::out);
	infile>>n>>m;
	for(int i=1;i<=n;i++)
		for(int j=1;j<=m;j++)
			infile>>h[i][j];
	judge();
	if(flag==false){
		outfile<<0<<endl;
		outfile<<ans<<endl;
	}
	else{
		work();
		outfile<<1<<endl;
		outfile<<ans<<endl;
	}
	infile.close();
	outfile.close();
	return 0;
}
