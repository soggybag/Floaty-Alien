//
//  Background.swift
//  Floaty-Alien
//
//  Created by mitchell hudson on 7/30/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//


/*

 Draws the background environment. 
 Background includes physics objects for collisions with player. 
 
 The background is built from a series of vertical columns in a horizontal row. 
 A top column and bottom column create a gap in between to allow passage for the alien.
 
*/




import SpriteKit

class Background: SKNode {
    
    // MARK: - Properties
    
    let thingsNode: SKNode
    
    /** Sets the width and height for tiles that make up columns */
    let blockSize: CGFloat = 32
    let blockHalfSize: CGFloat = 16
    
    /** The number of blocks that fill the screen vertically */
    let totalVerticalBlocks: Int
    /** The height of a column in points */
    let columnHeight: CGFloat
    
    /** Total width of the this background in points */
    let backgroundWidth: CGFloat
    /** The height of the background in points */
    let backgroundHeight: CGFloat
    /** Stores arrays of columns each containing top column, and bottom column. */
    var columns = [[SKNode]]()
    
    /** This static property contains the last y value. Used to sync the next background.  */
    static var lastColumnY: Int = 6
    /// This static property holds the last space value. Used to sync the next background.
    static var lastSpace: Int = 6
    
    
    // MARK: - Init
    
