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
            expect(JKAttributedString()).to(beAKindOf(JKAttributedString.self))
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
            let redStr = NSAttributedString(string: "string",
                                            attributes: [NSForegroundColorAttributeName: UIColor.red])
            expect(JKAttributedString(attributedString: redStr).attributedString)
                == redStr
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
        
        describe("concat with + operator") {
            context("between JKAttributedString", { 
                it("expected to concat", closure: { 
                    let expectedString = NSMutableAttributedString(string: "aString", attributes: [NSForegroundColorAttributeName: UIColor.red])
                    expectedString.append(NSAttributedString(string: "bString", attributes: [NSForegroundColorAttributeName: UIColor.green]))
                    
                    expect(
                        (JKAttributedString(string: "aString", attributes: [.color(.red)]) +
                            JKAttributedString(string: "bString", attributes: [.color(.green)])).attributedString)
                        == expectedString
                })
            })
            
            context("between JKAttributedString and NSAttributedString", {
                it("expected to concat", closure: {
                    let expectedString = NSMutableAttributedString(string: "str", attributes: [NSKernAttributeName: 0.5])
                    expectedString.append(NSAttributedString(string: "ing", attributes: [NSKernAttributeName: 1.2]))
                    
                    expect(("str".attributed([.kern(0.5)]) + NSAttributedString(string: "ing", attributes: [NSKernAttributeName: 1.2])).attributedString) == expectedString
                    expect(("".attributed([.kern(0.5)]) + NSAttributedString(string: "ing", attributes: [NSKernAttributeName: 1.2])).attributedString)
                        == NSAttributedString(string: "ing", attributes: [NSKernAttributeName: 1.2])
                    expect(("str".attributed([.kern(0.5)]) + NSAttributedString(string: "", attributes: [NSKernAttributeName: 1.2])).attributedString)
                        == NSAttributedString(string: "str", attributes: [NSKernAttributeName: 0.5])
                    
                    let expectedString2 = NSMutableAttributedString(string: "str", attributes: [NSLigatureAttributeName: 2])
                    expectedString2.append(NSAttributedString(string: "ing", attributes: [NSLigatureAttributeName: 3]))
                    expect((NSAttributedString(string: "str", attributes: [NSLigatureAttributeName: 2]) + "ing".attributed([.ligature(3)])).attributedString) == expectedString2
                    expect((NSAttributedString(string: "", attributes: [NSLigatureAttributeName: 2]) + "ing".attributed([.ligature(3)])).attributedString)
                        == NSAttributedString(string: "ing", attributes: [NSLigatureAttributeName: 3])
                    expect((NSAttributedString(string: "str", attributes: [NSLigatureAttributeName: 2]) + "".attributed([.ligature(3)])).attributedString)
                        == NSAttributedString(string: "str", attributes: [NSLigatureAttributeName: 2])
                })
            })
            
            context("between JKAttributedString and String", { 
                it("expected to concat", closure: { 
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
                    expect((""
                        + JKAttributedString(string: "ing", attributes: [.font(.systemFont(ofSize: 14))]))
                        .attributedString)
                        == NSAttributedString(string: "ing", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
                })
            })
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
                let boldStr = "SystemBold".attributed([SystemFontAttribute.bold(20)]).attributedString
                let boldExpected = NSAttributedString(
                    string: "SystemBold",
                    attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)]
                )
                expect(boldStr) == boldExpected
                
                let normalStr = JKAttributedString(string: "SystemNormal", attributes: [SystemFontAttribute.normal(12)]).attributedString
                expect(normalStr) == NSAttributedString(
                    string: "SystemNormal",
                    attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
                )
            }
        }
    }
}

