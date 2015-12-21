/* 
 * File:   WeightedQU.h
 * Author: memamdie
 *
 * Created on January 17, 2015, 2:19 PM
 */

#ifndef WEIGHTEDQU_H
#define	WEIGHTEDQU_H
#include <cstdlib>
#include <sstream>
#include <iostream>
#include <fstream>


using namespace std;

class UnionFind {
private:
    int* id;
    int* temp;
    int size;
public:
    UnionFind();
    UnionFind(int);
    ~UnionFind();
    int root(int);
    bool connected(int, int);
    void connect(int, int);
    void printout();
};
#endif	/* WEIGHTEDQU_H */

