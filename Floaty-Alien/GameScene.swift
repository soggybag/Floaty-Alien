//
//  GameScene.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 7/29/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//



// TODO: Add score/Distance travelled class 
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
    var up = CGVector(dx: 0, dy: 100)
    
    /// The time of the last update. Used to calculate delta time.
    var lastUpdateTime: CFTimeInterval = 0
    
    /// State machine managing the state of the game.
    var gameState: GKStateMachine!
    
    var backgroundSpeed: CGFloat = 80
    
    var scoreDisplay: ScoreDisplay
    
    // MARK: - Init
    
    override init(size: CGSize) {
        alien = Alien()
        
        let landscapeSize = CGSize(width: 640, height: size.height)
        landscape = Landscape(size: landscapeSize, speed: 40)
        
        backgrounds = [Background(width: backgroundWidth, height: size.height),
                       Background(width: backgroundWidth, height: size.height)]
        
        scoreDisplay = ScoreDisplay()
        
        super.init(size: size)
        
        setupLandscape()
        setupPhysics()
        setupBackground()
        setupAlien()
        setupStateMachine()
        setupScoreDisplay()
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
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsBody!.collisionBitMask = PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
 
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
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
                // backgrounds[i].makeCave()
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
        gameState.enter(PlayState)
    }
    
    func setupScoreDisplay() {
        addChild(scoreDisplay)
        scoreDisplay.position.x = 10
        scoreDisplay.position.y = size.height - 10
    }
    
    
    
    // MARK: - Did Move to View
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
    }
    
    
    
    
    // MARK: - Physics Contact
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Coin | PhysicsCategory.Player {
            // Player contact star score a point
            if contact.bodyA.categoryBitMask == PhysicsCategory.Coin {
                if contact.bodyA.node is Bomb {
                    ScoreManager.sharedInstance.addCoins(3)
                } else {
                    ScoreManager.sharedInstance.addCoins()
                }
                contact.bodyA.node?.removeFromParent()
                
            } else {
                if contact.bodyB.node is Bomb {
                    ScoreManager.sharedInstance.addCoins(3)
                } else {
                    ScoreManager.sharedInstance.addCoins()
                }
                contact.bodyB.node?.removeFromParent()
            }
        }
    }
    
    
    
    
    
    // MARK: - Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDown = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDown = false
    }
   
    
    
    
    // MARK: - Update
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        var deltaTime: CFTimeInterval = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if deltaTime > 1 {
            deltaTime = 1 / 60
            lastUpdateTime = currentTime
        }
        
        gameState.update(deltaTime: deltaTime)
    }
    
    
    /// Push the Alien object
    
    // TODO: Adjust for speed
    // TODO: Adjust for deltaTime
    
    func pushAlien(_ deltaTime: CFTimeInterval) {
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
    
    func scrollBackground(_ deltaTime: CFTimeInterval) {
        for background in backgrounds {
            background.position.x -= backgroundSpeed * CGFloat(deltaTime)
            
            if background.position.x < -backgroundWidth {
                background.position.x += backgroundWidth * 2
                // background.randomColumns()
                // background.drawCollumnsFunnel()
                background.makeCave()
                
                backgroundSpeed += 5
            }
        }
    }
    
    
    func moveBackground(_ deltaTime: CFTimeInterval) {
        for background in backgrounds {
            background.position.x -= backgroundSpeed * CGFloat(deltaTime)
        }
    }
    
    
    func adjustBackground(_ deltaTime: CFTimeInterval) {
        for background in backgrounds {
            if background.position.x < -backgroundWidth {
                background.position.x += backgroundWidth * 2
                // background.randomColumns()
                // background.drawCollumnsFunnel()
                background.makeCave()
                
                backgroundSpeed += 5
            }
        }
    }
    
    
}








