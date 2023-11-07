#include <stdlib.h>
#include "window/window.h"

typedef struct IntPair {
	int n1;
	int n2;
} IntPair;

int _max_payout(IntPair * chain, int length) {
	int x1 = chain[0].n2;
	int initWWindow[2] = {chain[0].n1, 1};
	SlidingWindow *weightWindow = createSlidingWindow(initWWindow, 2);
	int initDWindow[3] = {-1, 2 * x1 - 1, 0};
	SummedWindow *diffWindow = createSummedWindow(initDWindow, 3);
	int maxPayout = diffWindow->sum;
	for (int i = 1; i < length; i++) {
		
	}

	return maxPayout / 2;
}

int _verify (int *list_repr, int chain_length, int N, int R) {
	// convert to chain representation
	IntPair *main_chain = malloc(chain_length * sizeof(int));
	IntPair *chains = calloc(chain_length * chain_length, sizeof(int));
	int *ptrs = calloc(chain_length + 1, sizeof(int));
	for (int i = 0; i < R; i++) {
		if (list_repr[i]) {
			IntPair mainChainPair = {list_repr[i], i + 1};
			main_chain[ptrs[0]] = mainChainPair;
			for (int j = 0; j < chain_length; j++) {
				if (ptrs[0] != j) {
					IntPair newPair = {list_repr[i + 1], i + 1};
					chains[j * chain_length + ptrs[j + 1]++] = newPair;
				} else {
					chains[j * chain_length + ptrs[j + 1]++] = mainChainPair;
				}
			}
			ptrs[0]++;
		};
	}
	free(list_repr);
	free(ptrs);
	// calculate the payoffs
	int *max_payoffs = malloc(chain_length * sizeof(int));

	free(main_chain);
	free(chains);

	return 1;
}