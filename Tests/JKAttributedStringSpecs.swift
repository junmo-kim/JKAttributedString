//
//  JKAttributedStringSpecs.swift
//  JKAttributedStringTests
//
//  Created by Junmo KIM on 2017. 7. 30..
//
//

import XCTest
import Quick
import Nimble
@testable import JKAttributedString

class JKAttributedStringSpecs: QuickSpec {
    
    override func spec() {
        it("expected to behave as value type") { 
            var a = JKAttributedString(string: "string")
            let b = a
            a.append(JKAttributedString(string: "+"))
            
            expect(a) !== b
            expect(a._backing) !== b._backing
            expect(a.attributedString) != b.attributedString
            expect(a.attributedString) == NSAttributedString(string: "string+")
            expect(b.attributedString) == NSAttributedString(string: "string")
        }
        
        it("expected to initialized and generate attributed string") {
            expect(JKAttributedString(string: "string").attributedString)
                .to(equal(NSAttributedString(string: "string")))
            expect(
                JKAttributedString(string: "string",
                                   attributes: [NSForegroundColorAttributeName: UIColor.red])
                    .attributedString
                )
                .to(equal(
                    NSAttributedString(string: "string",
                                       attributes: [NSForegroundColorAttributeName: UIColor.red])
                ))
            expect(
                JKAttributedString(string: "string",
                                   attributes: [.color(.red)]).attributedString
                )
                .to(equal(
                    NSAttributedString(string: "string",
                                       attributes: [NSForegroundColorAttributeName: UIColor.red])
                ))
        }
        
        it("expected forward string properties") {
            let testString = "Doing 테스트 🎯 です。¶"
                    // UTF-8  1111113 3 31413 3 3 2
                    // UTF-16 1111111 1 11211 1 1 2
            let a = JKAttributedString(string: testString)
            expect(a.string) == testString
            expect(a.characters.count) == 16
            expect(a.utf8.count) == 32
            expect(a.utf16.count) == 17
        }
        
        it("expected to concat with + operator") {
            let expectedString = NSMutableAttributedString(string: "aString", attributes: [NSForegroundColorAttributeName: UIColor.red])
            expectedString.append(NSAttributedString(string: "bString", attributes: [NSForegroundColorAttributeName: UIColor.green]))
            
            expect(
                (JKAttributedString(string: "aString", attributes: [.color(.red)]) +
                 JKAttributedString(string: "bString", attributes: [.color(.green)])).attributedString)
                == expectedString
            expect((JKAttributedString(string: "", attributes: [.font(.systemFont(ofSize: 14))])
                + "ing").attributedString)
                == NSAttributedString(string: "ing")
            expect((JKAttributedString(string: "str", attributes: [.font(.systemFont(ofSize: 14))])
                + "ing").attributedString)
                == NSAttributedString(string: "string",
                                      attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
            
            expect(("str"
                + JKAttributedString(string: "", attributes: [.font(.systemFont(ofSize: 14))]))
                .attributedString)
                == NSAttributedString(string: "str")
            expect(("str" + JKAttributedString(
                string: "ing",
                attributes: [.font(.systemFont(ofSize: 14))])).attributedString
                )
                == NSAttributedString(string: "string",
                                      attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        }
        
        it("expected to get attributes") {
            let testString = "Doing 테스트 ".attributed([.color(.gray)])
                + "🎯 です。¶".attributed([.color(.blue)])
            expect(
                (testString.attributes(at: testString.index(testString.startIndex, offsetBy: 9))
                    .0[NSForegroundColorAttributeName] as? UIColor)?.description)
                == UIColor.gray.description
            
            expect(
                (testString.attributes(at: testString.index(testString.startIndex, offsetBy: 10))
                    .0[NSForegroundColorAttributeName] as? UIColor)?.description)
                == UIColor.blue.description
            
            expect(
                testString.index(testString.startIndex, offsetBy: 30, limitedBy: testString.endIndex)
                )
                .to(beNil())
        }
        
        context("with custom attribute") { 
            enum SystemFontAttribute: JKAttributeType {
                case normal(CGFloat)
                case bold(CGFloat)
                
                var name: String {
                    return NSFontAttributeName
                }
                
                var value: Any {
                    switch self {
                    case .normal(let size):
                        return UIFont.systemFont(ofSize: size)
                    case .bold(let size):
                        return UIFont.boldSystemFont(ofSize: size)
                    }
                }
            }
            
            it("expected to work with custom attribute") {
                let boldStr = "System".attributed([SystemFontAttribute.bold(20)]).attributedString
                let boldExpected = NSAttributedString(
                    string: "System",
                    attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)]
                )
                expect(boldStr) == boldExpected
            }
        }
    }
}