    init(width: CGFloat, height: CGFloat) {
        backgroundWidth = width
        backgroundHeight = height
        totalVerticalBlocks = Int(ceil(backgroundHeight / blockSize))
        columnHeight = CGFloat(totalVerticalBlocks) * blockSize
        
        thingsNode = SKNode()
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    
/**
     
Sets up a Background instance. Populates background with a row columns in
top and bottom pairs.
     
*/
    
    func setup() {
        addChild(thingsNode)
        thingsNode.zPosition = 10
        
        let totalHorizontalBlocks = Int(ceil(backgroundWidth / blockSize))
        let totalVerticalBlocks = Int(ceil(backgroundHeight / blockSize))
        
        for x in 0 ..< totalHorizontalBlocks {
            let topColumn = makeColumn(totalVerticalBlocks)
            let bottomColumn = makeColumn(totalHorizontalBlocks)
            
            topColumn.name = "top"
            bottomColumn.name = "bottom"
            
            topColumn.zPosition = PositionZ.Background
            bottomColumn.zPosition = PositionZ.Background
            
            topColumn.position.x = CGFloat(x) * blockSize + blockHalfSize
            bottomColumn.position.x = topColumn.position.x
            
            addChild(topColumn)
            addChild(bottomColumn)
            
            columns.append([topColumn, bottomColumn])
        }
    }
    
    
    
    // MARK: - Environment generation
    
/**
 
 Make a column with rectangular physics body
 
- Parameter numberOfBlocks: sets vertical block count for column
     
- returns SKNode
 
 */
    
    func makeColumn(numberOfBlocks: Int) -> SKNode {
        let column = SKNode()
        let columnheight = blockSize * CGFloat(numberOfBlocks)
        
        for i in 0 ..< numberOfBlocks {
            // TODO: Randomize tile images 
            let n = arc4random() % 8 + 1
            let block = SKSpriteNode(texture: SKTexture(imageNamed: "wall-\(n)"))
            column.addChild(block)
            let y = CGFloat(i) * blockSize - (columnheight / 2) + blockHalfSize
            block.position = CGPoint(x: 0, y: y)
        }
        
        let columnSize = CGSize(width: blockSize, height: columnheight)
        column.physicsBody = SKPhysicsBody(rectangleOfSize: columnSize)
        column.physicsBody!.dynamic = false
        
        column.physicsBody!.categoryBitMask = PhysicsCategory.Block
        column.physicsBody!.collisionBitMask = PhysicsCategory.Player
        column.physicsBody!.contactTestBitMask = PhysicsCategory.None
        
        return column
    }


    
    func randomColumns() {
        var space: Int = 6 // Int(arc4random() % 4) + 2
        var y = shiftColumnY(Background.lastColumnY, space: space)
        
        clearThings()
        
        for column in columns {
            positionColumnPair(column, y: y, space: space)
            
            // FIXME: Randomizing function for space is not working
            // space = adjustSpace(space)
            
            addThingsToSpace(space, y: y, x: column[0].position.x)
            
            y = shiftColumnY(y, space: space)
            
        }
        
        Background.lastColumnY = y
        Background.lastSpace = space
        
        
    }
    
/**
     
 Draws columns in a funnel shape narrowing from left to right.
     
*/
    func drawCollumnsFunnel() {
        var space: Int = totalVerticalBlocks - 2
        var y = 1
        
        for column in columns {
            positionColumnPair(column, y: y, space: space)
            
            if space > 6 {
                space -= 2
                y += 1
            }
        }
        
        Background.lastColumnY = y
        Background.lastSpace = space
    }
    
    func drawReverseFunnel() {
        let maxSpace: Int = totalVerticalBlocks - 2
        var y = Background.lastColumnY
        var space = Background.lastSpace
        
        for column in columns {
            positionColumnPair(column, y: y, space: space)
            
            if space < maxSpace {
                space += 1
                if y + space >= totalVerticalBlocks {
                    y -= 1
                }
            }
        }
        
        Background.lastColumnY = y
        Background.lastSpace = space
    }
    
    
    
    // TODO: Generate things to collect in space
    
    func addThingsToSpace(space: Int, y: Int, x: CGFloat) {
        let thing = Thing()
        addChild(thing)
        
        thing.position.x = x
        let n = Int(arc4random() % UInt32(space))
        thing.position.y = CGFloat(y + n) * blockSize + blockHalfSize
        
        thing.zPosition = PositionZ.Thing
    }
    
    func clearThings() {
        enumerateChildNodesWithName("thing") { (node, stop) in
            node.removeFromParent()
        }
    }
    
    
    
    
    // MARK: - Utilities
    
    /** 
     
 Positions a column pair around a space. With one column above, and the other above
 the space. 
 
 - Parameter columnPair: **[SKNode]** an array containing the upper and power node. 
 
 - Parameter y: **Int** the starting y position of hte lower column. Measured in block heights.
 
 - Parameter space: **Int** the space between the upper and lower columns in block heights.
 
     */
    
    func positionColumnPair(columnPair: [SKNode], y: Int, space: Int) {
        columnPair[0].position.y = -columnHeight / 2 + (CGFloat(y) * blockSize)
        columnPair[1].position.y = columnPair[0].position.y + columnHeight + (CGFloat(space) * blockSize) - blockHalfSize
    }
    
    /**
     
     Used to randomize the column position by moving the column up or down one block size
     while checking to make sure the position of the space between the upper and lower column
     will not end up off screen.
     
     - Parameter y: **Int** the position of the column in blockSize increments.
     
     - parameter space: **Int** the gap between the upper and lower column in blockSize increments.
     
     */
    
    func shiftColumnY(y: Int, space: Int) -> Int {
        // TODO: Turn this into a more generic function
        // that returns a value adjust by a random amount that stays within a range
        // print("y: \(y) space: \(space) total: \(totalVerticalBlocks)")
        
        if y > 1 && y + space < totalVerticalBlocks - 1 {
            return y + Int(arc4random() % 3) - 1
        } else if y == 1 {
            return y + Int(arc4random() % 2)
        } else {
            return y - Int(arc4random() % 2)
        }
    }
    
    
    
    
    func adjustSpace(space: Int) -> Int {
        // FIXME: This isn't working
        if space > 2 && space < totalVerticalBlocks {
            return space - Int(arc4random() % 3) - 1
        } else if space == 2 {
            return space + Int(arc4random() % 2)
        } else {
            return space - Int(arc4random() % 2)
        }
    }
    
}
