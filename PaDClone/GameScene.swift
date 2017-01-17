//
//  GameScene.swift
//  PazuDora Clone
//
//  Created by Vivian Lee on 1/14/17.
//  Copyright (c) 2017 Vivian Lee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Properties
    
    // This is marked as ! because it will not initially have a value, but pretty
    // soon after the GameScene is created it will be given a Level object, and
    // from then on it will always have one (it will never be nil again).
    var level: Level!
    
    let TileWidth: CGFloat = 63.0
    let TileHeight: CGFloat = 63.0
    
    let gameLayer = SKNode()
    let orbsLayer = SKNode()
    let tilesLayer = SKNode()
    
    var swipeHandler: ((Swap) -> ())?
    
    // record the column and row numbers of the orb that is first selected by the player
    fileprivate var swipeFromColumn: Int?
    fileprivate var swipeFromRow: Int?
    
    // Initialization
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Put an image on the background. Because the scene's anchorPoint is
        // (0.5, 0.5), the background image will always be centered on the screen.
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = size
        addChild(background)
        
        // Add a new node that is the container for all other layers on the playing
        // field. This gameLayer is also centered in the screen. 
        // Subsequent layers are gamelayers' children.
        addChild(gameLayer)
        
        // layerPosition sets a size that is about half the screen
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) - 30)
        
        // The tiles layer represents the shape of the level. It contains a sprite node for each square that is filled in.
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        
        // This layer holds the Orb sprites. The positions of these sprites are relative to the orbsLayer's bottom-left corner.
        orbsLayer.position = layerPosition
        gameLayer.addChild(orbsLayer)
        
        // Initialize swipe movement properties as nil when not selected
        swipeFromColumn = nil
        swipeFromRow = nil
        
    }
    
    // Level Setup
    
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
             
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tileNode.position = pointFor(column, row: row)
                    tilesLayer.addChild(tileNode)
                
            }
        }
    }
    
    func addSprites(for orbs: Set<Orb>) {
        for orb in orbs {
            // Create a new sprite for the orb and add it to the orbsLayer.
            let sprite = SKSpriteNode(imageNamed: orb.orbType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(orb.column, row: orb.row)
            orbsLayer.addChild(sprite)
            orb.sprite = sprite
        }
    }
    
    // Converts a (column,row) pair into a CGPoint that is relative to the orbsLayer.
    func pointFor(_ column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    // Convert CGPoint in a (column,row) pair
    func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Convert touch location to a point relative to orbsLayer
        guard let touch = touches.first else { return }
        let location = touch.location(in: orbsLayer)
        // Verify touch occured on level grid
        let (success, column, row) = convertPoint(location)
        if success {
            // touch is on orb
            if level.orbAt(column, row: row) != nil {
                // record the column and row
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }
    
    // Detect swipe direction
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        guard swipeFromColumn != nil else { return }
        
        // 2
        guard let touch = touches.first else { return }
        let location = touch.location(in: orbsLayer)
        
        let (success, column, row) = convertPoint(location)
        if success {
            
            // 3
            var horzDelta = 0, vertDelta = 0
            if column < swipeFromColumn! {          // swipe left
                horzDelta = -1
            } else if column > swipeFromColumn! {   // swipe right
                horzDelta = 1
            } else if row < swipeFromRow! {         // swipe down
                vertDelta = -1
            } else if row > swipeFromRow! {         // swipe up
                vertDelta = 1
            }
            
            // 4
            if horzDelta != 0 || vertDelta != 0 {
                trySwap(horizontal: horzDelta, vertical: vertDelta)
                
                // 5
                swipeFromColumn = nil
            }
        }
    }
    
    func trySwap(horizontal horzDelta: Int, vertical vertDelta: Int) {
        // 1
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
        // 2
        guard toColumn >= 0 && toColumn < NumColumns else { return }
        guard toRow >= 0 && toRow < NumRows else { return }
        // 3
        if let toOrb = level.orbAt(toColumn, row: toRow),
            let fromOrb = level.orbAt(swipeFromColumn!, row: swipeFromRow!) {
            // 4
            print("*** swapping \(fromOrb) with \(toOrb)")
            if let handler = swipeHandler {
                let swap = Swap(orbA: fromOrb, orbB: toOrb)
                handler(swap)
            }
        }
    }
    
    // user lifts finger up from screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    func animate(_ swap: Swap, completion: @escaping () -> ()) {
        let spriteA = swap.orbA.sprite!
        let spriteB = swap.orbB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let duration: TimeInterval = 0.3
        
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut
        spriteA.run(moveA)
        
        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut
        spriteB.run(moveB)
    }
    
}
