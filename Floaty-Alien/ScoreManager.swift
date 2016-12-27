//
//  ScoreManager.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 8/6/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import Foundation


enum ScoreManagerNotifications {
    static let ScoreDidChange = "ScoreDidChange"
}


class ScoreManager {
    
    // MARK: - Properties 
    
    static let sharedInstance = ScoreManager()
    
    var score: Int = 0 {
        didSet {
            // Post a notification the score changes
            let center = NotificationCenter.default
            center.post(name: Notification.Name(rawValue: ScoreManagerNotifications.ScoreDidChange), object: nil, userInfo: ["score" : score])
        }
    }
    
    // MARK: - Init
    
    fileprivate init() {
        
    }
    
    
    // MARK: - 
    
    func addCoins(_ coins: Int = 1) {
        score += coins
    }
}
