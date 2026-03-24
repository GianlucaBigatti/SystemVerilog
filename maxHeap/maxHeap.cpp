#include <iostream>
#include <string>
#include "maxHeap.hpp"

using namespace std;

int main() {
    srand(time(0));

    MaxHeap<int> maxHeap;

    for (int i = 0; i < 10; i++)
        maxHeap.put(rand() % 100); // Preenche aleatoriamente

    maxHeap.print();

    cout << "Valor extraído: " << maxHeap.get() << endl;
    maxHeap.print();

    // Teste com double
    MaxHeap<double> doubleHeap;
    cout << "\nTestando MaxHeap com doubles:" << endl;
    for (int i = 0; i < 10; i++)
        doubleHeap.put((rand() % 100) / 10.0); // Preenche aleatoriamente
    doubleHeap.print();
    cout << "Valor extraído: " << doubleHeap.get() << endl;
    doubleHeap.print();

    // Teste com strings
    MaxHeap<string> stringHeap;
    cout << "\nTestando MaxHeap com strings:" << endl;
    stringHeap.put("apple");
    stringHeap.put("orange");
    stringHeap.put("banana");
    stringHeap.put("grape");
    stringHeap.print();
    cout << "Valor extraído: " << stringHeap.get() << endl;
    stringHeap.print();

    return 0;
}