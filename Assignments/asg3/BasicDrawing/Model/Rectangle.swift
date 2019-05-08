//
//  Rectangle.swift
//  BasicDrawing
//
//  Created by Tabar, NicoloJanPaez on 2019-02-28.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class Rectangle: Shape{
    
    // ===============================================================
    // Draws rectangle on view
    // ===============================================================
    override func draw() {
        super.draw()
        
        let path = UIBezierPath(rect: CGRect(origin: self.origin, size: CGSize(width: endPoint.x - origin.x, height: endPoint.y-origin.y)))
        
        path.lineWidth = CGFloat(self.options.lineWidth)
        
        path.fill()
        path.stroke()
    }
}
