/* Test file */
#include "print_debugger.h"
#include "validator.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    int N = 10;
    int R = 10;
    int input[10] = {2, 2, 3,4, 5, 6, 7, 8, 9, 10};

    clock_t start;
    clock_t end;
    start = clock();

    int * input_cpy = calloc(N, sizeof(int));
    for (int i = 0; i < N; i++) input_cpy[i] = input[i];

    printf("Answer: %s\n", verify_list_repr(input_cpy, N, R) ? "True": "False");
    end = clock();
    printf("Time: %f\n", ((double) (end - start)) / CLOCKS_PER_SEC);
    return 0;
}