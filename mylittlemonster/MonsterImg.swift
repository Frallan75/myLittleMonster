//
//  MonsterImg.swift
//  mylittlemonster
//
//  Created by Francisco Claret on 30/01/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import UIKit


class MonsterImg: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func playIdleAnimation(fileName: String) {
        self.image = UIImage(named: "\(fileName)idle1")
        self.animationImages = nil
        var idleImageArray = [UIImage]()
        
        for var x = 1;x <= 4; x++ {
            let img = UIImage(named: "\(fileName)idle\(x).png")
            idleImageArray.append(img!)
        }
        animate(idleImageArray, duration: 0.8, repetitions: 0)
        
    }
    
    func playDeadAnimation(fileName: String) {
        
        self.image = UIImage(named: "\(fileName)dead5.png")
        self.animationImages = nil
        var deadImageArray = [UIImage]()
        
        for var x = 1; x <= 5; x++ {
            let img = "\(fileName)dead\(x).png"
            deadImageArray.append(UIImage(named: img)!)
        }
        animate(deadImageArray, duration: 1.0, repetitions: 1)
    }
    
    func animate(imageArrayToPlay: [UIImage], duration: Double, repetitions: Int) {
        
            self.animationImages = imageArrayToPlay
            self.animationDuration = duration
            self.animationRepeatCount = repetitions
            self.startAnimating()
    }
}