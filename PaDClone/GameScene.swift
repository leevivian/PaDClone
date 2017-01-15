//
//  GameScene.swift
//  PazuDora Clone
//
//  Created by Vivian Lee on 1/14/17.
//  Copyright (c) 2017 Vivian Lee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK: Properties
    
    // This is marked as ! because it will not initially have a value, but pretty
    // soon after the GameScene is created it will be given a Level object, and
    // from then on it will always have one (it will never be nil again).
    var level: Level!
    
    let TileWidth: CGFloat = 63.0
    let TileHeight: CGFloat = 63.0
    
    let gameLayer = SKNode()
    let orbsLayer = SKNode()
    let tilesLayer = SKNode()
    
    
    // MARK: Init
    
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
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) - 30)
        
        // The tiles layer represents the shape of the level. It contains a sprite node for each square that is filled in.
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        
        // This layer holds the Orb sprites. The positions of these sprites are relative to the orbsLayer's bottom-left corner.
        orbsLayer.position = layerPosition
        gameLayer.addChild(orbsLayer)
    }
    
    
    // MARK: Level Setup
    
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
    
    
    // MARK: Point conversion
    
    // Converts a column,row pair into a CGPoint that is relative to the orbLayer.
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
}
