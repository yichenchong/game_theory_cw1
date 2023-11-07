#include "python3.10/Python.h"
#include <stdlib.h>
#include "validator_backend.h"

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
		int item = PyLong_AsLong(PyList_GetItem(list_repr_obj, i));
		if (item) chain_length++;
		list_repr[i] = item;
	}
	Py_DECREF(list_repr_obj);
	if (chain_length == 0) {
		free(list_repr);
		return NULL;
	}
	for (int i = 0; i < R; i++) printf("%d", list_repr[i]); // TODO: remove

	return PyBool_FromLong(_verify(list_repr, chain_length, N, R));
}

