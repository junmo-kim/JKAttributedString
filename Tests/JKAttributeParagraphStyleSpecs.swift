//
//  JKAttributeParagraphStyleSpecs.swift
//  JKAttributedStringTests
//
//  Created by Junmo KIM on 2017. 7. 31..
//
//

import XCTest
import Quick
import Nimble
@testable import JKAttributedString

class JKAttributeParagraphStyleSpecs: QuickSpec {
    
    override func spec() {
        let style: ([JKAttributeParagraphStyle]) -> NSParagraphStyle = {
            return $0.style
        }
        
        it("expected to generate paragraph style") {
            expect(style([.lineSpacing(90)]).lineSpacing) == 90
            expect(style([.paragraphSpacing(34)]).paragraphSpacing) == 34
            expect(style([.alignment(.right)]).alignment) == NSTextAlignment.right
            expect(style([.firstLineHeadIndent(71)]).firstLineHeadIndent) == 71
            expect(style([.headIndent(289)]).headIndent) == 289
            expect(style([.tailIndent(11)]).tailIndent) == 11
            expect(style([.lineBreakMode(.byClipping)]).lineBreakMode) == NSLineBreakMode.byClipping
            expect(style([.minimumLineHeight(22)]).minimumLineHeight) == 22
            expect(style([.maximumLineHeight(78)]).maximumLineHeight) == 78
            expect(style([.baseWritingDirection(.rightToLeft)]).baseWritingDirection)
                == NSWritingDirection.rightToLeft
            expect(style([.lineHeightMultiple(5.5)]).lineHeightMultiple) == 5.5
            expect(style([.paragraphSpacingBefore(55)]).paragraphSpacingBefore) == 55
            expect(style([.hyphenationFactor(7.6)]).hyphenationFactor) == 7.6
            
            expect(style([.tabStops(
                [NSTextTab(textAlignment: .right, location: 0.5, options: [:])])]
                ).tabStops)
                == [NSTextTab(textAlignment: .right, location: 0.5, options: [:])]
            expect(style([.defaultTabInterval(3.87)]).defaultTabInterval) == 3.87
            
            if #available(iOS 9.0, *) {
                expect(style([.allowsDefaultTighteningForTruncation(true)])
                    .allowsDefaultTighteningForTruncation) == true
            }
        }
    }
}
