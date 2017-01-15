//
//  Array2D.swift
//  PazuDora Clone
//
//  Created by Vivian Lee on 1/14/17.
//  Copyright © 2017 Vivian Lee. All rights reserved.
//


// Generic Struct, can hold elements of any type T
struct Array2D<T> {
    let columns: Int
    let rows: Int
    private var array: Array<T?>
    
    // Creates regular Swift Array with rows x columns
    // Sets all elements to nil
    // When a value is nil, it needs to be declared optional (?)
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count: rows*columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}