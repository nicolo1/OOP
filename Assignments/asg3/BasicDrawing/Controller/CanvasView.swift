//
//  CanvasView.swift
//  BasicDrawing
//
//  Created by Tabar, NicoloJanPaez on 2019-02-28.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    // ===============================================================
    // Global Variables
    // ===============================================================
    let RECTANGLE = 0
    let OVAL = 1
    let LINE = 2
    
    var shapes: [Shape] = Array()
    
    // points for shapes
    var origin: CGPoint = CGPoint(x:0,y:0)
    var endPoint: CGPoint = CGPoint(x:1,y:1)
    
    // used for initializing options
    var isInit = false
    
    var selectedShape = 0
    
    var currentOptions = Options()
    
    var currentShape: Shape? {
        didSet {
            if isInit {
                currentShape!.setOptions(newOptions: currentOptions)
            }
            setNeedsDisplay()
        }
    }
    
    // ===============================================================
    // Redraws the display
    // ===============================================================
    override func draw(_ rect: CGRect) {

        // draw all previously drawn shapes
        for index in shapes.indices {
            shapes[index].draw()
        }
        
        // draw current shape
        if currentShape != nil {
            currentShape!.draw()
        }
    }
    
    // ===============================================================
    // Touch events
    // ===============================================================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        origin = getPosition(touches: touches)
        endPoint = getPosition(touches: touches)
        
        // create shape
        isInit = true
        currentShape = updateShape()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = getPosition(touches: touches)
        
        currentShape = updateShape()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = getPosition(touches: touches)

        // finished drawing, append to array
        shapes.append(currentShape!)
        
        // user finished drawing, reset
        isInit = false
        currentShape = nil
    }
    
    // ============================================================
    // Get CGPoint position of user touch event
    // ============================================================
    func getPosition(touches: Set<UITouch>) -> CGPoint{
        let touch = touches.first!
        return touch.location(in:self)
    }
    
    // ============================================================
    // UpdateShape
    // ============================================================
    func updateShape() -> Shape {
        
        // create shape based on selected shape
        switch selectedShape {
        case RECTANGLE:
            return Rectangle(origin: origin, endPoint: endPoint)
        case LINE:
            return Line(origin: origin, endPoint: endPoint)
        case OVAL:
            return Oval(origin: origin, endPoint: endPoint)
        default:
            return Rectangle(origin: origin, endPoint: endPoint)
        }
    }
}
