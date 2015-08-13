//
//  StartScreen.swift
//  WallBounce
//
//  Created by Declan sidoti on 8/12/15.
//  Copyright (c) 2015 Declan Sidoti & Adrian Wisaksana. All rights reserved.
//

import UIKit
import GameKit


class StartScreen: CCNode {
   
    // MARK: - Properties
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var ball: CCSprite!
    weak var title: CCNode!
    
    // MARK: - DidLoadFromCCB
    
    func didLoadFromCCB() {
        
        loadRandomBall()
        
    }

    // MARK: - Other functions
    
    func startGame() {
        
        // remove main menu
        self.removeFromParent()
        
    }
    
    func loadRandomBall() {
        
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
    
    // MARK: - Show Leaderboard
    
    // insert code here
    
    // MARK - Info screen
    
    func showInfoScreen() {
        
        let infoScreen = CCBReader.load("InfoScreen") as! InfoScreen
        addChild(infoScreen)
        
    }
    
}
