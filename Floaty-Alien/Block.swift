//
//  Block.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 7/30/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class Block: SKSpriteNode {
    
    
    // MARK: - Init
    init(blockTexture: SKTexture) {
        
        super.init(texture: blockTexture, color: UIColor.clearColor(), size: blockTexture.size())
        
        setupPhysics()
        
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    func setupPhysics() {
        physicsBody = SKPhysicsBody(rectangleOfSize: texture!.size())
        
        physicsBody!.categoryBitMask = PhysicsCategory.Block
        physicsBody!.collisionBitMask = PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.None
        
        physicsBody!.dynamic = false
    }
    
}
