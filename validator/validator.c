#include "python3.10/Python.h"
#include <stdlib.h>
#include "validator_backend.h"

extern int verify(int* list_repr, int N, int R) {
	printf("0\n");

	// let's copy the list_repr so we don't have to deal with reference counting
	printf("0.5\n");
	int chain_length = 0;
	printf("1\n");
	for (int i = 0; i < R; i++) if (list_repr[i]) chain_length++;
	printf("2\n");
	if (chain_length == 0) return -1;
	// printf("3\n");
	for (int i = 0; i < R; i++) printf("%d ", list_repr[i]); // TODO: remove
	printf("\n");
	int result = _verify(list_repr, chain_length, N, R);
	return result;
}

