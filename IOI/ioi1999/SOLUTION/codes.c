#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#define MAX_ST_ITEM	10000
#define MAX_CODE	100
#define MAX_LNGT	1000
#define MAX_CONC	1000

#define FC_NAME         "words.inp"
#define FI_NAME         "text.inp"

typedef struct st_struct
{
	unsigned short code;
	long max, end, start;
	struct st_struct *prev, *link;
} st_item;

typedef struct ps_struct
{
	unsigned short code, index;
	long start;
	struct ps_struct *next;
} ps_item;

st_item *head_PQ, *tail_PQ;
ps_item *head_PS[256], *tail_PS[256];
char buf[1024], *code[MAX_CODE];
int curr_char;
long pos;
unsigned short CN, length[MAX_CODE], TableSize, *first[256], n_first[256];
unsigned long FileSize, n_ps_item, m_ps_item, n_st_item, NumberOfCodes;

#ifndef __TURBOC__

unsigned long min(unsigned long a, unsigned long b)
{
	if (a < b) return a; else return b;
}

#endif

void read_codes()
{
	int i; unsigned char c;
	FILE *fc = fopen(FC_NAME, "r"); int dummy;

	fscanf(fc, " %d", &dummy);
	for (i = 0; i < dummy; i++)
	{
		fscanf(fc, "%s", buf);
		length[CN] = strlen(buf); code[CN] = strdup(buf);
		c = buf[0];
		first[c] = realloc(first[c], sizeof(unsigned short) * (n_first[c] + 1));
		first[c][n_first[c]++] = CN++;
	}
	fclose(fc);
}

void insert(unsigned short curr_char, unsigned short code, unsigned short index, long start)
{
	ps_item *p = (ps_item *)malloc(sizeof(ps_item));
	p->code = code,	p->index = index, p->start = start;
	p->next = NULL;
	if (tail_PS[curr_char]) tail_PS[curr_char]->next = p; else head_PS[curr_char] = p;
	tail_PS[curr_char] = p;
	if (++n_ps_item > m_ps_item) m_ps_item = n_ps_item;
}

void insert_all(long i)
{
	int j; unsigned short *p = first[curr_char];
	for (j = 0; j < n_first[curr_char]; j++) insert(curr_char, p[j], 0, i);

}

void delete_item(ps_item *prev, ps_item *curr)
{
	if (prev == NULL) head_PS[curr_char] = curr->next; else prev->next = curr->next;
	if (curr == tail_PS[curr_char]) tail_PS[curr_char] = prev;
	free(curr);
	--n_ps_item;
}

void create_link(st_item *s)
{
	st_item *q = tail_PQ;

	while (q)
	{
		if (q->end < s->start)
		{
			s->link = q, s->max = q->max + length[s->code];
			return;
		}
		q = q->prev;
	}
	s->link = NULL, s->max = length[s->code];
}

void insert_priq(st_item *s)
{
	st_item *q = tail_PQ, *prev = NULL;

	while (q)
	{
		if (q->max > s->max)
		{
			prev = q; q = q->prev;
		} else
		{
_found:
			s->prev = q;
			if (prev) prev->prev = s; else tail_PQ = s;
			return;
		}
	}
	goto _found;
}

void _found_item(ps_item *p, long end)
{
	st_item *s = (st_item *)malloc(sizeof(st_item));
	s->code = p->code, s->start = p->start, s->end = end;
	create_link(s);
	insert_priq(s);
	++n_st_item;
}

void search_all(long i)
{
	unsigned char c;
	ps_item *p = head_PS[curr_char], *prev = NULL, *curr;

	while (p)
	{
		if ((i - p->start) > MAX_LNGT)
		{
			curr = p;
			goto remove;
		}
		c = code[p->code][++p->index]; curr = p;
		if (c == 0)
		{
			_found_item(p, i);

		} else if (c != curr_char)
		{
			insert(c, p->code, p->index, p->start);
		} else goto do_not_remove;
remove:
		p = p->next;
		delete_item(prev, curr);
		goto _next;
do_not_remove:
		prev = p;
		p = p->next;
_next:	;
	}
}

void delete_all()
{
	int i; ps_item *curr, *head;

	for (i = 0; i < 256; i++)
		if (head = head_PS[i])
		{
			while (head)
			{
				curr = head;
				head = head->next;
				free(curr);
			}
			tail_PS[i] = NULL;
		}
}

int search()
{
	int retval = 0;
	FILE *fi = fopen(FI_NAME, "r");

	pos = 0; n_st_item = n_ps_item = m_ps_item = 0;
	while ((curr_char = fgetc(fi)) != EOF)
	{
		insert_all(pos);
		search_all(pos++);
		if (n_st_item >= NumberOfCodes)
		{
			retval = 1; break;
		}
	}
	fclose(fi), delete_all();
	return retval;
}

void output()
{
        FILE *fo = fopen("codes.out", "w");
	fprintf(fo, "%ld\n", tail_PQ->max);
	while (tail_PQ)
	{
		fprintf(fo, "%d %ld %ld\n", tail_PQ->code + 1, tail_PQ->start + 1, tail_PQ->end + 1);
		tail_PQ = tail_PQ->link;
	}
	fclose(fo);
}

void main(int argc, char *argv[])
{
	NumberOfCodes = MAX_ST_ITEM;
	read_codes();
	search();
	output();
}


