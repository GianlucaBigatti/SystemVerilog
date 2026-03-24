#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <chrono>

#include "mergesort.h"
#include "quicksort.h"
#include "maxHeap.hpp"

#define MAX 1000000

using namespace std;

int main()
{
    int data[MAX];
    srand(time(NULL));

    for (int max = 500; max <= MAX; max += 1000) {
        for (int i = 0; i < max; i++)
            data[i] = rand() % (max * 10);

        //MergeSort<int> s;
        QuickSort<int> s;
        //MaxHeap<int> s;

        auto start = std::chrono::high_resolution_clock::now();
        s.sort(data, max);
        //qsort(data, max, sizeof(int), compare); // usar com qsort (implementação da biblioteca padrão)

        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<float> duration = end - start;

        /*
        for(int i=0; i<n; i++)
            cout << data[i] << " ";
        cout << endl;
        */

        cout << max << " " << setprecision(7) << fixed << duration.count() << endl;
    }
}

