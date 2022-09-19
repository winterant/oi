#include "flatten.h"

short a[MAX_LENGTH]; 		/* holds data 			*/
long v[MAX_LENGTH];		/* holds no of presses 		*/
short M;			/* no. of buckets 		*/
short N;			/* height 			*/
short nze;			/* number of non-zero entries 	*/
short step = 0;                	/* holds no. of steps so far 	*/
short ent[MAX_PATH];
long nofp[MAX_PATH];
short nfp;			/* bool : nothing can be fully  *
				 * pressed			*/

void get_input()
{
  register short i;
  long total = 0;
  FILE *ifp;
  ifp = f_fopen("FLAT.INP", "r");
  fscanf(ifp,"%hd\n", &M);
  for (i = 1; i <= M; i++) { fscanf(ifp,"%hd", &a[i]); total += a[i]; }
  N = total / M;
  fclose(ifp);
}

void press_info()
{
  long min = 0;
  register short i;
  if ((N - a[1]) > 0)  { 			/* ana hesaplamalar */
    v[2] = N - a[1];
    v[1] = 0;
  }
  else {
    v[1] = a[1] - N;
    v[2] = 0;
  }
  for (i = 2; i < M; i++) {
    v[i+1] = N - a[i] - v[i-1] + (2 * v[i]) ;
    if (v[i+1] < min) min = v[i+1];
  }
  if (min < 0) 					/* eksi degerlerden kurtarmak icin */
    for (i = 1 ; i <= M; i++) v[i] -= min;
  for (i = 2; i <= M-1; i++) v[i] *= 2; 	/* uygun hale getirmek icin */
  for (i = 1; i <= M; i++) if (v[i]) nze++;
}

void write_it(short e, long n)
{
  ent[++step] = e;
  nofp[step] = n;
}

short MPC(short e) 			/* maximum pressable chip */
{
  if ((e == 1) || (e == M)) return a[e];
  return (a[e] % 2) ? a[e] - 1 : a[e];
}

short eval(short e)
{
  if (e == 1) return ((5 * a[1]) / 3);
  else if (e == M) return ((5 * a[M]) / 3);
  else return MPC(e);
}

short eval2(short e)
{
  if (e == 1) return ( v[2] ? 4 * a[1] : a[1] );
  else if (e == M) return ( v[M-1] ? 4 * a[M] : a[M] );
  else {
    short carpan = 0;
    carpan += ( v[e-1] ? 1 :0 );
    carpan += ( v[e+1] ? 1 :0 );
    return (MPC(e) * (2 + carpan) / 2);
  }
}

short find_2nd() 			/* assumes no pile can be fully pressed */
{
  register short i;
  short max = 0, ent = 0;
  if ((a[1] && v[1]) && (((a[1] + a[2]) > v[2]) && v[2])) { ent = 1; max = a[1];}
  for (i = 2; i < M ; i++) 
    if (a[i] && v[i])
      if (((((MPC(i) / 2) + a[i - 1]) >= v[i - 1]) && v[i - 1]) || \
	  ((((MPC(i) / 2) + a[i + 1]) >= v[i + 1]) && v[i + 1])) 
	if (MPC(i) > max) {ent = i; max = MPC(i); }
  if ((a[M] && v[M]) && (((a[M] + a[M - 1]) > v[M - 1]) && v[M - 1]))
    if (a[M] > max) return M;
  return ent;
}
    

void flatten()
{
  register short i;
  short value, entry, no_chip, temp;
  FILE *sol;
  while (nze > 0) {
    value = 0;
    nfp = 0;
    for (i = 1; i <= M; i++) {
      if (a[i] && v[i]) {
	if (a[i] >= v[i]) {			/* hepsine basilabileni sec */
	  entry = i;
	  no_chip = v[i];
	  --nze;
	  nfp = 1;
	  break;
	}
	if (eval(i) > value) {			/* eger fazla basilabilecek varsa */
	  value = eval(i);
	  entry = i;
	  no_chip = MPC(i);
	}
	if (eval(i) == value)
	  if (eval2(i) > eval2(entry)) {
	    entry = i;
	    no_chip = MPC(i);
	  }
      }
    }
    if (!nfp) 
      if ((temp = find_2nd())) {
	entry = temp;
	no_chip = MPC(entry);
      }
    v[entry] -= no_chip;
    a[entry] -= no_chip;
    if (entry == M) { a[entry - 1] += no_chip;  write_it(entry,no_chip);}
    else if (entry == 1) { a[2] += no_chip; write_it(entry,no_chip);}
    else {
      a[entry - 1] += (no_chip / 2);
      a[entry + 1] += (no_chip / 2);
      write_it(entry,no_chip / 2);
    }
  }
  sol = f_fopen("SOLUTION.TXT","w");
  fprintf(sol,"%hd\n", step);
  printf("%hd\n", step);
  fclose(sol);
}

void putitout()
{
  short i;
  FILE *ofp;
  ofp = f_fopen("FLAT.OUT","w");
  fprintf(ofp,"%hd\n", step);
  for (i = 1; i <= step; i++)
    fprintf(ofp,"%hd %ld\n", ent[i], nofp[i]);
}


int main()
{
  get_input();
  press_info();
  flatten();
  putitout();
  return 0;
}
