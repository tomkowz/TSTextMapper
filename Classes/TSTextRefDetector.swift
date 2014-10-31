//
//  TSTextRefDetector.swift
//
//  Created by Tomasz Szulc on 29/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

/// Types used internally

/// Basic protocol
protocol TSTextRef {
    var value: String {get set}
    var range: NSRange {get set}
}

/// Represents whitespace in presented text
struct TSWhitespaceRef: TSTextRef {
    var value: String
    var range: NSRange
}

/// Represents word in presented text
struct TSWordRef: TSTextRef {
    var value: String
    var range: NSRange
}

class TSTextRefDetector {
    class func textRefs(text: String, rangeOffset: Int) -> [TSTextRef] {
        var wordStart: Int = 0
        var wordEnd: Int = 0
        var wordStarted = false
        
        /// get words and white spaces
        var refs = [TSTextRef]()
        for idx in 0..<countElements(text) {
            let index = advance(text.startIndex, idx)
            let character = text.substringWithRange(Range(start: index, end: index.successor()))
            let trimmedCharacter = (character as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            if countElements(trimmedCharacter) > 0 {
                if !wordStarted {
                    wordStarted = true
                    wordStart = idx
                } else {
                    wordEnd = idx+1
                }
            } else {
                if wordStarted {
                    wordStarted = false
                    var range = NSMakeRange(wordStart, (wordEnd - wordStart > 0) ? wordEnd - wordStart : 1)
                    let str = (text as NSString).substringWithRange(range)
                    range.location += rangeOffset

                    refs.append(TSWordRef(value: str, range: range))
                    refs.append(TSWhitespaceRef(value: character, range: NSMakeRange(idx + rangeOffset, 1)))
                }
            }
            
            if idx == countElements(text) - 1 {
                wordEnd = idx+1
                wordStarted = false
                var range = NSMakeRange(wordStart, wordEnd - wordStart)
                let str = (text as NSString).substringWithRange(range)
                range.location += rangeOffset
                
                refs.append(TSWordRef(value: str, range: range))
            }
        }
        
//        self.debug(refs)
        return refs
    }
    
    private class func debug(refs: [TSTextRef]) {
        var fullString = ""
        for ref in refs {
            fullString += ref.value
        }
        
        println(fullString)
    }
}
