//
//  Alien.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 7/29/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class Alien: SKSpriteNode {
    
    let trail = SKEmitterNode(fileNamed: "AlienTrail")!
    
    // MARK - Init
    init() {
        
        let alienAtlas = SKTextureAtlas(named: "alienBlue")
        
        super.init(texture: alienAtlas.textureNamed("alien-blue-1"),
                   color: UIColor.clearColor(),
                   size: alienAtlas.textureNamed("alien-blue-1").size())
        
        setupPhysics()
        setupAnimation(alienAtlas)
        setupParticles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    func setupPhysics() {
        physicsBody = SKPhysicsBody(rectangleOfSize: texture!.size())
        physicsBody!.categoryBitMask = PhysicsCategory.Player
        physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge
        physicsBody!.contactTestBitMask = PhysicsCategory.Coin | PhysicsCategory.Edge
        
        physicsBody!.angularDamping = 0.5
        physicsBody!.linearDamping = 0.5
    }
    
    func setupAnimation(atlas: SKTextureAtlas) {
        var frames = [SKTexture]()
        
        for i in 1 ..< atlas.textureNames.count - 1 {
            frames.append(atlas.textureNamed("alien-blue-\(i)"))
        }
        
        let animate = SKAction.animateWithTextures(frames, timePerFrame: 0.3)
        let repeatForever = SKAction.repeatActionForever(animate)
        runAction(repeatForever)
    }
    
    
    func setupParticles() {
        addChild(trail)
        trail.targetNode = self.parent
    }
    
    func setTrailTarget(node: SKNode) {
        trail.targetNode = node
    }
    
    
    
}
