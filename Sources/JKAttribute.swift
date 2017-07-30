//
//  JKAttribute.swift
//  JKAttributedString
//
//  Created by Junmo KIM on 2017. 7. 30..
//
//

import UIKit

public enum JKAttribute {
    case font(UIFont)
    case paragraphStyle(NSParagraphStyle)
    case paragraphStyleAttributes([JKAttributeParagraphStyle])
    case color(UIColor)
    case backgroundColor(UIColor)
    case ligature(Int)
    case kern(CGFloat)
    case strikeStyle(Int)
    case strikeColor(UIColor)
    case underline(NSUnderlineStyle)
    case underlineColor(UIColor)
    case strokeColor(UIColor)
    case strokeWidth(CGFloat)
    case shadow(NSShadow)
    case textEffect(String)
    case attachment(NSTextAttachment)
    case link(URL)
    case baselineOffset(CGFloat)
    case obliqueness(CGFloat)
    case expansion(CGFloat)
    case writingDirection([NSWritingDirection])
    case verticalGlyphForm(Int)
}

extension JKAttribute: JKAttributeType {
    public var name: String {
        switch self {
        case .font:
            return NSFontAttributeName
        case .paragraphStyle:
            return NSParagraphStyleAttributeName
        case .paragraphStyleAttributes:
            return NSParagraphStyleAttributeName
        case .color:
            return NSForegroundColorAttributeName
        case .backgroundColor:
            return NSBackgroundColorAttributeName
        case .ligature:
            return NSLigatureAttributeName
        case .kern:
            return NSKernAttributeName
        case .strikeStyle:
            return NSStrikethroughStyleAttributeName
        case .strikeColor:
            return NSStrikethroughColorAttributeName
        case .underline:
            return NSUnderlineStyleAttributeName
        case .underlineColor:
            return NSUnderlineColorAttributeName
        case .strokeColor:
            return NSStrokeColorAttributeName
        case .strokeWidth:
            return NSStrokeWidthAttributeName
        case .shadow:
            return NSShadowAttributeName
        case .textEffect:
            return NSTextEffectAttributeName
        case .attachment:
            return NSAttachmentAttributeName
        case .link:
            return NSLinkAttributeName
        case .baselineOffset:
            return NSBaselineOffsetAttributeName
        case .obliqueness:
            return NSObliquenessAttributeName
        case .expansion:
            return NSExpansionAttributeName
        case .writingDirection:
            return NSWritingDirectionAttributeName
        case .verticalGlyphForm:
            return NSVerticalGlyphFormAttributeName
        }
    }
    
    public var value: Any {
        switch self {
        case .font(let font):
            return font
        case .paragraphStyle(let style):
            return style
        case .paragraphStyleAttributes(let styles):
            return styles.style
        case .color(let color),
             .backgroundColor(let color):
            return color
        case .ligature(let ligature):
            return ligature
        case .kern(let kern):
            return kern
        case .strikeStyle(let style):
            return style
        case .strikeColor(let color):
            return color
        case .underline(let style):
            return style
        case .underlineColor(let color):
            return color
        case .strokeColor(let color):
            return color
        case .strokeWidth(let width):
            return width
        case .shadow(let shadow):
            return shadow
        case .textEffect(let effect):
            return effect
        case .attachment(let attachment):
            return attachment
        case .link(let link):
            return link
        case .baselineOffset(let offset):
            return offset
        case .obliqueness(let obliqueness):
            return obliqueness
        case .expansion(let expansion):
            return expansion
        case .writingDirection(let directions):
            return directions.map({ $0.rawValue }).reduce(0) { $0 | $1 }
        case .verticalGlyphForm(let form):
            return form
        }
    }
}

extension Array where Element == JKAttribute {
    var attributes: [String: Any] {
        return (self as [JKAttributeType]).attributes
    }
}
