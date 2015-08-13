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
        setUpGameCenter()
        
    }
    func deezLeaderBoard() {
        showLeaderboard()
    }
    func setUpGameCenter() {
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
    }
    

    // MARK: - Other function
    
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
    
}
extension StartScreen: GKGameCenterControllerDelegate {
    func showLeaderboard() {
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
