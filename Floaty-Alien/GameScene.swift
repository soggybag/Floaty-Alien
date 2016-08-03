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
    
    /// Holds two background which recycle to create and endless scrolling environment.
    let backgrounds: [Background]
    /// Scrolling lanscapes 
    let landscape: Landscape
    
    /// The Player object
    let alien: Alien
    
    /// Sets the width of a scrolling background section.
    let backgroundWidth: CGFloat = 640
    
    /// True when touching the screen.
    var touchDown = false
    /// The amount of upward force applied to the alien when touching the screen.
    var up = CGVectorMake(0, 100)
    
    /// The time of the last update. Used to calculate delta time.
    var lastUpdateTime: CFTimeInterval = 0
    
    /// State machine managing the state of the game.
    var gameState: GKStateMachine!
    
    // MARK: - Init
    
    override init(size: CGSize) {
        alien = Alien()
        
        let landscapeSize = CGSize(width: 640, height: size.height)
        landscape = Landscape(size: landscapeSize, speed: 40)
        
        backgrounds = [Background(width: backgroundWidth, height: size.height),
                       Background(width: backgroundWidth, height: size.height)]
        
        super.init(size: size)
        
        setupLandscape()
        setupPhysics()
        setupBackground()
        setupAlien()
        setupStateMachine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Setup
    
    /// Setup the scrolling landscape
    func setupLandscape() {
        addChild(landscape)
        landscape.zPosition = PositionZ.Landscape
        landscape.alpha = 0.5
    }
    
    /// Set up physics world options and create an edgeloop body for the scene.
    func setupPhysics() {
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsBody!.collisionBitMask = PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
 
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0.0, -1.0)
    }
    
    /// Setup the background sections which contain the scrolling environment.
    func setupBackground() {
        for i in 0 ..< backgrounds.count {
            backgrounds[i].position.x = CGFloat(i) * backgroundWidth
            addChild(backgrounds[i])
            if i == 0 {
                backgrounds[i].drawCollumnsFunnel()
                // backgrounds[i].drawReverseFunnel()
            } else {
                backgrounds[i].randomColumns()
            }
        }
    }
    
    /// Sets up the Alien, which is the player object.
    func setupAlien() {
        addChild(alien)
        alien.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        alien.setTrailTarget(self)
        alien.zPosition = PositionZ.Alien
    }
    
    /// Set up game state machine.
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
    
    
    
    
    // MARK: - Physics Contact
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Coin | PhysicsCategory.Player {
            if contact.bodyA.node?.name == "thing" {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
        }
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
    
    
    /// Push the Alien object
    
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
    
    
    /// Scroll the background elements.
    
    func scrollBackground(deltaTime: CFTimeInterval) {
        for background in backgrounds {
            background.position.x -= 80 * CGFloat(deltaTime)
            
            if background.position.x < -backgroundWidth {
                background.position.x += backgroundWidth * 2
                background.randomColumns()
                // background.drawCollumnsFunnel()
            }
        }
    }
    
    
}








