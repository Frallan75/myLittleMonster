//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Francisco Claret on 28/01/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var penalty1: UIImageView!
    @IBOutlet weak var penalty2: UIImageView!
    @IBOutlet weak var penalty3: UIImageView!
    @IBOutlet weak var restartButton: UIButton!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE_ALPHA: CGFloat = 1.0
    let MAX_PENALTIES: Int = 3
    
    var currentPenaltyCount: Int = 0
    var timer: NSTimer!
    var monsterHappy: Bool = true
    var monsterNeed: UInt32 = 0
    var currentHappyItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnTarget:", name: "onTargetDropped", object: nil)

        let musicUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: ".mp3")!)
        let sfxBiteUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: ".wav")!)
        let sfxHeartUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: ".wav")!)
        let sfxDeathUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: ".wav")!)
        let sfxSkullUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: ".wav")!)
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: musicUrl)
            try sfxBite = AVAudioPlayer(contentsOfURL: sfxBiteUrl)
            try sfxHeart = AVAudioPlayer(contentsOfURL: sfxHeartUrl)
            try sfxDeath = AVAudioPlayer(contentsOfURL: sfxDeathUrl)
            try sfxSkull = AVAudioPlayer(contentsOfURL: sfxSkullUrl)

        } catch let err as NSError {
            print(err.debugDescription)
        }
        musicPlayer.prepareToPlay()
        sfxSkull.prepareToPlay()
        sfxHeart.prepareToPlay()
        sfxDeath.prepareToPlay()
        sfxBite.prepareToPlay()
        musicPlayer.play()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        restartButton.hidden = true
        
        resetSkulls()
        resetFoodHeart()
        startTimer()
    }
    
    func itemDroppedOnTarget(notif: AnyObject) {
        monsterHappy = true
        
        if currentHappyItem == 1 {
            sfxHeart.play()
        }
        else if currentHappyItem == 0 {
            sfxBite.play()
        }
        
        resetFoodHeart()
        startTimer()
    }
    
    func resetFoodHeart() {
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
    }
    
    func resetSkulls() {
        penalty1.alpha = DIM_ALPHA
        penalty2.alpha = DIM_ALPHA
        penalty3.alpha = DIM_ALPHA
    }
    
    func startTimer() {
        
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            
            currentPenaltyCount++
            sfxSkull.play()
            switch currentPenaltyCount {
            case 1:
                penalty1.alpha = OPAQUE_ALPHA
            case 2:
                penalty2.alpha = OPAQUE_ALPHA
            case 3:
                penalty3.alpha = OPAQUE_ALPHA
            default:
                resetSkulls()
            }
            
            if currentPenaltyCount >= MAX_PENALTIES {
                gameOver()
            }
        }
        else if monsterHappy {
            
            let rand = arc4random_uniform(2)
            
            switch rand {
            case 0:
                foodImg.alpha = OPAQUE_ALPHA
                foodImg.userInteractionEnabled = true
                heartImg.alpha = DIM_ALPHA
                heartImg.userInteractionEnabled = false
            case 1:
                heartImg.alpha = OPAQUE_ALPHA
                heartImg.userInteractionEnabled = true
                foodImg.alpha = DIM_ALPHA
                foodImg.userInteractionEnabled = false
            default:
                print("Error, case state missing")
            }
            currentHappyItem = rand
            monsterHappy = false
        }
    }
    
    func gameOver() {
        timer.invalidate()
        sfxDeath.play()
        monsterImg.playDeadAnimation()
        restartButton.hidden = false
        resetFoodHeart()
    }
    
    @IBAction func restartButtonPressed(sender: UIButton) {
        
        monsterHappy = true
        currentPenaltyCount = 0
        restartButton.hidden = true
        
        monsterImg.playIdleAnimation()
        resetFoodHeart()
        resetSkulls()
        startTimer()
    }
}