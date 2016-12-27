//
//  Bomb.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 8/7/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class Bomb: Thing {
    
    override init() {
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        texture = SKTexture(imageNamed: "alien-bomb-1")
        size = texture!.size()
        let atlas = SKTextureAtlas(named: "alien-bomb")
        var textures = [SKTexture]()
        for textureName in atlas.textureNames {
            textures.append(SKTexture(imageNamed: textureName))
        }
        
        let animation = SKAction.animate(with: textures, timePerFrame: 0.2, resize: false, restore: false)
        run(SKAction.repeatForever(animation))
    }
}
