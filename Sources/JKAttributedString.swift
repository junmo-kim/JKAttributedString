//
//  JKAttributedString.swift
//  JKAttributedString
//
//  Created by Junmo KIM on 2017. 7. 30..
//
//

import Foundation

public struct JKAttributedString {
    
    typealias Converter = JKStringRangeConverter
    
    internal var _backing: NSMutableAttributedString
    
    public var string: String {
        return _backing.string
    }
    
    public var attributedString: NSAttributedString {
        return _backing.copy() as! NSAttributedString  // swiftlint:disable:this force_cast
    }
    
    public var utf8: String.UTF8View {
        return string.utf8
    }
    
    public var utf16: String.UTF16View {
        return string.utf16
    }
    
    public var characters: String.CharacterView {
        return string.characters
    }
    
    public var startIndex: String.Index {
        return string.startIndex
    }
    
    public var endIndex: String.Index {
        return string.endIndex
    }
    
    public func index(after i: String.Index) -> String.Index {
        return string.index(after: i)
    }
    
    public func index(before i: String.Index) -> String.Index {
        return string.index(before: i)
    }
    
    public func index(_ i: String.Index, offsetBy n: String.IndexDistance) -> String.Index {
        return string.index(i, offsetBy: n)
    }
    
    public func index(_ i: String.Index, offsetBy n: String.IndexDistance, limitedBy limit: String.Index) -> String.Index? {
        return string.index(i, offsetBy: n, limitedBy: limit)
    }
}

extension JKAttributedString {
    
    public init() {
        _backing = NSMutableAttributedString()
    }
    
    public init(string str: String, attributes attrs: [JKAttribute]) {
        _backing = NSMutableAttributedString(string: str, attributes: attrs.attributes)
    }
    
    public init(string str: String, attributes attrs: [JKAttributeType]) {
        _backing = NSMutableAttributedString(string: str, attributes: attrs.attributes)
    }
    
    public init(string str: String, attributes attrs: [String : Any]? = nil) {
        _backing = NSMutableAttributedString(string: str, attributes: attrs)
    }
    
    public init(attributedString attrStr: NSAttributedString) {
        _backing = attrStr.mutableCopy() as! NSMutableAttributedString  // swiftlint:disable:this force_cast
    }
    
    
    public func attributes(at location: String.Index) -> ([String : Any], effectiveRange: Range<String.Index>?) {
        let utf16Location = Converter.utf16Location(of: string, at: location)
        var range = NSRange(location: 0, length: _backing.length)
        let attributes = _backing.attributes(at: utf16Location, effectiveRange: &range)
        return (attributes, Converter.characterRange(of: string, for: range))
    }
    
    public func attribute(_ attrName: String, at location: String.Index) -> (Any?, effectiveRange: Range<String.Index>?) {
        var range = NSRange(location: 0, length: _backing.length)
        let attribute = _backing.attribute(attrName, at: Converter.utf16Location(of: string, at: location), effectiveRange: &range)
        return (attribute, Converter.characterRange(of: string, for: range))
    }
    
    public func attributedSubstring(from range: Range<String.Index>) -> JKAttributedString {
        let attributedString = _backing.attributedSubstring(from: Converter.utf16Range(of: string, for: range))
        return JKAttributedString(attributedString: attributedString)
    }
    
    public typealias EnumerationOptions = NSAttributedString.EnumerationOptions
    
    public func enumerateAttributes(in enumerationRange: Range<String.Index>? = nil,
                                    options opts: EnumerationOptions = [],
                                    using block: ([String : Any], Range<String.Index>, UnsafeMutablePointer<ObjCBool>) -> Swift.Void) {
        let range = Converter.utf16Range(of: string, for: enumerationRange)
        _backing.enumerateAttributes(in: range, options: opts) { (attributes, utf16Range, stop) in
            if let charctersRange = Converter.characterRange(of: string, for: utf16Range) {
                block(attributes, charctersRange, stop)
            }
        }
    }
    
    public func enumerateAttribute(_ attrName: String,
                                   in enumerationRange: Range<String.Index>? = nil,
                                   options opts: EnumerationOptions = [],
                                   using block: (Any?, Range<String.Index>, UnsafeMutablePointer<ObjCBool>) -> Swift.Void) {
        let range = Converter.utf16Range(of: string, for: enumerationRange)
        _backing.enumerateAttribute(attrName, in: range, options: opts) { (attribute, utf16Range, stop) in
            if let charctersRange = Converter.characterRange(of: string, for: utf16Range) {
                block(attribute, charctersRange, stop)
            }
        }
    }
}

extension JKAttributedString {
    
    public static func + (left: JKAttributedString, right: JKAttributedString) -> JKAttributedString {
        var base = left
        base.append(right)
        return base
    }
    
    public static func + (left: String, right: JKAttributedString) -> JKAttributedString {
        let attributes: [String: Any]? = {
            guard right.characters.count > 0 else { return nil }
            let (startAttributes, _) = right.attributes(at: right.string.startIndex)
            return startAttributes
        }()
        var base = JKAttributedString(string: left, attributes: attributes)
        base.insert(right, at: base.string.endIndex)
        return base
    }
    
