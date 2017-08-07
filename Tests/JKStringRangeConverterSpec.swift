//
//  JKStringRangeConverterSpec.swift
//  JKAttributedStringTests
//
//  Created by Junmo KIM on 2017. 7. 30..
//
//

import XCTest
import Quick
import Nimble
@testable import JKAttributedString

class JKStringRangeConverterSpec: QuickSpec {
    
    override func spec() {
        let testString = "Doing 테스트 🎯 です。¶"
                // UTF-8  1111113 3 31413 3 3 2
                // UTF-16 1111111 1 11211 1 1 2
        
        it("expected to convert character index to UTF-16 location") {
            expect(JKStringRangeConverter.utf16Location(of: testString, at: testString.index(testString.startIndex, offsetBy: 11))) == 12
        }
        
        it("expected to convert character range to UTF-16 range") {
            expect(NSValue(range: JKStringRangeConverter.utf16Range(of: testString)))
                == NSValue(range: NSRange(location: 0, length: 17))
            
            let lowerIndex = testString.index(testString.startIndex, offsetBy: 12)
            let upperIndex = testString.index(testString.startIndex, offsetBy: 14)
            let range = testString.range(of: "です")!
            expect(range) == lowerIndex..<upperIndex
            expect(NSValue(range: JKStringRangeConverter.utf16Range(of: testString, for: range)))
                == NSValue(range: NSRange(location: 13, length: 2))
        }
        
        it("expected to convert UTF-16 range to character range") { 
            expect(JKStringRangeConverter.characterRange(of: testString))
                == testString.startIndex..<testString.endIndex
            
            let lowerIndex = testString.index(testString.startIndex, offsetBy: 12)
            let upperIndex = testString.index(testString.startIndex, offsetBy: 14)
            let range = JKStringRangeConverter.characterRange(
                of: testString, for: NSRange(location: 13, length: 2)
            )!
            expect(range) == lowerIndex..<upperIndex
            expect(testString[range]) == "です"
        }
        
        it("expected to return nil when trying to convert with wrong UTF-16 range") { 
            expect(JKStringRangeConverter.characterRange(
                of: testString, for: NSRange(location: 13, length: 20))
                ).to(beNil())
        }
    }
}
