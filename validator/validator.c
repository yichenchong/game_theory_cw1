#include "validator.h"
#include "print_debugger.h"
#include <stdlib.h>
#include "window/window.h"

typedef struct IntPair {
  int n1;
  int n2;
} IntPair;

typedef struct FloatPair {
  float n1;
  float n2;
} FloatPair;


static FloatPair window_result(SlidingWindow *weightWindow, SummedWindow *diffWindow, int inWeight, int newDiff) {
  // returns payout and mutated payout
  int outWeight = sliding_window_append(weightWindow, inWeight);
  int newSum = summed_window_append(diffWindow, newDiff);
  if (newSum == 1) return (FloatPair) {0, 0};
  if (!outWeight) return (FloatPair) {0, (float) newSum};
  return (FloatPair) {(float) newSum / (float) outWeight, (float) newSum / (float) (outWeight + 1)};
}

static int verify(const IntPair *chain_repr, int chain_length, int R) {
  DEBUG("Chain format:\n");
  for (int i = 0; i < chain_length; i++) DEBUG("%d, %d\n", chain_repr[i].n1, chain_repr[i].n2);
  DEBUG("\n");

  if (chain_length == 0) return 1;
  if (chain_length == 1) {
    return (chain_repr[0].n2 == 1 ||
            (((float) chain_repr[0].n1 - 1 <= (float) R / (float) chain_repr[0].n2)
            && ((float) R - (float) chain_repr[0].n1 <= (float) R / (float) chain_repr[0].n2)));
  }
  // calculate payouts of each node and max mutated payout
  int x1 = chain_repr[0].n1;

  // initialise the windows
  int *initDWindow = malloc(3 * sizeof(int));
  initDWindow[0] = -1;
  initDWindow[1] = 2 * x1 - 1;
  initDWindow[2] = 0;
  int *initWWindow = malloc(2 * sizeof(int));
  initWWindow[0] = chain_repr[0].n2;
  initWWindow[1] = 0;
  SummedWindow *diffWindow = createSummedWindow(initDWindow, 3);
  SlidingWindow *weightWindow = createSlidingWindow(initWWindow, 2);
  free(initDWindow);
  free(initWWindow);

  // calculating the current payouts, general mutated payouts, and maximum mutated payouts
  float maxMutatedPayout = (float) diffWindow->sum;
  float* currentPayouts = calloc(chain_length, sizeof(float));
  float* nodeMutatedPayouts = calloc(chain_length, sizeof(float));
  for (int i = 1; i < chain_length; i++) {
    FloatPair result1 = window_result(weightWindow, diffWindow, chain_repr[i].n2, chain_repr[i].n1 - chain_repr[i - 1].n1);
    if (result1.n2 > maxMutatedPayout) maxMutatedPayout = result1.n2;
    currentPayouts[i - 1] = result1.n1;
    nodeMutatedPayouts[i - 1] = result1.n2;
    FloatPair result2 = window_result(weightWindow, diffWindow, 0, 0); // no current payout
    if (result2.n2 > maxMutatedPayout) maxMutatedPayout = result2.n2;
  }
  int xlast = R + 1 - chain_repr[chain_length - 1].n1;
  FloatPair result = window_result(weightWindow, diffWindow, 0, 2 * xlast - 1);
  if (result.n2 > maxMutatedPayout) maxMutatedPayout = result.n2;
  currentPayouts[chain_length - 1] = result.n1;
  nodeMutatedPayouts[chain_length - 1] = result.n2;
  result = window_result(weightWindow, diffWindow, 0, -1); // no current payout
  if (result.n2 > maxMutatedPayout) maxMutatedPayout = result.n2;

  float minCurrentPayout = currentPayouts[0];
  DEBUG("currentPayouts[0]: %f\n", currentPayouts[0]);
  for (int i = 1; i < chain_length; i++) {
    if (currentPayouts[i] < minCurrentPayout) minCurrentPayout = currentPayouts[i];
    DEBUG("currentPayouts[%d]: %f\n", i, currentPayouts[i]);
  }
  DEBUG("maxMutatedPayout: %f\n", maxMutatedPayout);
  DEBUG("minCurrentPayout: %f\n", minCurrentPayout);
  free(diffWindow);
  free(weightWindow);

  // calculating the specific mutated payouts
  // side cases: first and last
  int last = chain_length - 1;
  if ( // some early exit conditions
      minCurrentPayout < maxMutatedPayout
      || (chain_repr[0].n2 == 1 &&
          (chain_repr[1].n1 - chain_repr[0].n1 != 1
          || nodeMutatedPayouts[1] + currentPayouts[0] / (float) (chain_repr[1].n2 + 1) > currentPayouts[0]))
      || (chain_repr[last].n2 == 1 &&
          (chain_repr[last].n1 - chain_repr[last - 1].n1 != 1
           || nodeMutatedPayouts[last - 1] + currentPayouts[last] / (float) (chain_repr[last].n2 + 1) > currentPayouts[last]))
  ) {
    free(nodeMutatedPayouts);
    free(currentPayouts);
    return 0;
  }

  DEBUG("Passed early exit conditions.\n");

  for (int i = 1; i < chain_length - 1; i++) {
    float u_b_to_a = nodeMutatedPayouts[i - 1] + (float) (chain_repr[i + 1].n1 - chain_repr[i].n1) / (float) (chain_repr[i - 1].n2 + 1);
    float u_b_to_c = nodeMutatedPayouts[i + 1] + (float) (chain_repr[i].n1 - chain_repr[i - 1].n1) / (float) (chain_repr[i - 1].n2 + 1);
    if (u_b_to_a > currentPayouts[i] || u_b_to_c > currentPayouts[i]) {
      DEBUG("Failed at i = %d.\n", i);
      free(nodeMutatedPayouts);
      free(currentPayouts);
      return 0;
    }
  }

  free(nodeMutatedPayouts);
  free(currentPayouts);
  return 1;
}

extern int verify_arr_repr(const int *arr_repr, int R) {
  int chain_length = 0;
  for (int i = 0; i < R; i++) if (arr_repr[i]) chain_length++;
  if (chain_length == 0) return 0;
  IntPair *chain_repr = malloc(chain_length * sizeof(IntPair));
  int count = 0;
  for (int i = 0; i < R; i++) if (arr_repr[i]) {
    chain_repr[count].n1 = i; // n1 = position
    chain_repr[count].n2 = arr_repr[i]; // n2 = weight
    count++;
  }
  int result = verify(chain_repr, chain_length, R);
  free(chain_repr);
  return result;
}

extern int verify_list_repr(const int *list_repr, int N, int R) {
  int chain_length = N;
  for (int i = 1; i < N; i++) if (list_repr[i] == list_repr[i - 1]) chain_length--;
  IntPair *chain_repr = calloc(chain_length, sizeof(IntPair));
  chain_repr[0].n1 = list_repr[0];
  chain_repr[0].n2 = 1;
  int count = 0;
  for (int i = 1; i < N; i++) {
    if (list_repr[i] == chain_repr[count].n1) {
      chain_repr[count].n2++;
    } else {
      count++;
      chain_repr[count].n1 = list_repr[i];
      chain_repr[count].n2 = 1;
    }
  }

  int result = verify(chain_repr, chain_length, R);
  free(chain_repr);
  return result;
}

