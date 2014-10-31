//
//  TSTextNodeView.swift
//
//  Created by Tomasz Szulc on 30/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class TSTextNodeView: UIImageView {
    let text: TSText
    
    init(text: TSText, frame: CGRect) {
        self.text = text
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// used internally for performance purposes
    private var isDrawn = false
    
    func drawWord(font: UIFont) {
        /// check if already drawn
        if self.isDrawn {
            return
        }
        
        self.isDrawn = true
        /// create attributes
        let attr = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSBackgroundColorAttributeName: UIColor(white: 0.7, alpha: 1.0)
        ]
        
        /// draw text
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        (self.text.value as NSString).drawInRect(self.bounds, withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = image
    }
}
