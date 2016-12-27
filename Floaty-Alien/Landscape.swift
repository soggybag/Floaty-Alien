//
//  Landscape.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 8/1/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class Landscape: SKNode {
    
    // MARK: - Properties 
    
    let landscapeSize: CGSize
    let landscapeNodes = [SKNode(), SKNode()]
    let landscapeSpeed: CGFloat
    
    // MARK: - Init
    
    init(size: CGSize, speed: CGFloat) {
        landscapeSize = size
        landscapeSpeed = speed
        
        super.init()
        
        setupLandscapeNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Setup
    
    func setupLandscapeNodes() {
        for i in 0 ..< landscapeNodes.count {
            landscapeNodes[i].position.x = CGFloat(i) * landscapeSize.width
            addChild(landscapeNodes[i])
            reset(landscapeNodes[i])
        }
    }
    
    
    
    // MARK: - Utility methods 
    
    func updateWithDeltaTime(_ deltaTime: CFTimeInterval) {
        for landscape in landscapeNodes {
            landscape.position.x -= landscapeSpeed * CGFloat(deltaTime)
            if landscape.position.x < -(landscapeSize.width + scene!.frame.width / 2) {
                landscape.position.x += landscapeSize.width * 2
                
            }
        }
    }
    
    func reset(_ node: SKNode) {
        node.removeAllChildren()
        let n = arc4random() % 3 + 1
        let sprite = SKSpriteNode(imageNamed: "Sky-\(n)")
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        node.addChild(sprite)
    }
    
}









