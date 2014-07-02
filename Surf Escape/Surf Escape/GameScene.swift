//
//  GameScene.swift
//  Surf Escape
//
//  Created by Joshua Truscott on 30/06/2014.
//  Copyright (c) 2014 JT App Development. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    //Declare variables outside of functions to make them global
    var surfer = SKSpriteNode()
    var rocksTexture = SKTexture()
    var rocksMoveAndRemove =  SKAction()
    
    let pipeGap = 150
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // This function is called when the screen is first loaded
        
        
        
        //Gravity
        self.backgroundColor = UIColor.blackColor()
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        
        //_____________Surfer______________
        let SurferTexture = SKTexture(imageNamed:"Surfer") //Makes a texture from the image
        SurferTexture.filteringMode = SKTextureFilteringMode.Nearest //Fastest to render, but less quality than Linear
        
        surfer = SKSpriteNode(texture: SurferTexture) //Makes a sprite from said texture
        
        //Image scaling
        surfer.setScale(0.5) //Scale image (1 is same size, 2 is 2X size etc.)
        println(self.frame.size.width)
        surfer.position = CGPoint(x: self.frame.size.width*0.35, y: self.frame.size.height * 0.6) //Set position of sprite on screen
        
        //Has physics body of a circle
        surfer.physicsBody = SKPhysicsBody(circleOfRadius:surfer.size.height/2.0)
        
        //Means it can move
        surfer.physicsBody.dynamic = true
        
        
        surfer.physicsBody.allowsRotation = true //May want to change later
        
        //Adds sprite to screen
        self.addChild(surfer) //Deploys to screen
        
        //____________Ground_______________
        var groundTexture = SKTexture(imageNamed: "Ground") //Set texture
        
        var rockSprite = SKSpriteNode(texture: groundTexture) //Set sprite node using texture
        rockSprite.setScale(1.3) //Scale up to 2X
        
        rockSprite.position = CGPointMake(self.size.width/2 /* Middle of x */, rockSprite.size.height/2.0 /* Middle of image height */)
        //This position code perfectly puts the image at the bottom of the screen
        rockSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width,rockSprite.size.height))
        rockSprite.physicsBody.dynamic = false
        self.addChild(rockSprite) //Deploys to screen
        
        //__________Pipes_____________
        //Creation
        rocksTexture = SKTexture(imageNamed: "Rocks") //Set texture for rocks
        
        //Movement
        //Sets distance pipes must move before being respawned
        let distanceToMove = CGFloat(self.frame.size.width + 2 * rocksTexture.size().width)
        //Actual action for moving pipes
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.005 * distanceToMove))
        //Removes pipes
        let removePipes = SKAction.removeFromParent()
        
        rocksMoveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        //Spawning rocks
        let spawn = SKAction.runBlock({() in self.spawnPipes()}) //spawn is an action to run the fuction spawnPipes()
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0)) //Wait 2 seconds
        let spawnThenDelay = SKAction.sequence([spawn,delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
    }
    
    func spawnPipes(){
        let rocksPair = SKNode()
        rocksPair.position = CGPointMake(self.frame.size.width + rocksTexture.size().width * 2, 0)
        rocksPair.zPosition = -10
        
        let height = UInt32(self.frame.size.height/4)
        let y = arc4random() % height + height
        
        let rockTop = SKSpriteNode(texture: rocksTexture)
        rockTop.setScale(2.0)
        rockTop.position = CGPointMake(0,CGFloat(y) + rockTop.size.height + CGFloat(pipeGap))
        
        rockTop.physicsBody = SKPhysicsBody(rectangleOfSize: rockTop.size)
        rockTop.physicsBody.dynamic = false
        rocksPair.addChild(rockTop)
        
        let rockBottom = SKSpriteNode(texture: rocksTexture)
        rockBottom.setScale(2.0)
        rockBottom.position = CGPointMake(0, CGFloat(y))
        
        rockBottom.physicsBody = SKPhysicsBody(rectangleOfSize: rockBottom.size)
        rockBottom.physicsBody.dynamic = false
        rocksPair.addChild(rockBottom)
        
        rocksPair.runAction(rocksMoveAndRemove)
        self.addChild(rocksPair)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when you touch the screen */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            surfer.physicsBody.velocity = CGVectorMake(0,0)
            surfer.physicsBody.applyImpulse(CGVectorMake(0, 25))
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
