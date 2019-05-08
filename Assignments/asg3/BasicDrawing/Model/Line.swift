//
//  Line.swift
//  BasicDrawing
//
//  Created by Tabar, NicoloJanPaez on 2019-02-28.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class Line: Shape {
    
    // ===============================================================
    // Draws line on view
    // ===============================================================
    override func draw(){
        super.draw()

        let path = UIBezierPath()

        // set both points of line
        path.move(to: self.origin)
        path.addLine(to: self.endPoint)

        path.lineWidth = CGFloat(self.options.lineWidth)
        
        path.fill()
        path.stroke()
    }
}
