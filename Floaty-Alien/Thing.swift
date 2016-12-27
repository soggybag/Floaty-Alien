//
//  Thing.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 8/2/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class Thing: SKSpriteNode {
    
    
    
    // MARK: - Init
    
    init() {
        let texture = SKTexture(imageNamed: "star-1")
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        setupThing()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Setup
    
    func setupThing() {
        name = "thing"
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        
        physicsBody!.isDynamic = false
        
        physicsBody!.categoryBitMask = PhysicsCategory.Coin
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
    }
    
    
}







