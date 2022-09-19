#include "faruk.h"

#ifndef INT_MAX
#define INT_MAX 2147483647
#endif

#define unseen (INT_MAX - 2) 

#define BLUE 0
#define PURPLE 1

FILE *ifp, *ofp;

/**************************************	init declarations ***************/

struct node 
{
  short v ; 				/* name of the vertex 		*/
  short w ; 				/* weight 			*/
  struct node *next;
};

short V, E;                      	/* number of Vertices and Edges *
					 * V <= 300  E <= 14000		*/

short from,to;

struct node **adj;

struct node *t, *z;

struct lighttype
{
  short initial;                		/* initial colour of vertex	*/
  short fp;				/* first period in seconds	*/
  short blue;				/* period of blue in seconds	*/	
  short purple;				/* period of purple in seconds	*/
  short icp;				/* initial color period in sec.	*/
  short scp;				/* secondary color period , 	*
					 * needed in det_color() 	*/
};

struct lighttype *light;

long *val;				/* dad and val arrays 		*/

short *dad;

short *resar;

/***************************************** determining priorities	*/

short det_color(short c, long t)
{
  if (t < light[c].fp) return (light[c].initial);
  if (((t - light[c].fp) % (light[c].blue + light[c].purple)) < light[c].scp)
    return ((light[c].initial + 1) % 2);	/* return secondary colour 	*/
  return light[c].initial;
}

void det_times(short v, short c, long t, short *mt)
{
  if (t < light[v].fp) {
    mt[0] = light[v].fp - t;
    mt[1] = mt[0] + light[v].scp;
    mt[2] = mt[1] + light[v].icp;
  }
  else if (c == light[v].initial) {
    mt[0] = (light[v].scp + light[v].icp) - 				  
      (t - light[v].fp) % (light[v].scp + light[v].icp);
    mt[1] = mt[0] + light[v].scp;
    mt[2] = mt[1] + light[v].icp;
  }
  else {
  mt[0] = light[v].scp - (t - light[v].fp) % (light[v].scp + light[v].icp);
  mt[1] = mt[0] + light[v].icp;
  mt[2] = mt[1] + light[v].scp;
  }
}

#define MIN(x,y) ((x<y) ? x : y)

short prcalc(short k,short c,long t)
{
  short v1, v2;
  short a1[3], a2[3];
  v1 = det_color(k,t);
  v2 = det_color(c,t);
  if (v1 == v2) return 0;
  det_times(k,v1,t,a1);
  det_times(c,v2,t,a2);
  if (a1[0] != a2[0]) return MIN(a1[0],a2[0]);
  if (a1[1] != a2[1]) return MIN(a1[1],a2[1]);
  return MIN(a1[2],a2[2]);
}

/***************************************** finds highest priority vertex*/

short N;

long *a;

void f_initialize()
{
  register short i;
  N = 0;
  a = (long *) f_malloc ((V+1) * sizeof(long));
  for (i = 1; i <= V; i++) a[i] = 0;
}

short f_empty()
{
  return (N == 0);
}

void f_insert(short k, long v)
{
  a[k]=v;
  N++;                                    
}

short f_update(short k, long v)
{
  if (val[k] == -unseen) {
    f_insert(k,v);
    return 1;
  }
  if (a[k] > v) {
    a[k] = v;
    return 1;
  }
  return 0;
}

short f_remove()
{
  register short i;
  short c;
  long t = unseen + 1;
  for(i = 1; i <= V; i++)
    if ( (a[i] != 0) && (a[i] < t) ) { c = i; t = a[i]; }
  N--;
  a[c] = 0;
  return c;
}

/***************************************** input functions		*/

void adjlist()
{
  register short j;
  short x, y, weight;
  z=(struct node *) f_malloc(sizeof *z);
  z->next=z;
  for(j=1; j<=V; j++) adj[j]=z;
  for(j=1; j<=E; j++) {
    fscanf(ifp,"%hd %hd %hd\n", &x, &y, &weight);
    if (!((light[x].initial != light[y].initial) &&  
	  (light[x].fp == light[y].fp) && (light[x].blue == light[y].purple) 
	  && (light[x].purple == light[y].blue))) {
      t=(struct node *) f_malloc(sizeof *t);
      t->v=x; t->w=weight; t->next=adj[y]; adj[y]=t;
      t=(struct node *) f_malloc(sizeof *t);
      t->v=y; t->w=weight; t->next=adj[x]; adj[x]=t;
    }
  }
}

void get_vertices()
{
  char state;
  register short i;
  for (i = 1; i <= V; i++) {
    fscanf(ifp,"%c %hd %hd %hd\n", &state, &light[i].fp, &light[i].blue, &light[i].purple);
    light[i].initial = (state == 'B') ? BLUE : PURPLE;
    light[i].scp = (state == 'B') ? light[i].purple : light[i].blue;
    light[i].icp = (state == 'P') ? light[i].purple : light[i].blue;
  }
}

void get_input()
{
  register short i;
  ifp = f_fopen("LIGHTS.INP","r");
  fscanf(ifp,"%hd %hd\n",&from,&to);
  fscanf(ifp,"%hd %hd\n",&V,&E);
  dad = (short *) f_malloc ((V+1) * sizeof (short));
  val = (long *) f_malloc ((V+1) * sizeof (long));
  for (i = 1; i <= V; i++) {
    dad[i] = 0;
    val[i] = 0;
  }
  light = (struct lighttype *) f_malloc ((V+1) * sizeof (struct lighttype));
  get_vertices();
  adj = (struct node **) f_malloc ((V+1) * sizeof (struct node *));
  adjlist();
  fclose(ifp);
}

/***************************************** find shortest path		*/

void visit(short k)
{
  struct node *t;
  if (f_update(k, unseen) != 0) dad[k] = 0;
  while (!f_empty()) {
    k = f_remove();
    val[k] = -val[k];
    if (val[k] == unseen) val[k] = 0;
    for (t = adj[k]; t != z; t = t->next)
      if (val[t->v] < 0)
	if (f_update(t->v, prcalc(k,t->v,val[k]) + val[k] + t->w)) {
	  val[t->v] = -(prcalc(k,t->v,val[k]) + val[k] + t->w);
	  dad[t->v] = k;
	}
  }
}
 
void allsp()
{
  register short k;
  f_initialize();
  for (k = 1; k <= V; k++) val[k] = -unseen;
  if (val[from] == -unseen) visit(from);
  for (k = 1; k <= V; k++)
    if ((val[k] == -unseen) && (k != from)) visit(k);
}


void putitout()
{
  short i = 0, j, x;
  resar = (short *) f_malloc((V+1) * sizeof(short));
  for (i = 0; i <= V; i++) resar[i] = 0;
  i = 0;
  resar[++i]=to;
  x=dad[to];
  do {
    resar[++i] = x;
    x=dad[x];
  } while (x != 0);
  ofp = f_fopen("LIGHTS.OUT","w");
  if (resar[i] != from) {
    fprintf(stderr, "no solution\n");
    exit(-1);
  }
  fprintf(ofp,"%ld\n",val[to]);
   for (j = i; j >= 1; j--)
    fprintf(ofp,"%d ",resar[j]);
  fputs("\n",ofp);
  fclose(ofp);
}

/***************************************** main 			*/
extern long memory_allocated;

int main()
{
  get_input();
  allsp();
  putitout();
/*  printf("%ld\n",memory_allocated);*/
  return 0;
}
