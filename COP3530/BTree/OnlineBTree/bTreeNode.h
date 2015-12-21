// C++ program for B-Tree insertion
#include<iostream>
using namespace std;
 
// A BTree node
class BTreeNode
{
    string *keys;  // An array of keys
    int min_deg;      // Minimum degree (defines the range for number of keys)
    BTreeNode **child_ptr; // An array of child pointers
    int num_keys;     // Current number of keys
    bool isLeaf; // Is true when node is isLeaf. Otherwise false
 
public:
 
    BTreeNode(int _t, bool _leaf);   // Constructor
 
    // A function to traverse all nodes in a subtree rooted with this node
    void traverse();
 
    // A function to search a key in subtree rooted with this node.
    BTreeNode *search(string key);   // returns NULL if key is not present.
 
    // A function that returns the index of the first key that is greater
    // or equal to key
    int findKey(string key);
 
    // A utility function to insert a new key in the subtree rooted with
    // this node. The assumption is, the node must be non-full when this
    // function is called
    void insertNonFull(string key);
 
    // A utility function to split the child y of this node. i is index
    // of y in child array child_ptr[].  The Child y must be full when this
    // function is called
    void splitChild(int i, BTreeNode *y);
 
    // A wrapper function to remove the key key in subtree rooted with
    // this node.
    void remove(string key);
 
    // A function to remove the key present in index-th position in
    // this node which is a isLeaf
    void removeFromLeaf(int index);
 
    // A function to remove the key present in index-th position in
    // this node which is a non-isLeaf node
    void removeFromNonLeaf(int index);
 
    // A function to get the predecessor of the key- where the key
    // is present in the index-th position in the node
    int getPred(int index);
 
    // A function to get the successor of the key- where the key
    // is present in the index-th position in the node
    int getSucc(int index);
 
    // A function to fill up the child node present in the index-th
    // position in the child_ptr[] array if that child has less than min_deg-1 keys
    void fill(int index);
 
    // A function to borrow a key from the child_ptr[index-1]-th node and place
    // it in child_ptr[index]th node
    void borrowFromPrev(int index);
 
    // A function to borrow a key from the child_ptr[index+1]-th node and place it
    // in child_ptr[index]th node
    void borrowFromNext(int index);
 
    // A function to merge index-th child of the node with (index+1)th child of
    // the node
    void merge(int index);
 
    // Make BTree friend of this so that we can access private members of
    // this class in BTree functions
    friend class BTree;
};
 
class BTree
{
    BTreeNode *root; // Pointer to root node
    int min_deg;  // Minimum degree
public:
 
    // Constructor (Initializes tree as empty)
    BTree(int _t)
    {
        root = NULL;
        min_deg = _t;
    }
 
    void traverse()
    {
        if (root != NULL) root->traverse();
    }
 
    // function to search a key in this tree
    BTreeNode* search(string key)
    {
        return (root == NULL)? NULL : root->search(key);
    }
 
    // The main function that inserts a new key in this B-Tree
    void insert(string key);
 
    // The main function that removes a new key in thie B-Tree
    void remove(string key);
 
};
