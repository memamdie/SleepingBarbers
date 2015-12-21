#include "bTreeNode.h"
// The main function that inserts a new key in this B-Tree
void BTree::insert(string key) {
    // If tree is empty
    if (root == NULL) {
        // Allocate memory for root
        root = new BTreeNode(min_deg, true);
        root->keys[0] = key;  // Insert key
        root->num_keys = 1;  // Update number of keys in root
    }
    else { // If tree is not empty
        // If root is full, then tree grows in height
        if (root->num_keys == 2*min_deg-1) {
            // Allocate memory for new root
            BTreeNode *newNode = new BTreeNode(min_deg, false);
            
            // Make old root as child of new root
            newNode->child_ptr[0] = root;
            
            // Split the old root and move 1 key to the new root
            newNode->splitChild(0, root);
            
            // New root has two children now.  Decide which of the
            // two children is going to have new key
            int i = 0;
            if (newNode->keys[0] < key)
                i++;
            newNode->child_ptr[i]->insertNonFull(key);
            
            // Change root
            root = newNode;
        }
        else  // If root is not full, call insertNonFull for root
            root->insertNonFull(key);
    }
}
/*
void BTree::remove(string key)
{
    if (!root)
    {
        cout << "The tree is empty\num_keys";
        return;
    }
 
    // Call the remove function for root
    root->remove(key);
 
    // If the root node has 0 keys, make its first child as the new root
    //  if it has a child, otherwise set root as NULL
    if (root->num_keys==0)
    {
        BTreeNode *tmp = root;
        if (root->isLeaf)
            root = NULL;
        else
            root = root->child_ptr[0];
 
        // Free the old root
        delete tmp;
    }
    return;
}*/
