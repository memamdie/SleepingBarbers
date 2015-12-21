//
//  InitialView.swift
//  attempt3
//
//  Created by Michelle Emamdie on 9/13/15.
//  Copyright © 2015 Michelle Emamdie. All rights reserved.
//

import UIKit

var whoseTurn = 0
var count = 0

class InitialView: UIViewController {

    @IBOutlet var label2: UIButton!
    @IBOutlet var label3: UIButton!
    @IBOutlet var label4: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        label2.layer.cornerRadius = 5
        label3.layer.cornerRadius = 5
        label4.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }

    @IBAction func againstHuman(sender: AnyObject) {
        let player1 = Player.User1
        let player2 = Player.User2
        whoseTurn = 1
    }
    @IBAction func Instructions(sender: AnyObject) {
        let alertControl: UIAlertController = UIAlertController(title: "How to Play", message: "On this screen you can choose to start playing or you can choose to view scores. If you choose to play, you will be asked to enter the names of both of the players then press Next to begin playing. If you choose scores you will be able to see everyone who has played in the past and how many wins they have.", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel) {action -> Void in}
        alertControl.addAction(ok)
        self.presentViewController(alertControl, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
