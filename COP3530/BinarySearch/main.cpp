

#include "search.h"

int main(int argc, const char * argv[]) {
    string inputFile;
    bool answer;
    ofstream outfile;
	//Asks user what file they want to read in
    cout << "What file would you like to read in?" << endl;
    cin >> inputFile;
    size_t leng = inputFile.length();
	//creates an output file with the same beginning but instead of the file ending in .in the file ends in .out
    outfile.open((inputFile.substr(0,leng-3)+ ".out").c_str());
    //now that we have the file name call the constructor to traverse the file and store the numbers
	Search *mySearch = new Search(inputFile);
	//number used to iterate through the array of numbers to be searched through
    int searches = mySearch -> numOfSearches();
    clock_t startLinear, startBinary, finishLinear, finishBinary;
    double elapsed_time_linear, elapsed_time_binary;
    outfile << "Linear Search:\n";
	//start the clock
    startLinear = clock();
	//search for each element linearly through the array
    for(int i = 0; i < searches; i++) {
		//if the element was found answer will be true otherwise it will be false
        answer = mySearch -> linear(i);
		//write the proper value to the output file
        if(answer) {
            outfile << "Yes\n";
        }
        else {
            outfile << "No\n";
        }
    }
	//end the clock
    finishLinear = clock();
    elapsed_time_linear = (double)(finishLinear - startLinear)/CLOCKS_PER_SEC;
	//write the clock time to the output file
    outfile << elapsed_time_linear << "\n";
    
    outfile << "Binary Search:\n";
	//start the clock for the binary search
    startBinary = clock();
	//again searches through but this time in a binary fashion
    for(int i = 0; i < searches; i++) {
        answer = mySearch -> binary(i);
		//writes the appropriate response to the output file
        if(answer) {
            outfile << "Yes\n";
        }
        else {
            outfile << "No\n";
        }
    }
    //ends the clock
    finishBinary = clock();
    elapsed_time_binary = (double) (finishBinary - startBinary)/CLOCKS_PER_SEC;
   	//write the time taken to conduct the binary search to the output file
	outfile << elapsed_time_binary << "\n";
    outfile.close();
    return 0;
}
