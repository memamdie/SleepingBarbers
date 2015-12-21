#include "bTree.h"
//Default Constructor
bTree::bTree(int s) {
	root = NULL;
    size = s;
	if (s <= 3) min_deg = 2;
    else if(size % 2 == 0) min_deg = size/2;
    else min_deg = (size-1)/2;  
}
//Deconstructor
bTree::~bTree() {
    delete[] root;
}
//Takes in a key and value to be inserted to the tree
void bTree::insert(string key, string value) {
    //if the root is null then the whole tree is null so just insert the key and value
    if (root == NULL) {
        root = new bTreeNode(min_deg, true);
        root -> keys[0] = key;  
        root -> values[0] = value;   
        root -> num_keys = 1; 
    }
    //otherwise we have to try a bit harder
    else { 
        //checks to see if the node is full
        if (root -> num_keys == (2 * min_deg)-1) {
            //if it is full we will need to create a new node
            bTreeNode *newNode = new bTreeNode(min_deg, false);
            newNode -> child_ptr[0] = root;
            newNode -> split(0, root);
                int i = 0;
                if (newNode->keys[0] < key)
                        i++;
                        newNode->child_ptr[i]->insertNode(key, value);
                        root = newNode;
        }
        //if it is not full just call the insertNode method
        else{
            root -> insertNode(key, value);
        }
    }
}
// Searches for the key in the tree, if found, it returns
// true else returns false.
// If the key is found, it stores the value in the *value variable
bool bTree::find(string key, string *value) {
    if (root == NULL){
        return false;
    }
    else{
        return root->search(key, value);
    }
}
//Searches for the key and deletes it. Returns true if deletion was
//successful, returns false if the key wasn't found
bool bTree::delete_key(string key) {
    if (!root) {
        return false;
    }
	// call the remove method
	root->remove(key);

	// If the root node has 0 keys
        //make the node the child of the new root
	if (root -> num_keys == 0){
		bTreeNode *tmp = root;
		if (root->isLeaf) 
			root = NULL;
		else
			root = root->child_ptr[0];

		// Free the old root
		delete tmp;
	}
	return true;
}
// concatenates the contents of the tree from an inorder traversal
// into an output stream with each string item followed by a
// newline character in the stream
string bTree::toStr() {
    string output = "";
    if(root!= NULL) {
        output += root  ->  traverse();
    }    
    return output;
}
