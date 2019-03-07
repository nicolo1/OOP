//
//  Cell.swift
//  Sudoku
//
//  Created by Tabar, NicoloJanPaez on 2019-02-14.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//

import Foundation

class Cell {
    public let MAX_NUMS = 9
    
    private var current_number: Int?
    private var solution_number: Int?
    private var posX: Int
    private var posY: Int
    
    init(x: Int, y: Int) {
        self.posX = x;
        self.posY = y;
    }
    func x() -> Int {
        return self.posX;
    }
    
    func y() -> Int {
        return self.posY;
    }
}
