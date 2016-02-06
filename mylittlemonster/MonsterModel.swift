//
//  monsterModel.swift
//  mylittlemonster
//
//  Created by Francisco Claret on 04/02/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import UIKit

struct Monster {
    
    private var _timerToSkull: Double
    private var _fileName: String
    private var _bgFileName: String
    
    var timerToSkull: Double {
        get {
            return _timerToSkull
        }
    }
    
    var fileName: String {
        get {
            return _fileName
        }
    }
    
    var bgFileName: String {
        get {
            return _bgFileName
        }
    }
    
    init(timerToSkull: Double, fileName: String, bgFileName: String) {
        self._fileName = fileName
        self._timerToSkull = timerToSkull
        self._bgFileName = bgFileName
    }
}