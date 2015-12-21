/* 
 * File:   bTreeNode.cpp
 * Author: memamdie
 * 
 * Created on April 9, 2015, 12:47 PM
 */

#include "bTreeNode.h"
//Creates a node using the minimum degree
bTreeNode::bTreeNode(int min, bool leaf) {
    min_deg = min;
    isLeaf = leaf;
    keys = new string[2*min_deg-1];
    values = new string[2*min_deg-1];
    child_ptr = new bTreeNode *[2*min_deg];
    num_keys = 0;
    output = "";
}
// concatenates the contents of the tree from an inorder traversal
// into an output stream with each string item followed by a
// newline character in the stream
string bTreeNode::traverse() {
    string info = "";
    int i;
    for (i = 0; i < num_keys; i++){
        if (!isLeaf){
            info += child_ptr[i]->traverse();
        }
        info += keys[i] + "\n";
    }
    if (!isLeaf){
        info += child_ptr[i]->traverse();
    }
    return info;
}
//called when a node is full and needs to be split to accommodate an addition to the tree
void bTreeNode::split(int index, bTreeNode *fullNode){
	bTreeNode *newNode = new bTreeNode(fullNode->min_deg, fullNode->isLeaf);// Create a new node which is going to store (min_deg-1) keys of fullNode

	newNode->num_keys = min_deg - 1;

	// Copy keys of fullNode to newNode
	for (int j = 0; j < min_deg - 1; j++)  {
		newNode->keys[j] = fullNode->keys[j + min_deg];
		newNode->values[j] = fullNode->values[j + min_deg];
	}

	// Copy the children of fullNode to newNode
	if (fullNode->isLeaf == false){
		for (int j = 0; j < min_deg; j++) {
                    newNode->child_ptr[j] = fullNode->child_ptr[j + min_deg];
                }
	}
	// Change the number of keys in fullNode
	fullNode->num_keys = min_deg - 1;

	// Shift everything in the child_ptr array to the right one place
	for (int j = num_keys; j >= index + 1; j--) {
		child_ptr[j + 1] = child_ptr[j];
        }
	// Set the new child equal to the new node so that it knows who it's parent is 
	child_ptr[index + 1] = newNode;

	// move all keys and values over one position while the count is less than the index position 
	for (int j = num_keys - 1; j >= index; j--) {
		keys[j + 1] = keys[j];
		values[j + 1] = values[j];
	}
	// Copy the initial middle key and value of fullNode to this node
	keys[index] = fullNode->keys[min_deg - 1];
	values[index] = fullNode->values[min_deg - 1];

	// Increment number of keys
	num_keys++;
}
void bTreeNode::insertNode(string key, string value) {
	// Start at the rightmost element
	int i = num_keys - 1;

	// Checks to see if you are adding a leaf node
	if (isLeaf){
		// figure out where the key needs to be inserted and shift everything over to the right while you havent found where it needs to be inserted
		while (i >= 0 && keys[i] > key){
			keys[i + 1] = keys[i];
                        values[i + 1] = values[i];
			i--;
		}
		// Insert the new key and value
		keys[i + 1] = key;
		values[i + 1] = value;
		num_keys = num_keys + 1;
	}
	else{
		// Find the child which is going to have the new key
		while (i >= 0 && keys[i] > key)
			i--;

		// See if the found child is full
		if (child_ptr[i + 1]->num_keys == 2 * min_deg - 1)
		{
			// If the child is full, then split it
			split(i + 1, child_ptr[i + 1]);

			// After split, the middle key of child_ptr[i] goes up and
			// child_ptr[i] is splitted into two.  See which of the two
			// is going to have the new key
			if (keys[i + 1] < key)
				i++;
		}
		child_ptr[i + 1]->insertNode(key, value);
	}
}
//Looks for a certain key value in the array so that it can return the memory location of the value
bool bTreeNode::search(string key, string *value) {
    int i = 0;
    //iterate through until you find where the key would possibly fit in the tree
    while (i < num_keys && key > keys[i]){
        i++;
    }
    //check if the key is at this position
    if (i != num_keys && !keys[i].compare(key)){
        *value = values[i];
        return true;
    }
    //if this value is a leaf return false
    if (isLeaf){
        return false;
    }
    //recursively travel through the tree
    return child_ptr[i]->search(key, value);
}
// A function to remove the key key from the sub-tree rooted with this node
void bTreeNode::remove(string key){
	int index = 0;
	while (index<num_keys && keys[index] < key)
		++index;
 
    // The key to be removed is present in this node
    if (index < num_keys && keys[index] == key){
 
        // If the node is a leaf, remove it and shift everything back a position therefore overwriting the old values
        if (isLeaf) {
            for (int i=index+1; i<num_keys; ++i) {
                keys[i-1] = keys[i];
                values[i-1] = values[i];
            }
            
            // Reduce the count of keys
            num_keys--;
            
            return;
        }
        //otherwise it is not a leaf so we must consider everything under this node
        else {
            string key = keys[index];
            string value = values[index];
            
            // if there are keys in the child pointer array get the values and overwrite what is at the index position with what getPred and getPredVal return
            if (child_ptr[index]->num_keys >= min_deg) {
                string pred = getPred(index);
                string predVal = getPredVal(index);
                keys[index] = pred;
                values[index] = predVal;
                child_ptr[index]->remove(pred);
            }
            
            // Check to see if the next position meets the  same requirements and if it does you must overwrite with the succeeding values
            else if  (child_ptr[index+1]->num_keys >= min_deg){
                string succ = getSucc(index);
                string succVal = getSuccVal(index);
                keys[index] = succ;
                values[index] = succVal;
                child_ptr[index+1]->remove(succ);
            }
            
            // otherwise neither of the children have many keys so they can be removed and then you can remove what is at the child pointer at the given index position
            else{
                merge(index);
                child_ptr[index]->remove(key);
            }
            return;
        }
    }
    //this means the key is not in the tree    
    else{
 
        //the key is not present in tree
        if (isLeaf){
            return;
        }

        // The key to be removed is rooted in a subtree
        bool flag = ((index==num_keys)? true : false );
 
        // fill the child where the key belongs
        if (child_ptr[index]->num_keys < min_deg)
            fill(index);
 
        // Determines if the past child has been merged and removes the child at the appropriate index position
        if (flag && index > num_keys)
            child_ptr[index-1]->remove(key);
        else
            child_ptr[index]->remove(key);
    } 
}
  
