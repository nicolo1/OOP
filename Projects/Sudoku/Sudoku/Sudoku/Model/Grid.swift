//
//  Grid.swift
//  Sudoku
//
//  Created by Tabar, NicoloJanPaez on 2019-02-14.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//

import Foundation

struct Constants {
    static let NUM_REGIONS = 3
    
    static let GRID_DIMENSIONS = 9
    static let MAX_BLOCKS = 9
    static let MAX_ROWS = 9
    static let MAX_COLS = 9
    
    static let BLOCK_DIMENSIONS = 3
}

class Grid {
    let BLOCK_MODULO = Constants.MAX_BLOCKS * Constants.BLOCK_DIMENSIONS
    
    var blocks = [Region]()
    var rows = [Region]()
    var cols = [Region]()
    var cells = [Cell]()
    
    // event when user selects a cell
    func selectCell(posX: Int, posY: Int){
        
    }
    
    func initRegions() {
        for _ in 0...(Constants.GRID_DIMENSIONS - 1) {
            blocks.append(Region())
            rows.append(Region())
            cols.append(Region())
        }
    }
    // check if cell fits the line
    func checkLine(cell: Cell){
        
    }
    
    init() {
        initRegions()
        
        var index = 0
        var block = 0
        var blockRow = 0
        // iterate through all cells
        for indexY in 0...(Constants.MAX_ROWS - 1) {
            for indexX in 0...(Constants.MAX_COLS - 1) {
        
                // change block row
                if index != 0 && index % BLOCK_MODULO == 0 {
                    blockRow += 3
                }
                
                // change block column
                if index != 0 && index % Constants.BLOCK_DIMENSIONS == 0 {
                    block += 1
                }
                
                // change block row
                if index != 0 && index % Constants.GRID_DIMENSIONS == 0 {
                    block = blockRow
                }
                
                cells.append(Cell(x:indexX , y: indexY));
                rows[indexY].append(cell: cells[index])
                cols[indexX].append(cell: cells[index])
                blocks[block].append(cell: cells[index])
        
                index += 1
            }
        }
        printBlocks()
    }
    
    func printBlocks() {
        for index in 0...(Constants.GRID_DIMENSIONS - 1) {
            print("Block \(index): ")
            for index2 in 0...(Constants.GRID_DIMENSIONS - 1) {
                if index2 % 3 == 0 {
                    print()
                }
                print("[\(blocks[index].cells[index2].x()), \(blocks[index].cells[index2].y())]", terminator:"")
            }
            print()
        }
    }

    
    /*
     func initBlock(index: Int) -> [Cell ] {
     var block = [Cell]()
     for i in 0...(MAX_BLOCKS - 1) {
     block.append(Cell(x:0,y:0))
     }
     return block
     }
     
     
     
     func initRow(index: Int)-> [Cell] {
     var row = [Cell]()
     for i in 0...(MAX_BLOCKS - 1) {
     row.append(Cell(x:index,y:i))
     }
     return row
     }
     
     func initColumn(index: Int)-> [Cell] {
     var column = [Cell]()
     for i in 0...(MAX_BLOCKS - 1) {
     column.append(Cell(x:index,y:i))
     }
     return column
     }*/
}
