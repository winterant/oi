/*
PROB: mobiles
LANG: c
*/
#include <stdio.h>

#define MAX_SIZE 1024

void init   (int size);
void update (int amount, int x, int y);
int  sum    (int x1, int y1, int x2, int y2);

/* the interface */

int main()
{
  int cmd, a1, a2, a3, a4;
  do
    {
      scanf ("%d", &cmd);
      switch (cmd)
	{
	case 0:
	  scanf ("%d", &a1);
	  init (a1);
	  break;
	case 1:
	  scanf ("%d %d %d", &a1, &a2, &a3);
	  update (a3, a1, a2);
	  break;
	case 2:
	  scanf ("%d %d %d %d", &a1, &a2, &a3, &a4);
	  printf ("%d\n", sum(a1, a2, a3, a4));
	  fflush (stdout);
	  break;
	default:
	}
    } while(cmd != 3);
  return 0;
}

/* the solution */
/* IOI problem: 2-dimensional binary indexed tree solution */

#define LOW_BIT(x)  ((x) & ((x) ^ ((x) - 1)))

static int size = 0;
int cum [MAX_SIZE][MAX_SIZE];

void print_cum();
static int cumulative (int x, int y);

void init (int sz)
{
  //int x, y;
  for (size = 1; size < sz; size <<= 1)
    ;
  /* for (x = 0; x < size; ++x)
    for (y = 0; y < size; ++y)
    cum[x][y] = 0; */
}

int sum (int x1, int y1, int x2, int y2)
{
  int res, ix1, ix2, iy1, iy2;
  res = 0;
  for(iy2 = y2+1; iy2 > y1; iy2 -= LOW_BIT(iy2))
    {
      for (ix2 = x2+1; ix2 > x1; ix2 -= LOW_BIT(ix2))
	res += cum[ix2-1][iy2-1];
      for (ix1 = x1; ix1 > ix2; ix1 -= LOW_BIT(ix1))
	res -= cum[ix1-1][iy2-1];
    }
  for(iy1 = y1; iy1 > iy2; iy1 -= LOW_BIT(iy1))
    {
      for (ix2 = x2+1; ix2 > x1; ix2 -= LOW_BIT(ix2))
	res -= cum[ix2-1][iy1-1];
      for (ix1 = x1; ix1 > ix2; ix1 -= LOW_BIT(ix1))
	res += cum[ix1-1][iy1-1];
    }
  return res;
}

void update (int a, int x, int y)
{
  int ix;
  x++; y++;
  for(; y < (size+1); y += LOW_BIT(y))
    for(ix = x; ix < (size+1); ix += LOW_BIT(ix))
	cum[ix-1][y-1] += a;
  //  print_cum();
}

/* compute sum 0 < i < x, 0 < j < y */
int cumulative (int x, int y)
{
  int res, ix;
  res = 0;
  x++; y++;
  for(; y > 0; y -= LOW_BIT(y))
    for(ix = x; ix > 0; ix -= LOW_BIT(ix))
      res += cum[ix-1][y-1];

  //printf ("cumul (%d, %d) = %d \n", x, y, res);
  return res;
}


void print_cum()
{
  int i, j;
  printf ("------- CUM -------\n");
  for (j = 0; j < size; ++j)
    {
      for (i = 0; i < size; ++i)
	printf ("%2d ", cum[i][j]);
      printf ("\n");
    }
}