// A function to get predecessor of keys[index]
string bTreeNode::getPred(int index){
    // Move to the right until isLeaf returns true
    bTreeNode *cur=child_ptr[index];
    while (!cur->isLeaf)
        cur = cur->child_ptr[cur->num_keys];
 
    // Recurse through the method until isLeaf == true
    return cur->keys[cur->num_keys-1];
}
string bTreeNode::getPredVal(int index) {
    // Move to the right until isLeaf returns true
    bTreeNode *cur=child_ptr[index];
    while (!cur->isLeaf)
        cur = cur->child_ptr[cur->num_keys];
 
    // Recurse through the method until isLeaf == true
    return cur->values[cur->num_keys-1];
}
string bTreeNode::getSucc(int index){
    // move to the left until index + 1 isLeaf == true
    bTreeNode *cur = child_ptr[index+1];
    while (!cur->isLeaf)
        cur = cur->child_ptr[0];
 
    // Return the first key of the isLeaf
    return cur->keys[0];
}
string bTreeNode::getSuccVal(int index){
 
    // Keep moving the left most node starting from child_ptr[index+1] until we reach a isLeaf
    bTreeNode *cur = child_ptr[index+1];
    while (!cur->isLeaf)
        cur = cur->child_ptr[0];
 
    // Return the first key of the isLeaf
    return cur->values[0];
} 
// A function to fill child's child pointers
void bTreeNode::fill(int index){
 
    // if the index-1 position has enough space, borrow one of their child pointers
    if (index!=0 && child_ptr[index-1]->num_keys>=min_deg)
        borrowPrev(index);
 
    // otherwise take from the other side of the index position
    else if (index!=num_keys && child_ptr[index+1]->num_keys>=min_deg)
        borrowNext(index);
 
    // Merge child and sibling
    else{
        if (index != num_keys)
            merge(index);
        else
            merge(index-1);
    }
    return;
}
 
