#include "bTreeNode.h"

#include <iostream>
#include <string>
using namespace std;
BTreeNode::BTreeNode(int t1, bool leaf1)
{
    // Copy the given minimum degree and isLeaf property
    min_deg = t1;
    isLeaf = leaf1;
 
    // Allocate memory for maximum number of possible keys
    // and child pointers
    keys = new string[2*min_deg-1];
    child_ptr = new BTreeNode *[2*min_deg];
 
    // Initialize the number of keys as 0
    num_keys = 0;
}
/*
// A utility function that returns the index of the first key that is
// greater than or equal to key
int BTreeNode::findKey(string key)
{
    int index=0;
    while (index<num_keys && keys[index] < key)
        ++index;
    return index;
}
 
// A function to remove the key key from the sub-tree rooted with this node
void BTreeNode::remove(string key)
{
    int index = findKey(key);
 
    // The key to be removed is present in this node
    if (index < num_keys && keys[index] == key)
    {
 
        // If the node is a isLeaf node - removeFromLeaf is called
        // Otherwise, removeFromNonLeaf function is called
        if (isLeaf)
            removeFromLeaf(index);
        else
            removeFromNonLeaf(index);
    }
    else
    {
 
        // If this node is a isLeaf node, then the key is not present in tree
        if (isLeaf)
        {
            cout << "The key "<< key <<" is does not exist in the tree\num_keys";
            return;
        }
 
        // The key to be removed is present in the sub-tree rooted with this node
        // The flag indicates whether the key is present in the sub-tree rooted
        // with the last child of this node
        bool flag = ( (index==num_keys)? true : false );
 
        // If the child where the key is supposed to exist has less that min_deg keys,
        // we fill that child
        if (child_ptr[index]->num_keys < min_deg)
            fill(index);
 
        // If the last child has been merged, it must have merged with the previous
        // child and so we recurse on the (index-1)th child. Else, we recurse on the
        // (index)th child which now has atleast min_deg keys
        if (flag && index > num_keys)
            child_ptr[index-1]->remove(key);
        else
            child_ptr[index]->remove(key);
    }
    return;
}
 
// A function to remove the index-th key from this node - which is a isLeaf node
void BTreeNode::removeFromLeaf (int index)
{
 
    // Move all the keys after the index-th pos one place backward
    for (int index=index+1; index<num_keys; ++index)
        keys[index-1] = keys[index];
 
    // Reduce the count of keys
    num_keys--;
 
    return;
}
 
// A function to remove the index-th key from this node - which is a non-isLeaf node
void BTreeNode::removeFromNonLeaf(int index)
{
 
    string key = keys[index];
 
    // If the child that precedes key (child_ptr[index]) has atleast min_deg keys,
    // find the predecessor 'pred' of key in the subtree rooted at
    // child_ptr[index]. Replace key by pred. Recursively delete pred
    // in child_ptr[index]
    if (child_ptr[index]->num_keys >= min_deg)
    {
        int pred = getPred(index);
        keys[index] = pred;
        child_ptr[index]->remove(pred);
    }
 
    // If the child child_ptr[index] has less that min_deg keys, examine child_ptr[index+1].
    // If child_ptr[index+1] has atleast min_deg keys, find the successor 'succ' of key in
    // the subtree rooted at child_ptr[index+1]
    // Replace key by succ
    // Recursively delete succ in child_ptr[index+1]
    else if  (child_ptr[index+1]->num_keys >= min_deg)
    {
        int succ = getSucc(index);
        keys[index] = succ;
        child_ptr[index+1]->remove(succ);
    }
 
    // If both child_ptr[index] and child_ptr[index+1] has less that min_deg keys,merge key and all of child_ptr[index+1]
    // into child_ptr[index]
    // Now child_ptr[index] contains 2t-1 keys
    // Free child_ptr[index+1] and recursively delete key from child_ptr[index]
    else
    {
        merge(index);
        child_ptr[index]->remove(key);
    }
    return;
}
 
// A function to get predecessor of keys[index]
int BTreeNode::getPred(int index)
{
    // Keep moving to the right most node until we reach a isLeaf
    BTreeNode *cur=child_ptr[index];
    while (!cur->isLeaf)
        cur = cur->child_ptr[cur->num_keys];
 
    // Return the last key of the isLeaf
    return cur->keys[cur->num_keys-1];
}
 
int BTreeNode::getSucc(int index)
{
 
    // Keep moving the left most node starting from child_ptr[index+1] until we reach a isLeaf
    BTreeNode *cur = child_ptr[index+1];
    while (!cur->isLeaf)
        cur = cur->child_ptr[0];
 
    // Return the first key of the isLeaf
    return cur->keys[0];
}
 
// A function to fill child child_ptr[index] which has less than min_deg-1 keys
void BTreeNode::fill(int index)
{
 
    // If the previous child(child_ptr[index-1]) has more than min_deg-1 keys, borrow a key
    // from that child
    if (index!=0 && child_ptr[index-1]->num_keys>=min_deg)
        borrowFromPrev(index);
 
    // If the next child(child_ptr[index+1]) has more than min_deg-1 keys, borrow a key
    // from that child
    else if (index!=num_keys && child_ptr[index+1]->num_keys>=min_deg)
        borrowFromNext(index);
 
    // Merge child_ptr[index] with its sibling
    // If child_ptr[index] is the last child, merge it with with its previous sibling
    // Otherwise merge it with its next sibling
    else
    {
        if (index != num_keys)
            merge(index);
        else
            merge(index-1);
    }
    return;
}
 
// A function to borrow a key from child_ptr[index-1] and insert it
// into child_ptr[index]
void BTreeNode::borrowFromPrev(int index)
{
 
    BTreeNode *child=child_ptr[index];
    BTreeNode *sibling=child_ptr[index-1];
 
    // The last key from child_ptr[index-1] goes up to the parent and key[index-1]
    // from parent is inserted as the first key in child_ptr[index]. Thus, the  loses
    // sibling one key and child gains one key
 
    // Moving all key in child_ptr[index] one step ahead
    for (int index=child->num_keys-1; index>=0; --index)
        child->keys[index+1] = child->keys[index];
 
    // If child_ptr[index] is not a isLeaf, move all its child pointers one step ahead
    if (!child->isLeaf)
    {
        for(int index=child->num_keys; index>=0; --index)
            child->child_ptr[index+1] = child->child_ptr[index];
    }
 
    // Setting child's first key equal to keys[index-1] from the current node
    child->keys[0] = keys[index-1];
 
    // Moving sibling's last child as child_ptr[index]'s first child
    if (!isLeaf)
        child->child_ptr[0] = sibling->child_ptr[sibling->num_keys];
 
    // Moving the key from the sibling to the parent
    // This reduces the number of keys in the sibling
    keys[index-1] = sibling->keys[sibling->num_keys-1];
 
    child->num_keys += 1;
    sibling->num_keys -= 1;
 
    return;
}
 
// A function to borrow a key from the child_ptr[index+1] and place
// it in child_ptr[index]
void BTreeNode::borrowFromNext(int index)
{
 
    BTreeNode *child=child_ptr[index];
    BTreeNode *sibling=child_ptr[index+1];
 
    // keys[index] is inserted as the last key in child_ptr[index]
    child->keys[(child->num_keys)] = keys[index];
 
    // Sibling's first child is inserted as the last child
    // into child_ptr[index]
    if (!(child->isLeaf))
        child->child_ptr[(child->num_keys)+1] = sibling->child_ptr[0];
 
    //The first key from sibling is inserted into keys[index]
    keys[index] = sibling->keys[0];
 
    // Moving all keys in sibling one step behind
    for (int index=1; index<sibling->num_keys; ++index)
        sibling->keys[index-1] = sibling->keys[index];
 
    // Moving the child pointers one step behind
    if (!sibling->isLeaf)
    {
        for(int index=1; index<=sibling->num_keys; ++index)
            sibling->child_ptr[index-1] = sibling->child_ptr[index];
    }
 
    // Increasing and decreasing the key count of child_ptr[index] and child_ptr[index+1]
    // respectively
    child->num_keys += 1;
    sibling->num_keys -= 1;
 
    return;
}
 
// A function to merge child_ptr[index] with child_ptr[index+1]
// child_ptr[index+1] is freed after merging
void BTreeNode::merge(int index)
{
    BTreeNode *child = child_ptr[index];
    BTreeNode *sibling = child_ptr[index+1];
 
    // Pulling a key from the current node and inserting it into (min_deg-1)th
    // position of child_ptr[index]
    child->keys[min_deg-1] = keys[index];
 
    // Copying the keys from child_ptr[index+1] to child_ptr[index] at the end
    for (int index=0; index<sibling->num_keys; ++index)
        child->keys[index+min_deg] = sibling->keys[index];
 
    // Copying the child pointers from child_ptr[index+1] to child_ptr[index]
    if (!child->isLeaf)
    {
        for(int index=0; index<=sibling->num_keys; ++index)
            child->child_ptr[index+min_deg] = sibling->child_ptr[index];
    }
 
    // Moving all keys after index in the current node one step before -
    // to fill the gap created by moving keys[index] to child_ptr[index]
    for (int index=index+1; index<num_keys; ++index)
        keys[index-1] = keys[index];
 
    // Moving the child pointers after (index+1) in the current node one
    // step before
    for (int index=index+2; index<=num_keys; ++index)
        child_ptr[index-1] = child_ptr[index];
 
    // Updating the key count of child and the current node
    child->num_keys += sibling->num_keys+1;
    num_keys--;
 
    // Freeing the memory occupied by sibling
    delete(sibling);
    return;
}*/

 
// A utility function to insert a new key in this node
// The assumption is, the node must be non-full when this
// function is called
void BTreeNode::insertNonFull(string key)
{
    // Initialize index as index of rightmost element
    int index = num_keys-1;
 
    // If this is a isLeaf node
    if (isLeaf == true)
    {
        // The following loop does two things
        // a) Finds the location of new key to be inserted
        // b) Moves all greater keys to one place ahead
        while (index >= 0 && keys[index] > key)
        {
            keys[index+1] = keys[index];
            index--;
        }
 
        // Insert the new key at found location
        keys[index+1] = key;
        num_keys = num_keys+1;
    }
    else // If this node is not isLeaf
    {
        // Find the child which is going to have the new key
        while (index >= 0 && keys[index] > key)
            index--;
 
        // See if the found child is full
        if (child_ptr[index+1]->num_keys == 2*min_deg-1)
        {
            // If the child is full, then split it
            splitChild(index+1, child_ptr[index+1]);
 
            // After split, the middle key of child_ptr[index] goes up and
            // child_ptr[index] is splitted into two.  See which of the two
            // is going to have the new key
            if (keys[index+1] < key)
                index++;
        }
        child_ptr[index+1]->insertNonFull(key);
    }
}
 
