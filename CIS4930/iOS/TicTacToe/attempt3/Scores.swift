//
//  Scores.swift
//  attempt3
//
//  Created by Michelle Emamdie on 9/13/15.
//  Copyright © 2015 Michelle Emamdie. All rights reserved.
//

import UIKit

var typeList = Array(scores.keys)

class Scores: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //Declares how many sections we want
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //Declares how many rows we want
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }

    //Contents of each cell
    //automatically called by the other tableView function
    //returns a cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        //note I did not check for nil values. Something has to be really broken for these to be nil.
       let row = indexPath.row   //get the array index from the index path
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as UITableViewCell  //make the cell
        let myRowKey = Array(scores.keys)[row]//the dictionary key
        print("My row key is: \(myRowKey)")
        cell.textLabel!.text! = myRowKey
        let myRowData = scores[myRowKey]  //the dictionary value
        print("My row data is: \(myRowData)")
        cell.detailTextLabel!.text! = String(myRowData!)
        return cell
        
    }
    
}
