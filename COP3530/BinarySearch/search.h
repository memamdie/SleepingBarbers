/* 
 * File:   search.h
 * Author: memamdie
 *
 * Created on March 19, 2015, 12:22 PM
 */

#ifndef SEARCH_H
#define	SEARCH_H
#include <iostream>
#include <algorithm>
#include <iostream>
#include <string>
#include <fstream>

using namespace std;

class notEnoughSpace: public exception{
    virtual const char* what() const throw() {
        return "Out of Memory Exception!";
    }
} notEnoughSpace;

class Search {
private:
    int sizeOfArray, elementsToBeSearched, element, size, lo, hi, mid, *list, *searchArray;
    string fileName, number;
    bool found;
public:
	//Constructor that takes in the name of the file we want to read
    Search(string fileName) {
		found = false;
        ifstream file;
		//open the file
        file.open(fileName.c_str());
		//read the first number
        file >> number;
		//we know that this will be the size of the array so we store this number for safe keeping
        sizeOfArray = atoi((number).c_str());
	try {
			//try to make an array this big
        	list = new int[sizeOfArray];
	} 
	catch (exception e) {
		//if we cannot make an array this big we will throw an exception
		throw notEnoughSpace;	
	}
        //read the next number
		file >> number;
		//we know this is the number of elements we will be searching for
        elementsToBeSearched = atoi((number).c_str());
	try {
			//again try to make an array this big
        	searchArray = new int[elementsToBeSearched];
	} 
	catch (exception e) {
		//catch the possible out of memory exception
		throw notEnoughSpace;	
	}
		//keep a counter of how many elements you have stored so you know when the next number is an element you should be searching for
        for(int i = 0; i < sizeOfArray; i++) {
            file >> number;
            list[i] = atoi((number).c_str());
        }
        //now that you have stored everything immediately sort the list
		sort(list, list + sizeOfArray);
		//you have now reached the space in the file that contains elements you want to search for
        for(int i = 0; i < elementsToBeSearched; i++) {
            file >> number;
			//read those elements and move them into the array
            searchArray[i] = atoi((number).c_str());
        }
		//we're done with the file so close it
        file.close();
    }
	//returns the number of elements we will be searching for so that it can be used in the main
    int numOfSearches() {
        return elementsToBeSearched;
    }  
	//conducts a linear search through the array for the element in the search array at whatever index position is specified
    bool linear(int index) {
		//figure out what the element at the index position is
        element = searchArray[index];
		//iterate through the array to find out if you have found the element you are looking for
        for(int i = 0; i < sizeOfArray; i++) {
            int temp = list[i];
            if(list[i] == element) {
                found = true;
                break;
            }
            else {
				//worst case scenario the element was not found and you have gone through each element in the array
                found = false;
            }
        }
        return found;
    }
	//searches through the array 
    bool binary(int index) {
        found = false;
		//figure out what element it is that were looking for
        element = searchArray[index];
		//set the size of the space we're looking at to initially the size of the array
        size = sizeOfArray;
        lo = 0;
        hi = size-1;
        mid = size/2;
		//ensure that you have not reached a point where all 3 values are the same and would cause an infinite loop if the element is not in the array
        while(lo != hi && hi != mid && mid != lo){
            //if the number in the middle is less than the element you are looking for than the number you are looking for is to the right side of the array   (higher side)
			if(list[mid] < element) {
                lo = mid;
                size = hi-lo;
                mid +=  size/2;
            }
			//if the number in the middle is less than the element you are looking for than the number you are looking for is to the left side of the array	 (lower side)
            else if(list[mid] > element) {
                hi = mid;
                size = hi - lo;
                mid -= size/2;
            }
			//if you have found the number return true and break from the while loop
            else if(list[mid] == element) {
                found = true;
                break;
            }
			//otherwise found will still be false and will return once you have hi mid and lo equal to each other
        }
        return found;
    }
};

#endif	/* SEARCH_H */
