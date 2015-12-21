//
//  main.cpp
//  FloydWarshall
//

#include <iostream>
#include <sstream>
#include <vector>
using namespace std;

void printCost(vector<vector<int> >& graph, int nodes){
	//Print out the graph to make sure it is entered correctly
    cout << "This is the cost matrix:\n";
	for (int i = 1; i < nodes; i++) {
		for (int j = 1; j < nodes; j++) {
			cout << graph[i][j] << "\t";
		}
		cout << endl;
	}
}
void printPath(vector<vector<string> >& path, int nodes){
    cout << "This is the path matrix:\n";
    for (int i = 1; i < nodes; i++) {
        for (int j = 1; j < nodes; j++) {
            if(path[i][j].empty()) cout << "NONE" << "\t\t\t";
            else cout << path[i][j] << "\t\t\t";
        }
        cout << endl;
    }
}
int main(int argc, const char * argv[]) {
	int nodes, edges, queries, x, y, cost, start, end;
	cin >> nodes >> edges >> queries;
    //Create two 2D arrays.
    //graph stores the cost of getting from one node to another.
    //nextNode is used for path reconstruction, and holds what the next node in the path is.
    int graph[nodes][nodes];
    int nextNode[nodes][nodes];
    
    //Initializes both arrays to be filled with an arbitrarily large number.
    //This lets the program know when there isn't a path.
    //Please note that, since we are expected to have the numbering of the nodes
    //start at 1 rather than 0, all of my inputs into the arrays will
    //be the given number minus 1.
    for (int i = 1; i <= nodes; i++){
        for (int j = 1; j <= nodes; j++){
            D[i-1][j-1] = 999999999;
            nextNode[i-1][j-1] = 999999999;
        }
    }
    
    //Sets the cost of going from a node to itself as being 0.
    for (int i = 1; i <= nodes; i++){
        D[i-1][i-1] = 0;
    }
    
    //Takes in the edges and the cost of going from one node to another.
    for (int i = 1; i <= edges; i++){
        //Takes in the node the edge is coming from, the node it is going to,
        //and the cost of the edge.
        int n1;
        int n2;
        int cost;
        cin >> n1;
        cin >> n2;
        cin >> cost;
        
        //Sets the appropriate costs in the D array.
        D[n1-1][n2-1] = cost;
        //Sets the path going from n1 to n2 in the nextNode array.
        nextNode[n1-1][n2-1] = n2;
    }
    
    //The Floyd-Warshall algorithm.
    for (int k = 1; k <= nodes; k++){
        for (int i = 1; i <= nodes; i++){
            for (int j = 1; j <= nodes; j++){
                //If the path using two edges is less than the path using one edge...
                if (D[i-1][j-1] > (D[i-1][k-1] + D[k-1][j-1])){
                    //Set the cost of the edge to be the lesser cost.
                    D[i-1][j-1] = (D[i-1][k-1] + D[k-1][j-1]);
                    //Have the nextNode array go to the other node
                    //before going to the final node. This ensures proper path reconstruction.
                    nextNode[i-1][j-1] = nextNode[i-1][k-1];
                }
            }
        }
    }
    
    //Go through all of the queries.
    for (int i = 1; i <= queries; i++){
        int n1;
        int n2;
        cin >> n1;
        cin >> n2;
        
        //The cost of going from a node to itself is 0.
        if (n1 == n2){
            cout << "cost = 0" << endl << n1 << "-" << n2 << endl;
        }
        //If the path or cost is a very large number, then there is no path.
        else if (nextNode[n1-1][n2-1] > 9999999 || D[n1-1][n2-1] > 9999999){
            cout << "NO PATH" << endl;
        }
        //Else if there is a path...
        else{
            //Print out the cost.
            cout << "cost = " << D[n1-1][n2-1] << endl;
            //Print out the first node and a dash.
            cout << n1 << "-";
            
            //Go through the nextNode array, changing the value of n1 until
            //you get to n2 by following the path.
            while (n1 != n2){
                //Set n1 equal to the next node in the path.
                n1 = nextNode[n1-1][n2-1];
                //If the final node has been reached, print it out with a new line.
                if (n1 == n2){
                    cout << n1 << endl;
                }
                //If the final node hasn't been reached, print out the node and a dash.
                else{
                    cout << n1 << "-";
                }
            }
        }
    }
}