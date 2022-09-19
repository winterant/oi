#include <stdio.h>

#define TSize           7
#define Total           20
#define Inf             (Total * 2 + 1)
#define MaxN            279935L
#define true 1
#define false 0

typedef struct Board
{
  char Who;
  unsigned char Pit[TSize];
  unsigned char Bank[2];
} Board;

static unsigned char T[2][MaxN + 1];
static unsigned char OM1[MaxN + 1];
static Board B;

static long B6N(Board *B)
{
  short i;
  long a;

  a = 0;
  for (i = 0; i < TSize; i++)
    a = a * 6 + B->Pit[i];
  return a;
}

static void Move(Board *B, int i, Board *BB)
{
  int S;
  int j;
  int W0, W;

  S = B->Pit[i - 1];
  W0 = B->Who;
  W = !W0;
  *BB = *B;
  BB->Who = W;
  BB->Pit[i - 1] = 0;
  j = i;
  while (S > 1) {
    j++;
    if (j > TSize)
      j = 1;
    if (BB->Pit[j - 1] == 5) {
      BB->Pit[j - 1]--;
      BB->Bank[W0]++;
    } else {
      BB->Pit[j - 1]++;
      S--;
    }
  }

  j++;
  if (j > TSize)
    j = 1;

  if (BB->Pit[j - 1] >= 1 && BB->Pit[j - 1] <= 4) {
    BB->Bank[W0] += BB->Pit[j - 1] + 1;
    BB->Pit[j - 1] = 0;
  } else
    BB->Bank[W]++;
}

static short MinMax(Board *B)
{
  char i;
  Board BB;
  short Diffn, Diffs;
  long a;

  a = B6N(B);

  if (T[B->Who][a] != Inf)
    return (T[B->Who][a]);

  if (B->Who) {
    Diffn = -Inf;
    for (i = 1; i <= TSize; i++) {
      if (B->Pit[i - 1] > 0) {
 	Move(B, i, &BB);
 	Diffs = MinMax(&BB) + BB.Bank[true] - BB.Bank[0] - B->Bank[true] +
 	B->Bank[0];
 	if (Diffs > Diffn) {
 	  Diffn = Diffs;
 	  OM1[a] = i;
 	}
      }
    }
  } else {
    Diffn = Inf;
    for (i = 1; i <= TSize; i++) {
      if (B->Pit[i - 1] > 0) {
 	Move(B, i, &BB);
 	Diffs = MinMax(&BB) + BB.Bank[true] - BB.Bank[0] - B->Bank[true] +
 	B->Bank[0];
 	if (Diffs < Diffn) {
 	  Diffn = Diffs;
 	  /*OM2[a] = i;*/
 	}
      }  /*for i*/
    }
  }

  T[B->Who][a] = Diffn;
  return Diffn;
}

static void Start(void)
{
  int bead, i, Diff;

  for (i = 0; i < TSize; i++) {
    scanf("%d", &bead);
    B.Pit[i] = bead;    
  }
  B.Bank[true] = 0;
  B.Bank[0] = 0;
  B.Who = true;

  for (i = 1; i <= MaxN; i++) {
    T[true][i] = Inf;
    T[0][i] = Inf;
  }
  T[true][0] = Total;
  T[0][0] = Total;
  OM1[0] = 0;

  Diff = MinMax(&B);
}

void Play(void)
{
  long a;
  int i, ii;

  for (;;) {
    a = B6N(&B);
    i = OM1[a];
    printf("%d\n", i); fflush(stdout);
    Move(&B, i, &B);
    if (B.Bank[1] + B.Bank[0] == Total)
      exit(0);

    scanf("%d", &ii);
    Move(&B, ii, &B);
    if (B.Bank[1] + B.Bank[0] == Total)
      exit(0);
  }  
}

int main(void)
{
  Start();
  Play(); 
}


