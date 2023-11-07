#ifndef __SLIDING_WINDOW_LIB
#define __SLIDING_WINDOW_LIB

typedef struct SlidingWindowNode SlidingWindowNode;
typedef struct SlidingWindow {
	SlidingWindowNode * head;
	SlidingWindowNode * tail;
    int length;
} SlidingWindow;

SlidingWindow *createSlidingWindow(const int * values, int length);
void freeSlidingWindow(SlidingWindow *d);
int sliding_window_append(SlidingWindow *d, int newValue);
typedef struct SummedWindow {
    SlidingWindow *window;
    int sum;
} SummedWindow;
SummedWindow *createSummedWindow(const int * values, int length);
void freeSummedWindow(SummedWindow *window);
int summed_window_append(SummedWindow *window, int newValue);

#endif