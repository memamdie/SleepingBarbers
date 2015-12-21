#include "HashTable.h"

//Constructor
HashTable::HashTable(int size) {
    this -> size = size;
    table = new string[size];
    count = 0;
}
//Searches through the array for a given value
bool HashTable::find(string value) {
    bool found = false;
    //Generate a key in the same manner that the key was generated when inserting the value into the array
    int key = magicalNumber(value);
    for (int i = 0; i < size; i++) {
        //starts at the same key value and compares it to what is in this index position.
        //The compare method will return false if the value has been found
        if(table[(key + i) % size].compare(value) == false) {
            return true;
            break;
        }
    }
    return found;
}
//Inserts he value into the array
void HashTable::insert(string value) {
    //Generate a key
    int key = magicalNumber(value);
    //While the space in the array that you are looking at is not empty, incrememnt the key value
    while(!table[key %  size].empty()) {
        key++;
    }
    //now you have found the empty space so assign the string value to this index position
    table[key % size] = value;
    //increment the count so we can keep track of how many elements are in the array
    count++;
    //This means that the array is full so we will need to enlarge it
    if(count == size) {
        grow(table);
    }
}
//Doubles the size of the array when the array is full
void HashTable::grow(string* temp) {
    size *= 2;
    table = new string[size];
    for(int i = 0; i < size/2; i++) {
        table[i] = temp[i];
    }
}
//Generates a key
int HashTable::magicalNumber(string value) {
    int index = 0;
    for (int i=0; i<value.length(); i++) {
        index += value[i];
    }
    return index;
}
//Deconstructor
HashTable::~HashTable() {
    delete [] table;
}
