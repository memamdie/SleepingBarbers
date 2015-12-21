/* 
 * File:   bTreeNode.h
 * Author: memamdie
 *
 * Created on April 9, 2015, 12:47 PM
 */
#include <iostream>
#include <string>
using namespace std;

#ifndef BTREENODE_H
#define	BTREENODE_H

class bTreeNode {
private:
    string *keys, *values, output;
    bTreeNode **child_ptr;
    int num_keys, min_deg, size;
    bool isLeaf;
public:
    bTreeNode(int, bool);
    string traverse();
    void split(int, bTreeNode*);
    void insertNode(string, string);
    bool search(string, string*);
    int findKey(string);
    void remove(string);
    string getPred(int);
    string getSucc(int);
    string getPredVal(int);
    string getSuccVal(int);
    void fill(int);
    void borrowPrev(int);
    void borrowNext(int);
    void merge(int);
    ~bTreeNode();
    
    friend class bTree;
};

#endif	/* BTREENODE_H */

