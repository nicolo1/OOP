//
//  Token.swift
//  ChatApp
//
//  Created by Tabar, NicoloJanPaez on 2019-05-08.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

/* Token Class
 Description: UI used for when user wins
 */
@IBDesignable class TokenWon: Token {
    
    override func draw(_ rect: CGRect) {
        let tokenRect = UIBezierPath(roundedRect: self.bounds, cornerRadius: bounds.height * 0.20)
        tokenRect.addClip()
        
        tokenRect.fill();
        tokenRect.stroke();
    }
}
