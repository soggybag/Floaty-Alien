//
//  PlayState.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 7/29/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayState: GKState {
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        // scene.scrollBackground(seconds)
        scene.moveBackground(seconds)
        scene.adjustBackground(seconds)
        scene.pushAlien(seconds)
        scene.landscape.updateWithDeltaTime(seconds)
    }
}
