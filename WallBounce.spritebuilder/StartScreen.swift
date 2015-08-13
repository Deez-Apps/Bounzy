//
//  StartScreen.swift
//  WallBounce
//
//  Created by Declan sidoti on 8/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit
import Foundation
import GameKit


class StartScreen: CCNode {
   
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var ball: CCSprite!
    var yes = true
    weak var title: CCNode!
    
    
    func didLoadFromCCB() {
        
        
        let random = CGFloat(arc4random_uniform(UInt32(500)))
        let randomYo = arc4random_uniform(UInt32(10))
        
        switch randomYo {
        case 0..<5:
            ball.physicsBody.velocity = ccp(-random,-random)
        case 5...10:
            ball.physicsBody.velocity = ccp(random,random)
        default:
            break
        }
    }

    func startGame() {
        
        self.removeFromParent()
        
    }
    
}
