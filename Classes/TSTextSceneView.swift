//
//  TSTextSceneView.swift
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class TSTextSceneView: UIView {
    let texts: [TSText] = [TSText]()
    let font: UIFont = UIFont()
    
    init(size: CGSize, texts: [TSText], font: UIFont) {
        self.texts = texts
        self.font = font
        super.init(frame: CGRectMake(0, 0, size.width, size.height))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Call method before `wordForPoint:`.
    func prepare() {
        var offsetX: CGFloat = 0.0
        var previousLine: Int = 0
        
        // Enumerate texts, calculate rect, create view and draw text in created view
        for text in self.texts {
            /// reset offset
            let tappableTextLine = text.line
            if (previousLine != tappableTextLine) {
                previousLine = tappableTextLine
                offsetX = 0
            }
            
            /// calculate rect
            let y = CGFloat(text.size.height * CGFloat(text.line))
            let rect = CGRectMake(offsetX, y, text.size.width, text.size.height)
            offsetX = rect.maxX
            
            /// add view and draw text
            let node = TSTextNodeView(text: text, frame: rect)
            node.backgroundColor = UIColor.blueColor()
            self.addSubview(node)
        }
    }
    
    /// Return text as `WMWordProxy` if found, otherwise nil
    func nodeForPoint(point: CGPoint) -> TSTextNodeView? {
        for view in self.subviews as [TSTextNodeView] {
            if CGRectContainsPoint(view.frame, point) {
                return view
            }
        }
        
        return nil
    }
    
    /// Return snapshot of the view
    func snapshot() -> UIImage {
        for view in self.subviews as [TSTextNodeView] {
            view.drawWord(self.font)
        }
        
        var image = UIImage()
        if self.texts.count > 0 {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
            self.layer.renderInContext(UIGraphicsGetCurrentContext())
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return image
    }
}
