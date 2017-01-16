//
//  Orb.swift
//  PazuDora Clone
//
//  Created by Vivian Lee on 1/14/17.
//  Copyright © 2017 Vivian Lee. All rights reserved.
//

import SpriteKit

enum OrbType: Int, CustomStringConvertible {
    case unknown = 0, dark, fire, heart, light, water, wood
    // The spriteName property returns the filename of the corresponding sprite image in the texture atlas. In addition to the regular orb sprite, there is also a highlighted version that appears when the player taps on the orb.
    var spriteName: String {
        let spriteNames = [
            "dark",
            "fire",
            "heart",
            "light",
            "water",
            "wood"]
        
        return spriteNames[rawValue - 1]
    }
    
    // The spriteName and highlightedSpriteName properties simply look up the name for the orb sprite in an array of strings. To find the index, you use rawValue to convert the enum’s current value to an integer.
    // arrays are indexed starting at 0, so you need to subtract 1 to find the correct array index
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    // Every time a new orb gets added to the game, it will get a random orb type. It makes sense to add that as a function on OrbType.
    // the result from arc4random_uniform() (an UInt32) must first be converted to an Int, and you can convert this number into a proper OrbType value
    static func random() -> OrbType {
        return OrbType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
    // Return sprite name
    var description: String {
        return spriteName
    }
    
}

// column/row properties let Orb keep track of its position in the 2D grid.
// The sprite property is optional, hence the question mark after SKSpriteNode, because the orb object may not always have its sprite set.

// Compares two objects of the same type
func ==(lhs: Orb, rhs: Orb) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}

// Hashable: requires you to add a hashValue property to the object. This returns an int value that is as unique as possible for your object. Its position in the 2D grid is used to generate the hash value.
class Orb: CustomStringConvertible, Hashable {
    var column: Int
    var row: Int
    let orbType: OrbType
    var sprite: SKSpriteNode?
    
    var hashValue: Int {
        return row*10 + column
    }
    
    // print(): the type of orb and its column and row in the level grid.
    var description: String {
        return "type:\(orbType) square:(\(column),\(row))"
    }
    
    // The orbType property describes the—wait for it—type of the orb, which takes a value from the OrbType enum. The type is really just a number from 1 to 6, but wrapping it in an enum allows you to work with easy-to-remember names instead of numbers.
    init(column: Int, row: Int, orbType: OrbType) {
        self.column = column
        self.row = row
        self.orbType = orbType
    }
}