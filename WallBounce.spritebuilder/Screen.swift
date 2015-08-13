//
//  Screen.swift
//  WallBounce
//
//  Created by Declan sidoti on 8/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Screen: CCNode {
    weak var retryLose: CCButton!
    
    func retry(){
        let gamePlay = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(gamePlay)
        
    }
}
