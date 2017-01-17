//
//  Level.swift
//  PazuDora Clone
//
//  Created by Vivian Lee on 1/14/17.
//  Copyright © 2017 Vivian Lee. All rights reserved.
//

import Foundation

// Declare two constants for the dimensions of the level, prevents hardcoding the dimensions everywhere
let NumColumns = 6
let NumRows = 5

class Level {
    // two-dim array that holds Orb objects, 30 in total
    fileprivate var orbs = Array2D<Orb>(columns: NumColumns, rows: NumRows)
    
    // assert will verify the specified column and row numbers are valid
    func orbAt(_ column: Int, row: Int) -> Orb? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return orbs[column, row]
    }
    
    // fills level with random orbs
    func shuffle() -> Set<Orb> {
        return createInitialOrbs()
    }
    
    fileprivate func createInitialOrbs() -> Set<Orb> {
        var set = Set<Orb>()
        
        // Loop through rows and columns of the 2D array
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
             //  if tiles[column, row] != nil {
                // Pick a random orb type
                let orbType = OrbType.random()
                
                // Create new Orb object and add to 2D array
                let orb = Orb(column: column, row: row, orbType: orbType)
                orbs[column, row] = orb
                
                // Adds new Orb object to Set.shuffle
                set.insert(orb)
             //  }
            }
        }
        return set
    }
    
    // tiles describes level structure, similar to 2D Array of Orbs
    fileprivate var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    func performSwap(_ swap: Swap) {
        let columnA = swap.orbA.column
        let rowA = swap.orbA.row
        let columnB = swap.orbB.column
        let rowB = swap.orbB.row
        
        orbs[columnA, rowA] = swap.orbB
        swap.orbB.column = columnA
        swap.orbA.row = rowA
        
        orbs[columnB, rowB] = swap.orbA
        swap.orbB.column = columnB
        swap.orbA.row = rowB
    }

}

