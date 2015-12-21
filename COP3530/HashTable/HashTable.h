#ifndef HASHTABLE_H
#define	HASHTABLE_H
#include "HashEntry.h"
#include <iostream>
#include <iostream>
#include <string>
#include <fstream>

using namespace std;

class HashTable{
private:
    int size, count;
    string* table;
public:
    HashTable(int);//Constructor
    bool find(string);//Searches through the array for a given value
    void insert(string);//Inserts he value into the array
    void grow(string*);//Doubles the size of the array when the array is full
    int magicalNumber(string);//Generates a key
    ~HashTable();//Deconstructor
};
#endif
