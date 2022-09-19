/***************************************/
/*                                     */     
/*            NOI  2003                */
/*          Day 1 Problem 1            */ 
/*            Editor.cpp               */
/*           by Hou Qiming             */
/*                                     */ 
/***************************************/
#include <stdio.h> //IO speed might be very very important
#include <string.h> //for memmove
#define MAXLENGTH 2048*1024
#define MAXI_D 4000
#define MAXBLOCKN  MAXLENGTH/4096+MAXI_D*2+100
#define BLOCKSIZE 4096-8 
//I love 4096

FILE *F,*FO;

struct block{
	int cur,id;
	char c[BLOCKSIZE];
};

typedef block *pblock;

class text{
private:
	pblock b[MAXBLOCKN+1];
	int cc[MAXBLOCKN];
	int sp;
	int ub,uc,tot;
	inline char *bufchar();
	void recalc();
	void insertblank(int n);
	void overwrite(int n);
public:
	text()
	{
		ub=uc=tot=0;
		sp=1;
		b[0]=new block;
		b[0]->cur=0;
		cc[0]=0;
	};
	void Move(int k);
	void Insert(int n);
	void Delete(int n);
	void Get(int n);
	void Prev();
	void Next();
}t;

inline char Getchar()
{
	int c;
	while((c=fgetc(F))=='\n');
	return c;
};

inline char *text::bufchar()
{
	while(uc==b[ub]->cur)
	{
		ub++;
		uc=0;
	};
	return &(b[ub]->c[uc]);
};

void text::recalc()
{
	int i;
	tot=0;
	for(i=0;i<sp;i++)
	{
		b[i]->id=i;
		cc[i]=tot;
		tot+=b[i]->cur;
	};
};

void text::insertblank(int n)
{
	block *nb;
	int i,ab,antibug,tt;
	if(n==0)return;
	if(ub==sp){ub--;uc=b[ub]->cur;};
	if(b[ub]->cur+n<=BLOCKSIZE)
	{
		if(uc<b[ub]->cur)
			memmove(&(b[ub]->c[uc+n]),&(b[ub]->c[uc]),b[ub]->cur-uc);
		b[ub]->cur+=n;
	}
	else
	{
		ab=0;
		if(uc<b[ub]->cur)
		{
			ab++;
			nb=new block;
			memmove(nb->c,&(b[ub]->c[uc]),nb->cur=b[ub]->cur-uc);
			b[ub]->cur=uc;
			if(BLOCKSIZE-uc>=n)
			{
				b[ub]->cur+=n;
				n=0;
			}
			else
			{
				n-=BLOCKSIZE-b[ub]->cur;
				b[ub]->cur=BLOCKSIZE;
			};
		}
		else
			nb=NULL;
		tt=n;
		tt/=BLOCKSIZE;
		ab+=tt;
		antibug=n;
		antibug%=BLOCKSIZE;
		/*If I wrote "n%BLOCKSIZE" or "n/BLOCKSIZE", it would get a strange result!?*/
		if(antibug)ab++;
		for(i=sp-1;i>ub;i--)
			b[i+ab]=b[i];
		sp+=ab;
		if(nb!=NULL){b[ub+ab]=nb;ab--;};
		for(i=1;i<=ab;i++)
		{
			b[ub+i]=new block;
			b[ub+i]->cur=BLOCKSIZE;
		};
		if(antibug)b[ub+ab]->cur=antibug;
	};
	recalc();
};

void text::overwrite(int n)
{
	int i,bb,bc;
	block *bub;
	bb=ub;
	bc=uc;
	bub=b[ub];
	for(i=0;i<n;i++)
	{
		while(uc==bub->cur)
		{
			ub++;
			uc=0;
			bub=b[ub];
		};
		bub->c[uc]=Getchar();
		uc++;
	};
	ub=bb;
	uc=bc;
};

void text::Insert(int n)
{
	insertblank(n);
	overwrite(n);
};

void text::Delete(int n)
{
	int i,bb;
	if(n==0)return;
	if(uc<b[ub]->cur)
		if(uc<=b[ub]->cur-n)
		{
			if(uc<b[ub]->cur-n)
				memmove(&(b[ub]->c[uc]),&(b[ub]->c[uc+n]),b[ub]->cur-uc-n);
			b[ub]->cur-=n;
			recalc();
			return;
		}
		else
		{
			n-=(b[ub]->cur-uc);
			b[ub]->cur=uc;
		};
	bufchar();
	bb=ub;
	while(n>=b[ub]->cur)
	{
		n-=b[ub]->cur;
		ub++;
		if(ub>=sp)break;
	};
	if(n>0)
	{
		memmove(b[ub]->c,&(b[ub]->c[n]),b[ub]->cur-n);
		b[ub]->cur-=n;
	};
	for(i=bb;i<ub;i++)
		delete b[i];
	bb=ub-bb;
	for(i=ub;i<sp;i++)
		b[i-bb]=b[i];
	sp-=bb;
	ub-=bb;
	if(ub>=sp)
	{
		ub--;
		uc=b[ub]->cur;
	};
	recalc();
};

void text::Get(int n)
{
	int i,bb,bc;
	if(n>5)
		n=n;
	bb=ub;
	bc=uc;
	for(i=0;i<n;i++)
	{
		fputc(*bufchar(),FO);
		uc++;
	};
	ub=bb;
	uc=bc;
	fputc('\n',FO);
};

void text::Move(int k)
{
	int l,m,r;
	l=0;
	r=sp-1;
	while(l<=r)
	{
		m=(l+r)>>1;
		if(cc[m]<=k)l=++m;else r=--m;
	};
	ub=r;
	uc=k-cc[ub];
};

void text::Prev()
{
	while(uc==0)
	{
		ub--;
		uc=b[ub]->cur;
	}
	uc--;
};

void text::Next()
{
	bufchar();
	uc++;
};

int ti,tn;

int main()
{
	char c[100];
	int n;
	F=fopen("editor.in","r");
	FO=fopen("editor.out","w");
	fscanf(F,"%d",&tn);
	for(ti=0;ti<tn;ti++)
	{
		fscanf(F,"%s %d",c,&n);
		switch(c[0])
		{
			case 'M'/*Move*/:t.Move(n);break;
			case 'I'/*Insert*/:t.Insert(n);break;
			case 'D'/*Delete*/:t.Delete(n);break;
			case 'G'/*Get*/:t.Get(n);break;
			case 'P'/*Prev*/:t.Prev();break;
			case 'N'/*Next*/:t.Next();break;
		};
	};
	fclose(FO);
	fclose(F);
	return 0;
};
