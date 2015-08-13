//
//  GameManager.swift
//  WallBounce
//
//  Created by Declan sidoti on 8/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
import GameKit
class GameManager {
   
    static var sharedInstance = GameManager()
    
    // MARK: - Properties
    var endingLocations: [CGPoint] = []

    var levelNumber: Int = NSUserDefaults.standardUserDefaults().integerForKey("DeezLevel") ?? 0 {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(levelNumber, forKey: "DeezLevel")
            NSUserDefaults.standardUserDefaults().synchronize()
            reportHighScoreToGameCenter()
        }
    }
    func reportHighScoreToGameCenter(){
        var scoreReporter = GKScore(leaderboardIdentifier: "BounzyLeaderboard12345")
        scoreReporter.value = Int64(levelNumber)
        var scoreArray: [GKScore] = [scoreReporter]
        GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
            if error != nil {
                println("Game Center: Score Submission Error")
            }
        })
    }
    
    // MARK: - Generate random positions
    func createRandomShit(#viewSize: CGSize) {
        
        for i in 1..<50 {
            
            let randomX = CGFloat(arc4random_uniform(UInt32(viewSize.width)))
            let randomY = CGFloat(arc4random_uniform(UInt32(viewSize.height)))
            let randomPos = ccp(randomX, randomY)
            endingLocations.append(randomPos)
    
        }
        
    }

    
}
