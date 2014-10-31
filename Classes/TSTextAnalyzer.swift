//
//  TSTextAnalyzer.swift
//
//  Created by Tomasz Szulc on 29/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

/// type used internally - represent a word or a whitespace
class TSText {
    let value: String
    let range: NSRange
    let size: CGSize
    var line: Int
    
    /// is a word or a whitespace
    let isWord: Bool
    
    init(ref: TSTextRef, size: CGSize, line: Int = 0) {
        self.value = ref.value
        self.range = ref.range
        self.size = size
        self.line = line
        self.isWord = (ref is TSWordRef)
    }
}

/// internal type represents a line of text
class TSTextLine {
    var number = 0
    var range = NSMakeRange(0, 0)
    var texts = [TSText]()
    
    var textRefsStringRepresentation: String {
        var output = ""
        for text in self.texts {
            output += text.value
        }
        
        return output
    }
}

class TSTextAnalyzer {
    /// text to be analized
    private var text: String
    
    /// font used to draw text
    private var font: UIFont
    
    /// size of view where text is drawed
    private var size: CGSize
    
    init(text: String, font: UIFont, size: CGSize) {
        self.text = text
        self.font = font
        self.size = size
    }
    
    func analize() -> [TSTextLine] {
        return self.mapLines(self.text, font: self.font, size: self.size)
    }
    
    private func mapLines(text: String, font: UIFont, size: CGSize) -> [TSTextLine] {
        func linesOfText(text: String, font: UIFont, viewSize: CGSize) -> [String] {
            
            let ctFont = CTFontCreateWithName(font.fontName, font.pointSize, nil)
            var attrString = NSMutableAttributedString(string: text)
            attrString.addAttribute(kCTFontAttributeName, value: ctFont, range: NSMakeRange(0, attrString.length))
            
            let framesetter = CTFramesetterCreateWithAttributedString(attrString)
            
            let path = CGPathCreateMutable()
            CGPathAddRect(path, nil, CGRect(x: 0, y: 0, width: size.width, height: 100_000))
            
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
            
            let lines = CTFrameGetLines(frame)
            var output = [String]()
            
            for line in lines as [CTLineRef] {
                let lineRange = CTLineGetStringRange(line)
                let range = NSMakeRange(lineRange.location, lineRange.length)
                
                output.append((text as NSString!).substringWithRange(range))
            }
            
            return output
        }
        
        /// get lines as strings
        var linesAsString = linesOfText(text, font, size)
        
        /// create line objects
        var lines = [TSTextLine]()

        var index = 0
        var rangeStart = 0
        for stringLine in linesAsString {
            /// detect all refs
            let refs = TSTextRefDetector.textRefs(stringLine, rangeOffset: rangeStart)
            
            /// create line
            let line = TSTextLine()
            line.number = index
            
            // /select range
            let rangeEnd = countElements(stringLine)
            line.range = NSMakeRange(rangeStart, rangeEnd)
            rangeStart += rangeEnd
            
            /// create text instances
            for ref in refs {
                let refSize = TSTextSize.size(ref.value, font: self.font, size: self.size)
                let text = TSText(ref: ref, size: refSize, line: line.number)
                line.texts.append(text)
            }
            
            lines.append(line)
            
            index++
        }
        
//        self.debug(lines)
        return lines
    }
    
    private func debug(lines: [TSTextLine]) {
        for line in lines {
            println("\(line.number) - (\(line.range.location), \(line.range.length)):, \(line.textRefsStringRepresentation)")
        }
    }
}