//
//  GridView.swift
//  ChatApp
//
//  Created by Tabar, NicoloJanPaez on 2019-05-08.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class GridView: UIView {
    public let MAX_MOVES = 42
    public let ROW_SIZE = 6
    public let COL_SIZE = 7

    var theTokens: [Token]!
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        for index in theTokens.indices {
            theTokens[index].draw(rect)
        }
    }
    
    public func buildGrid() {
        
    }

    
}
