
#include "UnionFind.h"

UnionFind::UnionFind() { //default constructor creates arrays of size 10
    id = new int[10];
    temp = new int[10];
    for(int i = 0; i < 10; i++) {
        id[i] = i;
        temp[i] = 1;
    }
}
UnionFind::UnionFind(int size) { // constructor that will take N time to assign each array position the value of the index
    id = new int[size+1];
    temp = new int[size+1];
    for(int i = 0; i <= size; i++) {
            id[i] = i;
            temp[i]= 1;
    }
}
UnionFind::~UnionFind() { //delete array
    delete[] id;
    delete[] temp;
}
int UnionFind::root(int root) { //method to find the root in the array
    while(root != id[root]) { //this ensures that when we go to one node we are at the parent root not just the another node thats connected to a larger parent node
        id[root] = id[id[root]];   //path compression
        root = id[root]; //
    }
    return root; //return the node that is the root
}
bool UnionFind::connected(int first, int second) { //checks to see if two nodes are connected
    bool check = (root(first) == root(second)); //this is the bool variable that will be returned to show whether or not they are connected
    if(check == false) { //prints out an F if they are not connected
        cout << "F" << endl;
    }
    else if(check ==true) { //prints out a T if they are connected
        cout << "T" << endl;
    }
    return check;
}
void UnionFind::connect(int first, int second) { //connects two nodes that were not previously connected
    int i = root(first); //finds the root of the first node
    int j = root(second); // finds the root of the second node
    if(temp[i] < temp[j]) { // uses a temporary array to perform weighted quick union
        id[i] = j; 
        temp[j] += temp[i];
    }
    else { // the weighted quick union is not applicable so simply unite the two nodes.
        id[j] = i;
        temp[i] += temp[j];
    }
}