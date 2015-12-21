#include "HashTable.h"

int main() {
	string input;
	int size;
    int op = 1;
    //Take in the size of the desired hash table
	cin >> size;
    //create a new hash table instance
	HashTable *table = new HashTable(size);
	while (op != 0) {
	cin >> op;
        //This op code means that the user wants to insert a value
		if (op == 1) {
            //Read in the value
			cin >> input;
		try {
            		//Call the insert method
        		 table -> insert(input);
		}
		catch (exception e) {
                    cout<<"Out of Memory Exception!"<<endl;
                }
		}
        //This op code means that the user wants to search for a value
		else if (op == 2) {
            //Read in the value to be searched for
            cin >> input;
            //if the method returns true print to the terminal yes it was found
            if(table -> find(input)) {
                cout << "Yes" << endl;
            }
            //otherwise print out no
            else {
                cout << "No" << endl;
            }
		}
		else {
			break;
		}
	}
    table -> ~HashTable();
	return 0;
}
