#include "oracle.h"
#include <stdio.h>
#include <string.h>

#define INFILE "string.in"
#define OUTFILE "string.out"
#define LOGFILE "string.log"

static FILE *fin;
static FILE *fout;
static char sin[255];
static int oracle_cnt=-99;

static void ABOUT(char *erm)
{
	printf("%s\n",erm); 	
	exit(2);
}

void start_string(void)
{
	int cc=0;
	if (oracle_cnt!=-99) ABOUT("Error: You called start_string() 2 times.");    	
	
	oracle_cnt=0;
	fin=fopen(INFILE,"r");
	if (!fin) ABOUT("Error: Cannot open 'string.in'.");    	
	fout=fopen(OUTFILE,"w");
	while(!feof(fin)) {	
		fscanf(fin,"%c",&sin[cc]);
		if (!((sin[cc]==10) || (sin[cc]==13))) {
			// to search ERROR input string.
			// if ((sin[cc]!='A') && (sin[cc]!='T') && (sin[cc]!='G') && (sin[cc]!='C'))
			//	ABOUT("ERROR: other character except A,T,G,C appeared.");
			cc++;
		}
	}
	sin[cc]=0;
}

int oracle_call(char *s)
{
	int i;
	char *pch;	
	for(i=0;i<strlen(s);i++)
		if ((s[i]!='A') && (s[i]!='T') && (s[i]!='G') && (s[i]!='C'))
			ABOUT("ERROR: other character except A,T,G,C appeared.");		
	if (oracle_cnt==-99) ABOUT("ERROR: start_string() called at first.\n");	
	if (strlen(s)==0) ABOUT("ERROR: S should not be null.");
	if (strlen(s)>=255) ABOUT("ERROR: The length of query S shold be less than 255 chars.");
	oracle_cnt++;
	pch = strstr (sin,s);
	if (pch==NULL) return 0; else return 1;		
	return 0;
}

void answer_string (char *s)
{
	if (oracle_cnt==-99) ABOUT("ERROR: start_string() called at first\n");			 
	fprintf(fout,"%d\n",oracle_cnt);
	fprintf(fout,"%s\n",s);
	fclose(fout);
	fclose(fin);
    exit(0);
}
