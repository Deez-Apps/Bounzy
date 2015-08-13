//
//  GameManager.swift
//  WallBounce
//
//  Created by Declan sidoti on 8/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class GameManager {
   
    static var sharedInstance = GameManager()
    var endingLocations: [CGPoint] = []

    var levelNumber: Int = NSUserDefaults.standardUserDefaults().integerForKey("DeezLevel") ?? 0 {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(levelNumber, forKey: "DeezLevel")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func createRandomShit(#viewSize: CGSize) {
        
        for i in 1..<20 {
            
            let randomX = CGFloat(arc4random_uniform(UInt32(viewSize.width)))
            let randomY = CGFloat(arc4random_uniform(UInt32(viewSize.height)))
            let randomPos = ccp(randomX, randomY)
            println(randomPos)
            endingLocations.append(randomPos)
    
        }
        
    }
    

    
}
