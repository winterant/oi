#include <iostream>
#include <fstream>
using namespace std;

const int maxcount=40;
const int maxn=350;

int b[5],f[maxcount+2][maxcount+2][maxcount+2][maxcount+2],score[maxn+1];

int main()
{
	ifstream infile("tortoise.in",ios::in);
	ofstream outfile("tortoise.out",ios::out);
	memset(b,0,sizeof(b));
	memset(f,0,sizeof(f));
	int n,m,x,step;
	infile>>n>>m;
	for(int i=1;i<=n;i++)
		infile>>score[i];
	for(int i=1;i<=m;i++){
		infile>>x;
		b[x]++;
	}
	for(int i=1;i<=b[1]+1;i++)
		for(int j=1;j<=b[2]+1;j++)
			for(int k=1;k<=b[3]+1;k++)
				for(int l=1;l<=b[4]+1;l++){
					step=i+j*2+k*3+l*4-10+1;
					if(f[i][j][k][l]<f[i-1][j][k][l]) 
						f[i][j][k][l]=f[i-1][j][k][l];
					if(f[i][j][k][l]<f[i][j-1][k][l]) 
						f[i][j][k][l]=f[i][j-1][k][l];
					if(f[i][j][k][l]<f[i][j][k-1][l]) 
						f[i][j][k][l]=f[i][j][k-1][l];
					if(f[i][j][k][l]<f[i][j][k][l-1]) 
						f[i][j][k][l]=f[i][j][k][l-1];
					f[i][j][k][l]+=score[step];
				}
	outfile<<f[b[1]+1][b[2]+1][b[3]+1][b[4]+1]<<endl;
	infile.close();
	outfile.close();
	return 0;
}
