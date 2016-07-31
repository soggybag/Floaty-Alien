//
//  PhysicsCategory.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 7/29/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None:    UInt32 = 0
    static let Player:  UInt32 = 0b1
    static let Edge:    UInt32 = 0b10
    static let Block:   UInt32 = 0b100
    static let Coin:    UInt32 = 0b1000
}