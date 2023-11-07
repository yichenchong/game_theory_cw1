#include "window.h"

typedef struct SlidingWindowNode {
	struct SlidingWindowNode * next;
	int value;
} SlidingWindowNode;

typedef struct SlidingWindow {
	SlidingWindowNode * head;
	SlidingWindowNode * tail;
    int length;
} SlidingWindow;

SlidingWindow *createSlidingWindow(int * values, int length) {
	SlidingWindow * newSlidingWindow = calloc(1, sizeof(SlidingWindow));
    newSlidingWindow->length = length;
	if (length == 0) return newSlidingWindow;
	SlidingWindowNode * headNode = calloc(1, sizeof(SlidingWindowNode));
    headNode->value = values[0];
	SlidingWindowNode *ptr = headNode;
	newSlidingWindow->head = headNode;
	if (length > 1) {
		SlidingWindowNode *tailNode = calloc(1, sizeof(SlidingWindowNode));
        tailNode->value = values[length - 1];
        newSlidingWindow->tail = tailNode;
	} else {
		newSlidingWindow->tail = headNode;
		return newSlidingWindow;
	}

	for (int i = 1; i < length - 1; i++) {
        SlidingWindowNode *newNode = calloc(1, sizeof(SlidingWindowNode));
        newNode->value = values[i];
        ptr->next = newNode;
        ptr = ptr->next;
	}
    ptr->next = newSlidingWindow->tail;
    return newSlidingWindow;
}

void freeSlidingWindow(SlidingWindow *d) {
    SlidingWindowNode *ptr = d->head;
    SlidingWindowNode *nextPtr = ptr->next;
    while (ptr) {
        free(ptr);
        ptr = nextPtr;
        if (ptr->next) nextPtr = ptr->next;
    }
    free(d);
}

int sliding_window_append(SlidingWindow *d, int newValue) {
    /*
     * Adds a value to the sliding window.
     * Returns the value popped from the front
    */

    SlidingWindowNode * newNode = calloc(1, sizeof(SlidingWindowNode));
    newNode->value = newValue;
    d->tail->next = newNode;
    d->tail = newNode;
    int oldValue = d->head->value;
    d->head = d->head->next;
    return oldValue;
}

typedef struct SummedWindow {
    SlidingWindow *window;
    int sum;
} SummedWindow;

SummedWindow *createSummedWindow(int * values, int length) {
    SlidingWindow *window = createSlidingWindow(values, length);
    SlidingWindowNode *ptr = window->head;
    int sum = 0;
    while (ptr) {
        sum += ptr->value;
        ptr = ptr->next;
    }
    SummedWindow *newWindow = malloc(sizeof(SummedWindow));
    newWindow->window = window;
    newWindow->sum = sum;
    return newWindow;
}

void freeSummedWindow(SummedWindow *window) {
    freeSlidingWindow(window->window);
    free(window);
}

int summedWindowAppend(SummedWindow *window, int newValue) {
    int popped = sliding_window_append(window->window, newValue);
    window->sum += newValue - popped;
    return window->sum;
}