/*
 		      NOI 2002 Day 1 Problem 2 
                                Child
			   Sample Solution
			     by Rujia Liu
*/
#include "childlib.cpp"
#define MaxN  502

  int N,M,C,Tot;
  int Next[MaxN];
  int ChildType[MaxN];
  int Possible[MaxN];
  int NTried[MaxN];
  int Tried[MaxN][5];

//This is a Time-Space Trade off. This uses less memory but a lot of time
int CalcChildType(int Ref)
{
  int a,b;
  a=Ref;
  ChildType[Ref]=0;
  while(a%C+1!=Ref){
    b=a%C+1;
    if(ChildType[a]==0) ChildType[b]=1-Next[a];
    else ChildType[b]=Next[a];
    a=b;
  }
  if (ChildType[a]==0 && Next[a]==1) return 0;
  if (ChildType[a]==1 && Next[a]==0) return 0;
  ChildType[Ref]=2;
  return 1;
}

void PreProcess(void)
{
  int i,j,Num1,Num2;
  GetNM(&N,&M);
  C=N+M+1;
  for(i=1;i<=C;i++) Next[i]=Ask(i,i%C+1,0);
  Tot=0;
  for(i=1;i<=C;i++){
    if(!CalcChildType(i)) continue;
    Num1=0; Num2=0;
    for(j=1;j<=C;j++){
      if(ChildType[j]==0) Num1++;
      if(ChildType[j]==1) Num2++;
    }
    if (Num1==N && Num2==M){
      Possible[i]=1;
      Tot++;
    }
    else Possible[i]=0;
  }
}

void Sieve(void)
{
  int i,j,k,t,Turn;
  int ok;
  int Result;
  for(i=1;i<=C;i++){
    NTried[i]=2;
    Tried[i][1]=i;
    Tried[i][2]=i%C+1;
  }

  for(Turn=0;Turn<5;Turn++)
    for(i=1;i<=C;i++){
      if (Tot==1)
	for (k=1;k<=C;k++)
	  if (Possible[k]){
	    CalcChildType(k);
	    for(t=1;t<=C;t++) Answer(ChildType[t]);
	  }
      //Find a person to Ask about
      for(j=1;j<=C;j++){
	ok=1;
	for(k=1;k<=NTried[i];k++)
	  if(j==Tried[i][k]) ok=0;
	if (ok) break;
      }
      //Test Every Possibility
      Result=Ask(i,j,0);
      for(k=1;k<=C;k++)
	if (Possible[k]){
	  CalcChildType(k);
	  if (ChildType[i]==0 || (ChildType[i]==2 && NTried[i]%2==1)){ //Say Truth
	    if (Result==0 && ChildType[j]==0) Possible[k]=0;
	    if (Result==1 && ChildType[j]!=0) Possible[k]=0;
	  }
	  if (ChildType[i]==1 || (ChildType[i]==2 && NTried[i]%2==0)){
	    if (Result==0 && ChildType[j]!=0) Possible[k]=0;
	    if (Result==1 && ChildType[j]==0) Possible[k]=0;
	  }
	  if(!Possible[k]) Tot--;
	}
      NTried[i]++;
      Tried[i][NTried[i]]=j;
    }
}

void main()
{
  PreProcess();
  Sieve();
}