//move child pointers forward one place
void bTreeNode::borrowPrev(int index){
 
    bTreeNode *child=child_ptr[index];
    bTreeNode *sibling=child_ptr[index-1];
     // Moving all keys and values in child_ptr one step ahead
    for (int i=child->num_keys-1; i>=0; --i) {
        child->keys[i+1] = child->keys[i];
        child->values[i+1] = child->values[i];
    }
 
    //move all its child pointers one step ahead
    if (!child->isLeaf){
        for(int i=child->num_keys; i>=0; --i) {
            child->child_ptr[i+1] = child->child_ptr[i];
        }
    }
 
    // Setting child's first key equal to keys[index-1] from the current node
    child->keys[0] = keys[index-1];
    child->values[0] = values[index-1];
 
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
 
//move child pointer back one place
void bTreeNode::borrowNext(int index){
 
    bTreeNode *child=child_ptr[index];
    bTreeNode *sibling=child_ptr[index+1];
 
    child->keys[(child->num_keys)] = keys[index];
    child->values[(child->num_keys)] = values[index];
 
    // insert the first child pointer of sibling's to child's child pointer
    if (!(child->isLeaf))
        child->child_ptr[(child->num_keys)+1] = sibling->child_ptr[0];
 
    //The first key from sibling is inserted into keys[index]
    keys[index] = sibling->keys[0];
    values[index] = sibling->values[0];
 
    // Move sibling keys and values back one position
    for (int i=1; i<sibling->num_keys; ++i) {
        sibling->keys[i-1] = sibling->keys[i];
        sibling->values[i-1] = sibling->values[i];
    }
 
    // Move child pointers back one position
    if (!sibling->isLeaf){
        for(int i=1; i<=sibling->num_keys; ++i)
            sibling->child_ptr[i-1] = sibling->child_ptr[i];
    }
 
    // increase the number of keys in child but decrement sibling keys
    child->num_keys += 1;
    sibling->num_keys -= 1;
 
    return;
}
 
// Merge two index positions within the child_ptr array
void bTreeNode::merge(int index){
    bTreeNode *child = child_ptr[index];
    bTreeNode *sibling = child_ptr[index+1];
 
    // Move the key and value backward one place in the child array 
    child->keys[min_deg-1] = keys[index];
    child->values[min_deg-1] = values[index];
 
    // Copy the keys and values from the sibling to the child
    for (int i=0; i<sibling->num_keys; ++i) {
        child->keys[i+min_deg] = sibling->keys[i];
        child->values[i+min_deg] = sibling->values[i];
    }
 
    //Move child pointers to the right one index position 
    if (!child->isLeaf){
        for(int i=0; i<=sibling->num_keys; ++i) {
            child->child_ptr[i+min_deg] = sibling->child_ptr[i];
        }
    }
 
    // Fill the gap after moving the child pointers
    for (int i=index+1; i<num_keys; ++i) {
        keys[i-1] = keys[i];
        values[i-1] = values[i];
    }
 
    // Moving the child pointers after (index+1) in the current node one
    // step before
    for (int i=index+2; i<=num_keys; ++i) {
        child_ptr[i-1] = child_ptr[i];
    }
 
    // Updating the number of keys for the child
    child->num_keys += sibling->num_keys+1;
    num_keys--;
 
    // delete the sibling because you no longer need it
    delete(sibling);
    return;
}
bTreeNode::~bTreeNode() {
    delete [] keys;
    delete [] values;
}
