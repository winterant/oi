/* 		faruk gologlu						*
 * 		      106158-9						*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <errno.h>

#define 	MAX_LENGTH	201
#define 	MAX_PATH	10001

/* 		fopen with file access control. 			*
 * 		#include <stdio.h>					*/

FILE *f_fopen (const char *path, const char *mode)
{
  FILE *fp;
  if (!(fp = fopen(path,mode))) {
    fprintf(stderr,"error : in fopen(\"%s\", \"%s\")\n", path, mode);
    fprintf(stderr,"ERROR %d\n", errno);
    exit(-1);
  }
  return fp;
}

/* 		randomize and random functions				*
 * 		#include <time.h> and <stdlib.h>			*/

void f_randomize()
{
  time_t t;
  unsigned long seed;
  time(&t);
  seed = (unsigned long) t;
  srand(seed);
}

/*		random(size) : returns 0 .. size-1			*/

int f_random(int size)
{
  return ((int) ( (float) size * rand()/(RAND_MAX+1.0)));
}

