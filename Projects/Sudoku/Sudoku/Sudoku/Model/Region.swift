//
//  Line.swift
//  Sudoku
//
//  Created by Nicolo Tabar on 2019-03-05.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//

import Foundation

class Region {
    
    public let NUM_CELLS = 9
    
    internal var cells: [Cell]
    
    init() {
        self.cells = []
    }
    
    init(cells: [Cell]) {
        self.cells = cells
    }
    
    func checkComplete() {
        
    }
    
    func append(cell: Cell) {
        self.cells.append(cell)
    }
}

