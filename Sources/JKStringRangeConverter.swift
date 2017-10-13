//
//  JKStringRangeConverter.swift
//  JKAttributedString
//
//  Created by Junmo KIM on 2017. 7. 30..
//
//

import Foundation

public struct JKStringRangeConverter {
    
    public static func utf16Location(of string: String, at location: String.Index) -> Int {
        return location.encodedOffset - string.utf16.startIndex.encodedOffset
    }
    
    public static func utf16Range(of string: String, for range: Range<String.Index>? = nil) -> NSRange {
        guard let range = range else {
            return NSRange(location: 0, length: string.utf16.count)
        }
        
        let lowerBound = range.lowerBound.encodedOffset
        let upperBound = range.upperBound.encodedOffset
        
        return NSRange(location: lowerBound,
                       length: upperBound - lowerBound)
    }
    
    public static func characterRange(of string: String, for range: NSRange? = nil) -> Range<String.Index>? {
        guard let range = range else {
            return string.startIndex ..< string.endIndex
        }
        
        guard
            let lowerBound16 = string.utf16.index(string.utf16.startIndex, offsetBy: range.location, limitedBy: string.utf16.endIndex),
            let upperBound16 = string.utf16.index(lowerBound16, offsetBy: range.length, limitedBy: string.utf16.endIndex),
            let lowerBound = String.Index(lowerBound16, within: string),
            let upperBound = String.Index(upperBound16, within: string)
            else { return nil }
        return lowerBound ..< upperBound
    }
}
