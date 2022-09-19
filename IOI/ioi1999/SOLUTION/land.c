// $Log: land_s.c,v $
// Revision 1.2  1999/10/05 12:45:33  erekyus
// Input output filenames changed.
//
// Revision 1.1  1999/10/05 12:17:05  erekyus
// Output format changed.
//
// Revision 1.0  1999/10/02 13:15:01  erekyus
// Initial revision
//

#include <stdio.h>
#include <stdlib.h>

// Maximum width of data
#define DW 700
// Maximum width of plain to find
#define PW 100
// Maximum criteria
#define MC 10
// Input file name
#define INPFN "land.inp"
// Output file name
#define OUTPFN "land.out"

int pl[DW];
int np;
int npc[MC+1];
int cl[DW][MC+1];

int w, h, c;

long ma=1;
int x1=1, y1=1, x2=1, y2=1;

int main()
{
  int np, hd, hdc;
  int wc, hc, wc2;
  register int cc;
  int r, hm;
  long ca;
  FILE *inpf, *outpf;

  if(!(inpf = fopen(INPFN, "r"))) {
    fprintf(stderr, "Error opening input file.\n");
    exit(1);
  }

  fscanf(inpf, "%d %d %d \n", &w, &h, &c);

// Process the first line
  y1 = y2 = h;
  for(wc=0; wc < w; wc++) {
    fscanf(inpf, "%d ", &pl[wc]);
    for(cc=0; cc <= c; cc++) {
      cl[wc][cc] = 1;
      for(wc2=wc; 0 <= wc2 && wc - wc2 < PW; wc2--) {
        hdc = pl[wc2]-pl[wc]+cc;
        if(0 <= hdc && hdc <= c) {
          if(ma < (ca = (long) (wc - wc2 + 1))) {
            ma = ca;
            x1 = wc2+1;
            x2 = wc+1;
          }
        }
        else
          break;
      }
    }
  }
  fscanf(inpf, " \n ");

// Process the remaining lines
  for(hc=h-1; 0 < hc; hc--) {
    for(wc=0; wc < w; wc++) {
      fscanf(inpf, "%d ", &np);
      hd = pl[wc]-np;
      for(cc=0; cc <= c && hd+cc < 0; cc++)
        npc[cc] = 1;
      for(; cc <= c && (r = hd+cc) <= c; cc++)
        npc[cc] = cl[wc][r]+1;
      for(; cc <= c; cc++)
        npc[cc] = 1;
      pl[wc] = np;
      for(cc = 0; cc <= c; cc++)
        cl[wc][cc] = npc[cc];
      for(cc=0; cc <= c; cc++) {
        hm = cl[wc][cc];
        for(wc2=wc; 0 <= wc2 && wc - wc2 < PW; wc2--) {
          hdc = pl[wc2]-pl[wc]+cc;
          if(0 <= hdc && hdc <= c) {
            if(cl[wc2][hdc] < hm)
              hm = cl[wc2][hdc];
            if(ma < (ca = (long) hm * (long) (wc - wc2 + 1))) {
              ma = ca;
              x1 = wc2+1;
              y1 = hc;
              x2 = wc+1;
              y2 = hc+hm-1;
            }
          }
          else
            break;
        }
      }
    }
    fscanf(inpf, "\n");
  }
  if(!(outpf = fopen(OUTPFN, "w"))) {
    fprintf(stderr, "Error opening output file.\n");
    exit(1);
  }
  fprintf(outpf, "%d %d %d %d", x1, y1, x2, y2);
  fclose(inpf);
  fclose(outpf);

  return 0;
}


