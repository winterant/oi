/* 		faruk gologlu						*
 * 		      106158-9						*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <errno.h>


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

/* 		malloc with memory control	  	 		*
 * 		#include <stdlib.h>					*/

long memory_allocated = 0;

void *f_malloc(size_t size)
{
  void *p;
  if (!(p = malloc(size))) {
    fprintf(stderr, "error : in malloc()\n");
    fprintf(stderr, "ERROR %d\n", errno);
    exit(-1);
  }
  memory_allocated += size;
  return p;
}


/* 		randomize and random functions				*
 * 		#include <time.h> and <stdlib.h>			*/



void f_randomize()
{
  time_t t;
  unsigned long seed;
  time(&t);
  t -= 920000000;
  seed = (unsigned long) t;
  srand(seed);
}

short f_random(short size)
{
  return (1 + (short) ( (float) size * rand()/(RAND_MAX+1.0)));
}
