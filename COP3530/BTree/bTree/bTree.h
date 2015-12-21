
#include "bTreeNode.h"

class bTree {
private:
   bTreeNode *root;
   int size, min_deg;
public:
    //Constructor
    bTree(int);
    
    //Destructor
    ~bTree();
    
    //Inserts the value pair into the tree
    void insert(string key, string value);
    
    // Searches for the key in the tree, if found, it returns
    // true else returns false.
    // If the key is found, it stores the value in the *value variable
    bool find(string key, string *value);
    
    //Searches for the key and deletes it. Returns true if deletion was
    //successful, returns false if the key wasn't found
    bool delete_key(string key);
    
    // concatenates the contents of the tree from an inorder traversal
    // into an output stream with each string item followed by a
    // newline character in the stream
    string toStr();
};