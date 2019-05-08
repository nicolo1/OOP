//
//  DrawingView.swift
//  BasicDrawing
//
//  Created by Sandy on 2019-02-15.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class DrawingView: UIView {

    var shapeType = ShapeType.Rect;
    var theShapes = [Shape]()
    var initialPoint: CGPoint!
    var isThereAPartialShape : Bool = false
    var thePartialShape : Shape!
    
    var currentOption = Options()
    
    // -------------------------------------------------------------------
    // draw
    // -------------------------------------------------------------------
    override func draw(_ rect: CGRect) {
        let possibleContext = UIGraphicsGetCurrentContext()
        
        if let theContext = possibleContext {
            theContext.setLineWidth(1.0)
            
            for aShape in self.theShapes {
                aShape.draw(theContext)
            }
            
            if self.isThereAPartialShape {
                self.thePartialShape.options = currentOption
                self.thePartialShape.draw(theContext)
            }
            
        }
    }
    
    
    // ----------------------------------------------------------------------
    // user touches screen
    // ---------------------------------------------------------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        self.initialPoint = touch.location(in: self)
        self.isThereAPartialShape = true
        self.thePartialShape = Rect(X:Double(self.initialPoint.x),
                                    Y:Double(self.initialPoint.y),
                                    theHeight: Double(1.0),theWidth:Double(1.0))
        self.thePartialShape.options = self.currentOption
        
    }
    
    // ----------------------------------------------------------------------
    // user moves finger on screen
    // ----------------------------------------------------------------------
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let newPoint = touch.location(in: self)
        
        let topLeftPoint = CGPoint(x: self.initialPoint.x < newPoint.x ? self.initialPoint.x : newPoint.x,
                                   y: self.initialPoint.y < newPoint.y ? self.initialPoint.y : newPoint.y)
        
        if self.isThereAPartialShape {
            if shapeType == .Rect {
                self.thePartialShape = Rect(X: Double(topLeftPoint.x),
                                            Y: Double(topLeftPoint.y),
                                            theHeight: abs(Double(self.initialPoint.y-newPoint.y)),
                                            theWidth: abs(Double(self.initialPoint.x-newPoint.x)))
            } else if shapeType == .Oval{
                self.thePartialShape = Oval(X: Double(topLeftPoint.x),
                                            Y: Double(topLeftPoint.y),
                                            theHeight: abs(Double(self.initialPoint.y-newPoint.y)),
                                            theWidth: abs(Double(self.initialPoint.x-newPoint.x)))
            }
            else if shapeType == .Line{
                self.thePartialShape = Line(X1: Double(self.initialPoint.x),
                                            Y1: Double(self.initialPoint.y),
                                            X2: Double(newPoint.x),
                                            Y2: Double(newPoint.y))
            }
            
        }
        self.setNeedsDisplay()
    }
    
    // ----------------------------------------------------------------------
    // user lifts finger from screen
    // ----------------------------------------------------------------------
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let theShape = self.thePartialShape {
            self.theShapes.append(theShape)
        }
        self.isThereAPartialShape = false
    }
    

}
