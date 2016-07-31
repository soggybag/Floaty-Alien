//
//  Background.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 7/30/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class Background: SKNode {
    let blockSize: CGFloat = 32
    let blockHalfSize: CGFloat = 16
    
    let totalVerticalBlocks: Int
    
    let backgroundWidth: CGFloat = 640
    let backgroundHeight: CGFloat = 667
    var columns = [[SKNode]]()
    
    static var lastColumnY: Int = 8
    
    
    // MARK: - Init
    
    override init() {
        
        totalVerticalBlocks = Int(ceil(backgroundHeight / blockSize))
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    func setup() {
        let totalHorizontalBlocks = Int(ceil(backgroundWidth / blockSize))
        let totalVerticalBlocks = Int(ceil(backgroundHeight / blockSize))
        
        for x in 0 ..< totalHorizontalBlocks {
            let topColumn = makeColumn(totalVerticalBlocks)
            let bottomColumn = makeColumn(totalHorizontalBlocks)
            
            topColumn.name = "top"
            bottomColumn.name = "bottom"
            
            topColumn.position.x = CGFloat(x) * blockSize + blockHalfSize
            bottomColumn.position.x = topColumn.position.x
            
            addChild(topColumn)
            addChild(bottomColumn)
            
            columns.append([topColumn, bottomColumn])
            
        }
    }
    
    func makeColumn(numberOfBlocks: Int) -> SKNode {
        let column = SKNode()
        let columnheight = blockSize * CGFloat(numberOfBlocks)
        
        for i in 0 ..< numberOfBlocks {
            let block = SKSpriteNode(texture: SKTexture(imageNamed: "wall-1"))
            column.addChild(block)
            let y = CGFloat(i) * blockSize - (columnheight / 2) + blockHalfSize
            block.position = CGPoint(x: 0, y: y)
            
            let columnSize = CGSize(width: blockSize, height: columnheight)
            column.physicsBody = SKPhysicsBody(rectangleOfSize: columnSize)
            column.physicsBody!.dynamic = false
            
            column.physicsBody!.categoryBitMask = PhysicsCategory.Block
            column.physicsBody!.collisionBitMask = PhysicsCategory.Player
            column.physicsBody!.contactTestBitMask = PhysicsCategory.None
        }
        
        return column
    }

    func resetColumns() {
        let space: Int = 6 // Int(arc4random() % 4) + 2
        let columnHeight = CGFloat(totalVerticalBlocks) * blockSize
        
        var y = shiftColumnY(Background.lastColumnY, space: space)
        
        for column in columns {
            column[0].position.y = -columnHeight / 2 + (CGFloat(y) * blockSize)
            column[1].position.y = column[0].position.y + columnHeight + (CGFloat(space) * blockSize)
            
            y += Int(arc4random() % 3) - 1
        }
        
        Background.lastColumnY = y
    }
    
    
    // TODO: Fix issue where cloumns squeeze too close to top. 
    func shiftColumnY(y: Int, space: Int) -> Int {
        if y > 0 && y + space < totalVerticalBlocks {
            return y + Int(arc4random() % 3) - 1
        } else if y == 0 {
            return y + Int(arc4random() % 2)
        } else {
            return y - Int(arc4random() % 2)
        }
    }
    
    
}
