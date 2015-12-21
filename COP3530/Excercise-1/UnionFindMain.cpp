/* 
 * File:   main.cpp
 * Author: memamdie
 *
 * Created on January 17, 2015, 2:06 PM
 */
#include <cstdlib>
#include <sstream>
#include <iostream>
#include <fstream>
#include "UnionFind.h"
using namespace std; 
/*
 * 
 */
int main() {
    string computers;
    string fileToBeRead; //this will be the string read in from the file
    int op, a, b; //these numbers will be used in method calls
    cout << "What is the name of the file you would like to read in?" << endl;
    cin >> fileToBeRead;
    ifstream file; //the file that will be read throughout the program
    file.open(fileToBeRead.c_str()); // open the file
    getline(file,computers); // Saves the line in number of computers as a string.
    int numberOfComputers; // max value for A or B
    istringstream (computers) >> numberOfComputers;//convert the string to an int          
    UnionFind* unionFind = new UnionFind(numberOfComputers);
    while(!file.eof()){ // To get you all the lines.
        getline(file, computers); //parses the file
        if(computers.find("-1 -1 -1") != string::npos) { //checks to see if you have reached the last line of the file
            break; //if you have reached the last line, stop and break from the loop
        }
        else {
            size_t space1 =  computers.find(" "); // find where the first space is
            size_t space2 = computers.rfind(" "); // find where the last space is
            op = computers.at(0) -48; //the operation will always be a 0 or 1 so it is at the first index position
            istringstream(computers.substr(space1+1, (space2 - space1 -1))) >> a; //since we dont know the length use everything between the first space and the second space as the first number, then cast as an int
            istringstream(computers.substr(space2+1)) >> b; //this number is from the second space to the end of the string, then cast it as an int
            if(op == 0) { //if the operation is 0 then we need to connect the two nodes
                unionFind->connect(a,b);
            }
            else if(op ==1) {//if the operation is 1 then we must check if the nodes are connected already
                unionFind->connected(a, b);
            }
        }
    }
    unionFind -> ~UnionFind();
    file.close();
    return 0;
}
