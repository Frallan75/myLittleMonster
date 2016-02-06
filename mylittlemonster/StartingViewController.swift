//
//  StartingViewController.swift
//  mylittlemonster
//
//  Created by Francisco Claret on 03/02/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit

class StartingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func monster1Pressed(sender: UIButton) {
        performSegueWithIdentifier("moveToGame", sender: 0)
        
    }
    
    @IBAction func monster2Pressed(sender: AnyObject) {
        performSegueWithIdentifier("moveToGame", sender: 1)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "moveToGame" {
            if let destinationVC = segue.destinationViewController as? ViewController {
                destinationVC.selectedMonster = sender as! Int
            }
        }
    }
}
