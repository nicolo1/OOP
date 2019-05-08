//
//  OptionsPreView.swift
//  BasicDrawing
//
//  Created by Sandy on 2019-02-15.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class OptionsPreView: UIView {

    var options = Options()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let possibleContext = UIGraphicsGetCurrentContext()
        
        if let theContext = possibleContext {
            
            let aShape = Rect(X: Double(20.0),
                              Y: Double(20.0),
                              theHeight: abs(Double(self.frame.size.height-40)),
                              theWidth: abs(Double(self.frame.size.width)-40))
            aShape.options = self.options
            aShape.draw(theContext)
        }
    }
    

}
