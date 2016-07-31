//
//  GameScene.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 7/29/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//




// TODO: Create special starting arrangement for blocks. 
// TODO: add parent node to hold background, particles should target this node. 
// TODO: Invent some block types for fun interaction.



import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let backgrounds = [Background(), Background()]
    let alien: Alien
    
    let backgroundWidth: CGFloat = 640
    
    var touchDown = false
    var up = CGVectorMake(0, 100)
    var lastUpdateTime: CFTimeInterval = 0
    
    var gameState: GKStateMachine!
    
    // MARK: - Init
    
    override init(size: CGSize) {
        alien = Alien()
        
        super.init(size: size)
        
        setupPhysics()
        setupBackground()
        setupAlien()
        setupStateMachine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Setup
    
    func setupPhysics() {
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsBody!.collisionBitMask = PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
 
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0.0, -1.0)
    }
    
    func setupBackground() {
        for i in 0 ..< backgrounds.count {
            backgrounds[i].position.x = CGFloat(i) * backgroundWidth
            addChild(backgrounds[i])
            backgrounds[i].resetColumns()
        }
    }
    
    func setupAlien() {
        addChild(alien)
        alien.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        alien.setTrailTarget(self)
    }
    
    func setupStateMachine() {
        let playState = PlayState(scene: self)
        let gameOverState = GameOverState(scene: self)
        
        gameState = GKStateMachine(states: [playState, gameOverState])
        gameState.enterState(PlayState)
    }
    
    
    
    // MARK: - Did Move to View
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
    }
    
    
    
    // MARK: - Touch Events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchDown = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchDown = false
    }
   
    
    
    
    // MARK: - Update
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        var deltaTime: CFTimeInterval = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if deltaTime > 1 {
            deltaTime = 1 / 60
            lastUpdateTime = currentTime
        }
        
        gameState.updateWithDeltaTime(deltaTime)
    }
    
    
    func pushAlien(deltaTime: CFTimeInterval) {
        let dx = (frame.width / 2 - alien.position.x) * 0.1
        if touchDown {
            up.dx = dx
            alien.physicsBody!.applyForce(up)
        } else {
            let push = CGVector(dx: dx, dy: 0)
            alien.physicsBody!.applyForce(push)
        }
    }
    
    func scrollBackground(deltaTime: CFTimeInterval) {
        for background in backgrounds {
            background.position.x -= 40 * CGFloat(deltaTime)
            
            if background.position.x < -backgroundWidth {
                background.position.x += backgroundWidth * 2
                background.resetColumns()
                // resetBackgroundContent(background)
            }
        }
    }
    
    
}