    public static func + (left: JKAttributedString, right: String) -> JKAttributedString {
        var base = left
        let attributes: [String: Any]? = {
            if let lastCharIndex = base.string.index(base.string.endIndex, offsetBy: -1, limitedBy: base.string.startIndex) {
                let (endAttributes, _) = base.attributes(at: lastCharIndex)
                return endAttributes
            }
            return nil
        }()
        base.insert(JKAttributedString(string: right, attributes: attributes), at: base.string.endIndex)
        return base
    }
    
    public func attributed(_ attributes: [JKAttribute]) -> JKAttributedString {
        return self.attributed(attributes as [JKAttributeType])
    }
    
    public func attributed(_ attributes: [JKAttributeType]) -> JKAttributedString {
        var base = self
        base.setAttributes(attributes.attributes)
        return base
    }
    
    public func adding(attributes: [JKAttribute], for range: Range<String.Index>? = nil) -> JKAttributedString {
        return self.adding(attributes: (attributes as [JKAttributeType]), for: range)
    }
    
    public func adding(attributes: [JKAttributeType], for range: Range<String.Index>? = nil) -> JKAttributedString {
        var base = self
        base.addAttribute(attributes.attributes, range: range)
        return base
    }
}

extension JKAttributedString: Equatable {
    public static func ==(lhs: JKAttributedString, rhs: JKAttributedString) -> Bool {
        return lhs._backing.isEqual(to: rhs._backing)
    }
}

extension JKAttributedString {
    
    fileprivate mutating func _confirmUniquelyReferenced() {
        // Provide mutability to backing `NSMutableAttributedString` class instance
        // cf) https://github.com/apple/swift/blob/swift-4.0-branch/stdlib/public/SDK/Foundation/Data.swift
        if !isKnownUniquelyReferenced(&_backing) {
            _backing = _backing.mutableCopy() as! NSMutableAttributedString  // swiftlint:disable:this force_cast
        }
    }
    
    
    public mutating func setAttributes(_ attrs: [String : Any]?, range: Range<String.Index>? = nil) {
        _confirmUniquelyReferenced()
        _backing.setAttributes(attrs, range: Converter.utf16Range(of: string, for: range))
    }
    
    public mutating func addAttribute(_ name: String, value: Any, range: Range<String.Index>? = nil) {
        addAttribute([name: value], range: range)
    }
    
    public mutating func addAttribute(_ attribute: JKAttribute, range: Range<String.Index>? = nil) {
        addAttribute([attribute.name: attribute.value], range: range)
    }
    
    public mutating func addAttribute(_ attribute: JKAttributeType, range: Range<String.Index>? = nil) {
        addAttribute([attribute.name: attribute.value], range: range)
    }
    
    public mutating func addAttribute(_ attributes: [JKAttribute], range: Range<String.Index>? = nil) {
        addAttribute(attributes.attributes, range: range)
    }
    
    public mutating func addAttribute(_ attributes: [JKAttributeType], range: Range<String.Index>? = nil) {
        addAttribute(attributes.attributes, range: range)
    }
    
    public mutating func addAttribute(_ attributes: [String : Any], range: Range<String.Index>? = nil) {
        _confirmUniquelyReferenced()
        _backing.addAttributes(attributes, range: Converter.utf16Range(of: string, for: range))
    }
    
    public mutating func removeAttribute(_ name: String, range: Range<String.Index>? = nil) {
        _confirmUniquelyReferenced()
        _backing.removeAttribute(name, range: Converter.utf16Range(of: string, for: range))
    }
    
    
    public mutating func replaceCharacters(in range: Range<String.Index>? = nil, with str: String) {
        _confirmUniquelyReferenced()
        _backing.replaceCharacters(in: Converter.utf16Range(of: string, for: range), with: str)
    }
    
    public mutating func replaceCharacters(in range: Range<String.Index>? = nil, with attrString: NSAttributedString) {
        _confirmUniquelyReferenced()
        _backing.replaceCharacters(in: Converter.utf16Range(of: string, for: range), with: attrString)
    }
    
    public mutating func replaceCharacters(in range: Range<String.Index>? = nil, with attrString: JKAttributedString) {
        _confirmUniquelyReferenced()
        _backing.replaceCharacters(in: Converter.utf16Range(of: string, for: range), with: attrString._backing)
    }
    
    public mutating func insert(_ attrString: NSAttributedString, at loc: String.Index) {
        _confirmUniquelyReferenced()
        _backing.insert(attrString, at: Converter.utf16Location(of: string, at: loc))
    }
    
    public mutating func insert(_ attrString: JKAttributedString, at loc: String.Index) {
        _confirmUniquelyReferenced()
        _backing.insert(attrString._backing, at: Converter.utf16Location(of: string, at: loc))
    }
    
    public mutating func append(_ attrString: NSAttributedString) {
        _confirmUniquelyReferenced()
        _backing.append(attrString)
    }
    
    public mutating func append(_ attrString: JKAttributedString) {
        _confirmUniquelyReferenced()
        _backing.append(attrString._backing)
    }
    
    public mutating func deleteCharacters(in range: Range<String.Index>? = nil) {
        _confirmUniquelyReferenced()
        _backing.deleteCharacters(in: Converter.utf16Range(of: string, for: range))
    }
    
    public mutating func setAttributedString(_ attrString: NSAttributedString) {
        _confirmUniquelyReferenced()
        _backing.setAttributedString(attrString)
    }
    
    public mutating func setAttributedString(_ attrString: JKAttributedString) {
        _confirmUniquelyReferenced()
        _backing.setAttributedString(attrString._backing)
    }
}
