//
//  CustomTextField.swift
//  Notey
//
//  Created by Antonija Pek on 13/02/16.
//  Copyright © 2016 Antonija Pek. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    var leftMargin: CGFloat = 20.0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftMargin
        return newBounds
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftMargin
        return newBounds
        
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        let grayBorder: UIColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.0)
        self.layer.borderColor = grayBorder.CGColor
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
