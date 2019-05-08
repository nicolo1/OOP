//
//  Token.swift
//  ChatApp
//
//  Created by Tabar, NicoloJanPaez on 2019-05-08.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

/* Token Class
 Description: Describes the base token class
 */
@IBDesignable class Token: UIView {
    @IBInspectable internal var token = "X" {didSet {setNeedsLayout()}}
    @IBInspectable internal var tokenTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable internal var tokenBackgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    @IBInspectable internal var tokenBorderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    @IBInspectable private var isInPlay = false
    
    lazy internal var tokenLabel = createLabel()
    
    internal func createLabel() ->UILabel {
        let label = UILabel();
        label.text = self.token
        label.textColor = self.tokenTextColor
        addSubview(label)
        return label
    }
    
    internal var font:UIFont {
        get {
            let minLengthOfToken = self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : bounds.size.width
            let fontSize = minLengthOfToken * 0.8
            return UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        }
    }
    
    internal var attrValue: NSAttributedString {
        get {
            return NSAttributedString(string: self.token, attributes:[.font:self.font])
        }
    }
    
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        
        self.tokenLabel.attributedText = attrValue
        self.tokenLabel.frame.size = CGSize.zero
        self.tokenLabel.sizeToFit()
        
        // put label in center of widget
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let halfWidth = self.tokenLabel.bounds.width/2
        let halfHeight = self.tokenLabel.bounds.height/2
        self.tokenLabel.frame.origin = CGPoint(x:center.x-halfWidth, y:center.y-halfHeight)
    }
    
    override func draw(_ rect: CGRect) {
        let tokenRect = UIBezierPath(rect: self.bounds)
        tokenRect.addClip()
        
        if self.isInPlay {
            drawTokenInPlay()
            /*
             if self.isWinningToken {
             tokenWinningBackgroundColor.setFill()
             }
            */
        } else {
            drawTokenNotInPlay()
        }
        tokenRect.fill();
        tokenRect.stroke();
    }
    
    internal func drawTokenInPlay() {
        self.tokenBackgroundColor.setFill()
        self.tokenLabel.text = self.token
        self.tokenBorderColor.setStroke()
    }
    
    internal func drawTokenNotInPlay () {
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        self.tokenLabel.text = ""
        self.tokenBorderColor.setStroke()
    }
    
}
