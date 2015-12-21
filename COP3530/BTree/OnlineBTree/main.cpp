//
//  main.cpp
//  OnlineBTree
//
//  Created by Michelle Emamdie on 4/6/15.
//  Copyright (c) 2015 Michelle Emamdie. All rights reserved.
//

#include <iostream>
#include <string>
#include "bTreeNode.h" 
using namespace std;

int main(int argc, const char * argv[]) {
    // Driver program to test above functions
    BTree t(2); // A B-Tree with minium degree 3
    t.insert("c");
    t.insert("e");
    t.insert("a");   
    t.insert("w");
    t.insert("t");
    t.insert("i");
    t.insert("o");
    t.insert("q");
    t.insert("b");
    t.insert("d");
    t.insert("y");
    t.insert("f");
    t.insert("g");
    t.insert("s");
    t.insert("j");
    
    cout << "Traversal of the constucted tree is \n";
	t.traverse();
    
    string key = "u";
    (t.search(key) != NULL)? cout << "\nPresent\n" : cout << "\nNot Present\n";
    
    key = "a";
    (t.search(key) != NULL)? cout << "\nPresent\n" : cout << "\nNot Present\n";
    
    return 0;
}
