import Foundation


class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var gameBall: CCNode!
    weak var gameFinish: CCNode!
    weak var wall: CCNode!
    weak var wallHits: CCLabelTTF!
    weak var retryWin: CCButton!
    weak var retryLose: CCButton!
    weak var hitCounter: CCLabelTTF!
    var counter = 0 {
        didSet {
            hitCounter.string = "\(counter)"
        }
    }
    
    // level number
    var levelNumber = 0
    
    var touchCounter = 0
    var isSwipe = false
    
    // mixpanel
    let mixpanel = Mixpanel.sharedInstanceWithToken("a18edff4182e75cc5a162c7967ae4cac")
    
    
    var touchPosition: CGPoint = ccp(0, 0)
    var initialPosition: CGPoint?
    
    func didLoadFromCCB(){
        userInteractionEnabled = true
        
        gamePhysicsNode.debugDraw = false
        
        gamePhysicsNode.collisionDelegate = self
        
        // levels
        levelNumber = GameManager.sharedInstance.levelNumber
        println(levelNumber)
        wallHits.string = "Bounzys needed: \(levelNumber)"
        
        // load start screen
        if levelNumber == 0 {
            let startScreen = CCBReader.load("StartScreen") as! StartScreen
            addChild(startScreen)
        }
        
        gameBall.physicsBody.density = 1
        
        // wall counter
        hitCounter.string = "\(counter)"
        
        // if this level is not the same as previous, do random
        let viewSize = CCDirector.sharedDirector().viewSize()
        GameManager.sharedInstance.createRandomShit(viewSize: viewSize)
        
        let distance = ccpDistance(gameFinish.position, gameBall.position)
        if distance < 50 {
            
            if levelNumber != 0 {
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
        } else {
            
            if levelNumber != 0 {
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

        
        if levelNumber == 0 {
            loadTutorial()
        }
        
        
    }
    
    func loadTutorial(){
        let tutorial = CCBReader.load("Tutorial")
        addChild(tutorial)
    }
    
    override func update(delta: CCTime) {
        
        if counter > levelNumber {
            // game lost
            paused = true
            let losingScreen = CCBReader.load("Lose")
            addChild(losingScreen)
            
            // mixpanel track lost
            mixpanel.track("Game lost")
            
        }
        
    }
    
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        initialPosition = touch.locationInWorld()
        

        gameBall.position = touch.locationInWorld()
        
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        // touch moved
        isSwipe = true
        
        
    }
    
    
    override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {

        // touch cancelled
        let finalPosition = touch.locationInWorld()

        dragThisShit(finalPosition)
        
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        // touch ended
        let finalPosition = touch.locationInWorld()
        
        
        if finalPosition != initialPosition {
            dragThisShit(finalPosition)

        }

        
    }
    
    func dragThisShit(finalPosition: CGPoint) {
    
        // create vector

        if (isSwipe){
            if let initialPosition = initialPosition {
                let vector = ccpSub(finalPosition, initialPosition)
                let normalizedVect = ccpNormalize(vector)
                
                let superAwesomeVect = ccpMult(normalizedVect, 300)
                
                gameBall.physicsBody.applyImpulse(superAwesomeVect)
                
                userInteractionEnabled = false
            }
        }

        
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, wall: CCNode!, ball: CCNode!) -> Bool {
        
        counter++
        
        return true
        
    }
    func retryLoseGame(){
        
        // mixpanel track lost
        mixpanel.track("Game retried")
        
        let gameplay = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(gameplay)
        
        
        
    }
    func retryWinGame(){
        let gameplay = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(gameplay)
    }
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ball: CCNode!, bigBall: CCSprite!) -> Bool {
        
        if counter == levelNumber {
            
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
