//
//  Swap.swift
//  PaDClone
//
//  Created by Vivian Lee on 1/15/17.
//  Copyright © 2017 Vivian Lee. All rights reserved.
//

struct Swap: CustomStringConvertible {
    let orbA: Orb
    let orbB: Orb
    
    init(orbA: Orb, orbB: Orb) {
        self.orbA = orbA
        self.orbB = orbB
    }
    
    var description: String {
        return "swap \(orbA) with \(orbB)"
    }
}