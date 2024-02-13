#include <stdio.h>
#include <stdbool.h>
#include "linkedList.h"

Spine* linkedList = NULL;

void print_tasks() {
    for (int i = 0; i < linkedList->MAX_NODES; i++) {
        printf("%s\n", getNode(linkedList, i));
    }
}

int main() {
    linkedList = newLinkedList();
    size(linkedList, 10);

    int tally = 0;
    while (tally < 10) {
        char data[50];
        sprintf(data, "Task %d", tally + 1); // (char*)malloc(50 * sizeof(char)
        createNode(linkedList, data);
        tally++;
    }
    print_tasks();
    return 0;
}