// A utility function to split the child fullNode of this node
// Note that fullNode must be full when this function is called
void BTreeNode::splitChild(int index, BTreeNode *fullNode)
{
    // Create a new node which is going to store (min_deg-1) keys
    // of fullNode
    BTreeNode *newNode = new BTreeNode(fullNode->min_deg, fullNode->isLeaf);
    newNode->num_keys = min_deg - 1;
 
    // Copy the last (min_deg-1) keys of fullNode to newNode
    for (int j = 0; j < min_deg-1; j++)
        newNode->keys[j] = fullNode->keys[j+min_deg];
 
    // Copy the last min_deg children of fullNode to newNode
    if (fullNode->isLeaf == false)
    {
        for (int j = 0; j < min_deg; j++)
            newNode->child_ptr[j] = fullNode->child_ptr[j+min_deg];
    }
 
    // Reduce the number of keys in fullNode
    fullNode->num_keys = min_deg - 1;
 
    // Since this node is going to have a new child,
    // create space of new child
    for (int j = num_keys; j >= index+1; j--)
        child_ptr[j+1] = child_ptr[j];
 
    // Link the new child to this node
    child_ptr[index+1] = newNode;
 
    // A key of fullNode will move to this node. Find location of
    // new key and move all greater keys one space ahead
    for (int j = num_keys-1; j >= index; j--)
        keys[j+1] = keys[j];
 
    // Copy the middle key of fullNode to this node
    keys[index] = fullNode->keys[min_deg-1];
 
    // Increment count of keys in this node
    num_keys = num_keys + 1;
}
 
// Function to traverse all nodes in a subtree rooted with this node
void BTreeNode::traverse()
{
    // There are num_keys keys and num_keys+1 children, travers through num_keys keys
    // and first num_keys children
    int index;
	string output = "";
    for (index = 0; index < num_keys; index++)
    {
        // If this is not isLeaf, then before printing key[index],
        // traverse the subtree rooted with child child_ptr[index].
        if (isLeaf == false)
            child_ptr[index]->traverse();
		cout << keys[index] << " ";
    }
 
    // Print the subtree rooted with last child
    if (isLeaf == false)
        child_ptr[index]->traverse();
}
 
// Function to search key key in subtree rooted with this node
BTreeNode *BTreeNode::search(string key)
{
    // Find the first key greater than or equal to key
    int index = 0;
    while (index < num_keys && key > keys[index])
        index++;
 
    // If the found key is equal to key, return this node
    if (keys[index] == key)
        return this;
 
    // If key is not found here and this is a isLeaf node
    if (isLeaf == true)
        return NULL;
 
    // Go to the appropriate child
    return child_ptr[index]->search(key);
}
