#include "oracle.h"
#include <stdio.h>
#include <string.h>

int main(void)
{
//	printf("call:'asdf' return: %d\n",oracle_call("asdf")); 
//	answer_string("ATGC");
//	printf("start_starting\n"); 
	start_string();
	printf("lib_test call:'AAAA' return: %d\n",oracle_call("AAAA")); 
//	printf("call:'ABC' return: %d\n",oracle_call("ABC")); 
	printf("lib_test call:'ATCG' return: %d\n",oracle_call("ATCG")); 
//	printf("answer_starting\n"); 
	answer_string("ATCD");

	return 1;
}
