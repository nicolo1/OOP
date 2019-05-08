//
//  Options.swift
//  BasicDrawing
//
//  Created by Tabar, NicoloJanPaez on 2019-02-28.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class Options {
    
    // ===============================================================
    // Constructors
    // ===============================================================
    init(){
        fillSwitch = false
        fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        lineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lineWidth = 5
    }
    
    init(isFill: Bool, fill: UIColor, lineColor: CGColor, lineWidth: Int){
        self.fillSwitch = isFill
        
        // set fillColor based on switch
        if self.fillSwitch {
            self.fillColor = fill
        } else {
            self.fillColor = UIColor.clear
        }
        
        self.lineColor = lineColor
        self.lineWidth = lineWidth
    }
    
    // ===============================================================
    // Properties
    // ===============================================================
    var fillSwitch: Bool
    var fillColor: UIColor
    var lineColor: CGColor
    var lineWidth: Int
}
