#include "python3.10/Python.h"
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

static PyObject *verify(PyObject *self, PyObject *args) {
	PyObject *list_repr_obj;
	int N, R;

	// let's copy the list_repr so we don't have to deal with reference counting
	if (!PyArg_ParseTuple(args, "OII", &list_repr_obj, &N, &R)) return NULL;
	if (sizeof(PyList_Size(list_repr_obj)) != R) return NULL;
	int chain_length = 0;
	Py_INCREF(list_repr_obj);
	int *list_repr = malloc(R);
	for (int i = 0; i < R; i++) {
		int item = PyLong_AsLong(PyList_GetItem(list_repr, i));
		if (item) chain_length++;
		list_repr[i] = item;
	}
	Py_DECREF(list_repr_obj);
	if (chain_length == 0) {
		free(list_repr);
		return NULL;
	}
	for (int i = 0; i < R; i++) printf(list_repr[i]); // TODO: remove

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

	return Py_True;
}

