//
//  Shape.swift
//  BasicDrawing
//
//  Created by Tabar, NicoloJanPaez on 2019-02-28.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class Shape {
    
    // ===============================================================
    // Constructor
    // ===============================================================
    init(origin: CGPoint, endPoint: CGPoint) {
        self.width = CGFloat(0)
        self.origin = CGPoint(x: origin.x,y: origin.y)
        self.endPoint = CGPoint(x: endPoint.x,y: endPoint.y)
        self.options = Options()
    }
    
    // ===============================================================
    // Parent draw function that initializes options
    // ===============================================================
    func draw () {
        self.options.fillColor.setFill()
        UIColor(cgColor: self.options.lineColor).setStroke()
    }
    
    func setOptions(newOptions: Options) {
        self.options = newOptions
    }
    
    // ===============================================================
    // Properties
    // ===============================================================
    internal var options: Options
    internal var width = CGFloat(0)
    internal var origin: CGPoint
    internal var endPoint: CGPoint
}
