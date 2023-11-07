#include "window.c"

typedef struct SlidingWindow SlidingWindow;

SlidingWindow *createSlidingWindow(int * values, int length);
void freeSlidingWindow(SlidingWindow *d);
int sliding_window_append(SlidingWindow *d, int newValue);

typedef struct SummedWindow SummedWindow;
SummedWindow *createSummedWindow(int * values, int length);
void freeSummedWindow(SummedWindow *window);
int summed_window_append(SummedWindow *window, int newValue);