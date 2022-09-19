#include <stdio.h>
#include <assert.h>
#define COUNT		400

int main()
{
	int i;
	FILE *fp = fopen("graduate10.in", "w");
	assert(fp != NULL);
	fprintf(fp, "%d\n", COUNT * 9);
	for(i = 0; i < COUNT; i++)
		fprintf(fp, "2\n**\n **\n");
	for(i = 0; i < COUNT * 2; i++)
		fprintf(fp, "2\n  *\n***\n");
	for(i = 0; i < COUNT * 2; i++)
		fprintf(fp, "1\n****\n");
	for(i = 0; i < COUNT * 2; i++)
		fprintf(fp, "2\n**\n**\n");
	for(i = 0; i < COUNT * 2; i++)
		fprintf(fp, "2\n *\n***\n");
	fclose(fp);
	return 0;
}