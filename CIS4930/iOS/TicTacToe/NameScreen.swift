//
//  NameScreen.swift
//  attempt3
//
//  Created by Michelle Emamdie on 9/13/15.
//  Copyright © 2015 Michelle Emamdie. All rights reserved.
//

import UIKit

var player1Name = ""
var player2Name = ""
var scores = [String: Int]()
var option = 2
class NameScreen: UIViewController {

    @IBOutlet var name1: UITextField!
    @IBOutlet var name2: UITextField!
    @IBOutlet var player2Label: UILabel!
    @IBOutlet var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
 
    @IBAction func storeName1(sender: AnyObject) {
        player1Name = name1.text!
    }
    
    @IBAction func storeName2(sender: AnyObject) {
        player2Name = name2.text!
        nextButton.enabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
