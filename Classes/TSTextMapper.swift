//
//  TSTextMapper.swift
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class TSTextProxy {
    let value: String
    
    init(_ text: TSText) {
        self.value = text.value
    }
    
    init(_ text: String) {
        self.value = text
    }
}
    
class TSTextMapper {
    
    private enum Method {
        case All
        case Ranges
    }
    
    /// font of text
    private let font: UIFont
    
    /// size of view where text is presented
    private let viewSize: CGSize
    
    /**
    Internal view where analyzed text is drawed,
    Coordinates of taps are used to detect which text is tapped
    */
    private var view: TSTextSceneView?
    
    /// lines of analyzed text. Lines contain words
    private var lines: [TSTextLine] = [TSTextLine]()
    
    /// ranges specified by user. Text in ranges is able to be selected
    private var ranges: [NSRange] = [NSRange]()
    
    /// specifies which method is used
    private var method: Method = .All
    
    private var texts: [TSText] {
        var objects = [TSText]()
        for line in lines {
            for text in line.texts {
                objects.append(text)
            }
        }
        
        return objects
    }
    
    init(font: UIFont, viewSize: CGSize) {
        self.font = font
        self.viewSize = viewSize
    }
    
    func mapTextAndMakeAllTappable(text: String) {
        self.method = .All
        self.map(text)
    }
    
    func mapTextWithTappableRanges(ranges: [NSRange], text: String) {
        self.method = .Ranges
        self.map(text)
        self.ranges = ranges
    }
    
    private func map(text: String) {
        let analyzer = TSTextAnalyzer(text: text, font: self.font, size: self.viewSize)
        self.lines = analyzer.analize()
        self.debug()
    }
    
    private func debug() {
        let debugView = TSTextSceneView(size: self.viewSize, texts: self.texts, font: self.font)
        debugView.prepare()
        let debugImage = debugView.snapshot()
        println("debug")
    }
    
    func textForPoint(point: CGPoint) -> TSTextProxy? {
        if self.texts.count == 0 {
            return nil
        }
        
        if self.view == nil {
            self.view = TSTextSceneView(size: self.viewSize, texts: self.texts, font: self.font)
            self.view!.prepare()
        }
        
        if let node = self.view!.nodeForPoint(point) {
//            println("node = \(node.text.value), \(node.text.range.location), \(node.text.range.length)")
            switch self.method {
            case .All:
                return TSTextProxy(node.text) /// if .All method is selected return tapped text
            
            case .Ranges:
                /// Find range contained inside tapped node

                var selectedRange: NSRange?
                for r in self.ranges {
                    if node.text.range.containsRange(r) {
                        selectedRange = r
                        break
                    }
                }
        
                if let range = selectedRange {
                    /// range matches the node, get text, translate selected range to match range in the node.
                    let text = (node.text.value as NSString)
                    let location = range.location - node.text.range.location
                    let length = range.length - location
                    
                    if length > 0 {
                        /// get the text with the new range
                        let textInRange = text.substringWithRange(NSMakeRange(location, length))
                        let textSize = TSTextSize.size(textInRange, font: self.font, size: self.viewSize)
                        
                        /// simulate frame of node with `textInRange` and check if it contains touched point
                        let textInRangeNodeFrame = CGRectMake(node.frame.minX, node.frame.minY, textSize.width, textSize.height)
                        if CGRectContainsPoint(textInRangeNodeFrame, point) {
                            return TSTextProxy(textInRange)
                        }
                    }
                }
                
                return nil
            }
        }
        
        return nil
    }
}

public func == (lhs: NSRange, rhs: NSRange) -> Bool {
    return lhs.location == rhs.location && lhs.length == rhs.length
}

extension NSRange: Equatable {
    func containsRange(r: NSRange) -> Bool {
        let start = self.location
        let end = start + self.length
        return (r.location >= start) && ((r.location + r.length) <= end)
    }
}
