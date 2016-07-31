//
//  GameOverState.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 7/29/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import GameplayKit

class GameOverState: GKState {
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    
}