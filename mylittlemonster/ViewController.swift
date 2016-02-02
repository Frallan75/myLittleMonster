//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Francisco Claret on 28/01/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var penalty1: UIImageView!
    @IBOutlet weak var penalty2: UIImageView!
    @IBOutlet weak var penalty3: UIImageView!

    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE_ALPHA: CGFloat = 1.0
    let MAX_PENALTIES: Int = 3
    
    var currentPenaltyCount: Int = 0
    var timer: NSTimer!
    var monsterNeed: UInt32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnTarget:", name: "onTargetDropped", object: nil)
        
        penalty1.alpha = DIM_ALPHA
        penalty2.alpha = DIM_ALPHA
        penalty3.alpha = DIM_ALPHA
        
        itemDroppedOnTarget(0)
        startTimer()
    }
    
    func itemDroppedOnTarget(notif: AnyObject) {
        
        let rand = arc4random_uniform(2)
        
        if rand == 0 {
            foodImg.alpha = OPAQUE_ALPHA
            foodImg.userInteractionEnabled = true
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
        }
        
        if rand == 1 {
            heartImg.alpha = OPAQUE_ALPHA
            heartImg.userInteractionEnabled = true
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
        }
        startTimer()
    }
    
    func startTimer() {
        
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
        
    }
    
    func changeGameState() {
        
        currentPenaltyCount++
        
        if currentPenaltyCount == 1 {
            penalty1.alpha = OPAQUE_ALPHA
        }
        else if currentPenaltyCount == 2 {
            penalty2.alpha = OPAQUE_ALPHA
        }
        else if currentPenaltyCount >= 3 {
            penalty3.alpha = OPAQUE_ALPHA
        }
        else {
            penalty1.alpha = DIM_ALPHA
            penalty2.alpha = DIM_ALPHA
            penalty3.alpha = DIM_ALPHA
        }
        
        if currentPenaltyCount >= MAX_PENALTIES {
            gameOver()
        }
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeadAnimation()
        monsterImg.stopAnimating()
    }
}