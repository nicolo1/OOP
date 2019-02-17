//
//  Card.swift
//  assigment2
//
//  Created by Tabar, NicoloJanPaez on 2019-02-01.
//  Copyright © 2019 Tabar, NicoloJanPaez. All rights reserved.
//

import Foundation

struct Card{
    var isFaceUp = false
    var isMatched = false
    var wasSeen = 0
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
}
