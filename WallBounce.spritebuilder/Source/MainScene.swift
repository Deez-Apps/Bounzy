import GameKit

class MainScene: CCNode {
    
    // MARK: - Properties
    
    weak var gamePhysicsNode: CCPhysicsNode!
    
    // exhibition
    var yes = true
    
    // balls
    weak var gameBall: CCNode!
    weak var gameFinish: CCNode!
    
    // walls
    weak var wall: CCNode!
    weak var wallHits: CCLabelTTF!
    
    // retry
    weak var retryWin: CCButton!
    weak var retryLose: CCButton!
    
    // hit counter
    weak var hitCounter: CCLabelTTF!
    var counter = 0 {
        didSet {
            hitCounter.string = "\(counter)"
        }
    }
    
    // level number
    var levelNumber = 0
    
    // swipe
    var isSwiping = false
    var initialPosition: CGPoint?
    
    // mixpanel
    let mixpanel = Mixpanel.sharedInstanceWithToken("a18edff4182e75cc5a162c7967ae4cac")
    

    // MARK: - DidLoadFromCCB
    
    func didLoadFromCCB() {
        
        userInteractionEnabled = true
        
        gamePhysicsNode.collisionDelegate = self
        
        // levels
        levelNumber = GameManager.sharedInstance.levelNumber
        
        // label display
        wallHits.string = "Bounzys needed: \(levelNumber)"
        
        // load start screen
        if (levelNumber == 0) {
            let startScreen = CCBReader.load("StartScreen") as! StartScreen
            addChild(startScreen)
        }
        
        // wall counter
        hitCounter.string = "\(counter)"
        
        // if this level is not the same as previous, do random
        let viewSize = CCDirector.sharedDirector().viewSize()
        
        // generate random positions
        GameManager.sharedInstance.createRandomShit(viewSize: viewSize)
        
        let distance = ccpDistance(gameFinish.position, gameBall.position)
        
        // set constraints
        setPosition(distance: distance, viewSize: viewSize)
        
    }
    
    func setPosition(#distance: CGFloat, viewSize: CGSize) {
        
        if (distance < 50) {
            setPosition(distance: distance, viewSize: viewSize)
        } else {
            setBallPosition(viewSize: viewSize)
        }
        
    }
    
    func setBallPosition(#viewSize: CGSize) {
        
        if (levelNumber != 0) {
            // other than first level
            let position = GameManager.sharedInstance.endingLocations[levelNumber]
            gameFinish.position = gamePhysicsNode.convertToNodeSpace(position)
        } else {
            // first level
            let positionX = viewSize.width/2
            let positionY = viewSize.height/2
            let position = ccp(positionX, positionY)
            gameFinish.position = gamePhysicsNode.convertToNodeSpace(position)
        }
        
    }

    // MARK: - Update function
    
    override func update(delta: CCTime) {
        
        if (counter > levelNumber) {
            
            // game lost
            paused = true
            let losingScreen = CCBReader.load("Lose")
            addChild(losingScreen)
            
            // mixpanel track lost
            mixpanel.track("Game lost")
            
        }
        
    }
    
    // MARK: - Touch overrides
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        initialPosition = touch.locationInWorld()

        gameBall.position = initialPosition!
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        // touch moved
        isSwiping = true
        
    }
    
    override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {

        // touch cancelled
        let finalTouchPosition = touch.locationInWorld()
        dragThisShit(finalPosition: finalTouchPosition)
        
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        // touch ended
        let finalTouchPosition = touch.locationInWorld()
        
        if finalTouchPosition != initialPosition {
            dragThisShit(finalPosition: finalTouchPosition)
        }
        
    }
    
    func dragThisShit(#finalPosition: CGPoint) {
    
        // create vector
        if (isSwiping) {
            
            if let initialPosition = initialPosition {
                let vector = ccpSub(finalPosition, initialPosition)
                let normalizedVect = ccpNormalize(vector)
                
                let impulseMultiplier: CGFloat = 300
                let finalImpulseVect = ccpMult(normalizedVect, impulseMultiplier)
                
                gameBall.physicsBody.applyImpulse(finalImpulseVect)
                
                // disable user interaction
                userInteractionEnabled = false
            }
            
        }

    }
    
    // MARK: - Home
    
    func goToHome() {
        
        let homeScreen = CCBReader.load("StartScreen") as! StartScreen
        addChild(homeScreen)
        
    }
    
    
}



extension MainScene: CCPhysicsCollisionDelegate {
    
    // wall collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, wall: CCNode!, ball: CCNode!) -> Bool {
        
        if (gameBall.physicsBody.velocity.x != 0) {
            counter++
        }
        
        return true
        
    }
    
    // ball collisions
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ball: CCNode!, bigBall: CCSprite!) -> Bool {
        
        if (counter == levelNumber) {
            
            // mixpanel track lost
            mixpanel.track("Game won")
            
            paused = true
            GameManager.sharedInstance.levelNumber++
            let winningScreen = CCBReader.load("Win", owner: self) as! Screen
            addChild(winningScreen)
            
        } else {
            paused = true
            let losingScreen = CCBReader.load("Lose", owner: self) as! Screen
            addChild(losingScreen)
        }
        
        return true
    }
    
    
}
