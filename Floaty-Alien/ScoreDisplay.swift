//
//  ScoreDisplay.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 8/6/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit


/// Displays the score, distance travelled...

class ScoreDisplay: SKNode {
    
    
    // MARK: - Properties
    
    let scoreLabel: SKLabelNode
    var scoreObserver: NSObjectProtocol!
    
    
    // MARK: - Init
    
    override init() {
        
        scoreLabel = SKLabelNode(fontNamed: "04b_19") // 
        
        super.init()
        
        setupLabel()
        setupNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        // Remove notification
        removeNotifications()
    }
    
    
    // MARK: - Setup
    
    func setupLabel() {
        addChild(scoreLabel)
        zPosition = PositionZ.Score
        scoreLabel.text = "123456789"
        scoreLabel.fontSize = 24
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.horizontalAlignmentMode = .left
    }
    
    /// Add a notification for Score change
    
    func setupNotifications() {
        let center = NotificationCenter.default
        scoreObserver = center.addObserver(forName: NSNotification.Name(rawValue: ScoreManagerNotifications.ScoreDidChange), object: nil, queue: nil) { (notification) in
            self.scoreLabel.text = "\(notification.userInfo!["score"] as! Int)"
        }
    }
    
    /// Remove notification
    func removeNotifications() {
        let center = NotificationCenter.default
        center.removeObserver(scoreObserver)
    }
    
}
