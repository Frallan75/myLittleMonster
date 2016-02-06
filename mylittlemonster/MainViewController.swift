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
    @IBOutlet weak var obedience: DragImg!
    @IBOutlet weak var penalty1: UIImageView!
    @IBOutlet weak var penalty2: UIImageView!
    @IBOutlet weak var penalty3: UIImageView!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var bgImg: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE_ALPHA: CGFloat = 1.0
    let MAX_PENALTIES: Int = 3
    
    var currentPenaltyCount: Int = 0
    var timer: NSTimer!
    var monsterHappy: Bool = true
    var monsterNeed: UInt32 = 0
    var currentHappyItem: UInt32 = 0
    var selectedMonster: Int = 0
    var monster: Monster!
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("right here")
        
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
        
        createMonster(selectedMonster)
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        obedience.dropTarget = monsterImg
        
        restartButton.hidden = true

        resetSkulls()
        resetFoodHeart()
        startTimer()
    }
    
    func createMonster(selectedMonster: Int) {
        
        if selectedMonster == 0 {
            monster = Monster(timerToSkull: 1.0, fileName: "monster1", bgFileName: "monster1bg")
        }
        else if selectedMonster == 1 {
            monster = Monster(timerToSkull: 5.0, fileName: "monster2", bgFileName: "monster2bg")
        }
        else {
            print("Error, no monster selected")
        }
        monsterImg.playIdleAnimation(monster.fileName)
        bgImg.image = UIImage(named: "\(monster.bgFileName)")
    }
    
    func itemDroppedOnTarget(notif: AnyObject) {
        
        monsterHappy = true
        
        if currentHappyItem == 1 {
            sfxHeart.play()
        }
        else if currentHappyItem == 0 {
            sfxBite.play()
        }
        else if currentHappyItem == 2 {
            sfxDeath.play()
        }
        resetFoodHeart()
        startTimer()
    }
    
    func resetFoodHeart() {
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        obedience.alpha = DIM_ALPHA
        obedience.userInteractionEnabled = false
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
        timer = NSTimer.scheduledTimerWithTimeInterval(monster!.timerToSkull, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
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
            
            let rand = arc4random_uniform(3)
            
            switch rand {
            case 0:
                foodImg.alpha = OPAQUE_ALPHA
                foodImg.userInteractionEnabled = true
                heartImg.alpha = DIM_ALPHA
                heartImg.userInteractionEnabled = false
                obedience.alpha = DIM_ALPHA
                obedience.userInteractionEnabled = false
            case 1:
                heartImg.alpha = OPAQUE_ALPHA
                heartImg.userInteractionEnabled = true
                foodImg.alpha = DIM_ALPHA
                foodImg.userInteractionEnabled = false
                obedience.alpha = DIM_ALPHA
                obedience.userInteractionEnabled = false
            case 2:
                obedience.alpha = OPAQUE_ALPHA
                obedience.userInteractionEnabled = true
                foodImg.alpha = DIM_ALPHA
                foodImg.userInteractionEnabled = false
                heartImg.alpha = DIM_ALPHA
                heartImg.userInteractionEnabled = false
            default:
                print("Error, game state missing")
            }
            currentHappyItem = rand
            monsterHappy = false
        }
    }
    
    func gameOver() {
        timer.invalidate()
        sfxDeath.play()
        monsterImg.playDeadAnimation(monster.fileName)
        restartButton.hidden = false
        resetFoodHeart()
    }
    
    @IBAction func restartButtonPressed(sender: UIButton) {
        
        monsterHappy = true
        currentPenaltyCount = 0
        restartButton.hidden = true
        resetFoodHeart()
        resetSkulls()
        startTimer()
        self.navigationController?.popViewControllerAnimated(true)
    }
}