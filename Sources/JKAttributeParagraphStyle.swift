//
//  JKAttributeParagraphStyle.swift
//  JKAttributedString
//
//  Created by Junmo KIM on 2017. 7. 30..
//
//

import UIKit

public enum JKAttributeParagraphStyle {
    case lineSpacing(CGFloat)
    case paragraphSpacing(CGFloat)
    case alignment(NSTextAlignment)
    case firstLineHeadIndent(CGFloat)
    case headIndent(CGFloat)
    case tailIndent(CGFloat)
    case lineBreakMode(NSLineBreakMode)
    case minimumLineHeight(CGFloat)
    case maximumLineHeight(CGFloat)
    case baseWritingDirection(NSWritingDirection)
    case lineHeightMultiple(CGFloat)
    case paragraphSpacingBefore(CGFloat)
    case hyphenationFactor(Float)
    
    case tabStops([NSTextTab])
    case defaultTabInterval(CGFloat)
    
    @available(iOS 9.0, *)
    case allowsDefaultTighteningForTruncation(Bool)
}

extension Array where Element == JKAttributeParagraphStyle {
    var style: NSParagraphStyle {
        return self.reduce(NSMutableParagraphStyle()) {
            switch $1 {
            case .lineSpacing(let lineSpacing):
                $0.lineSpacing = lineSpacing
            case .paragraphSpacing(let paragraphSpacing):
                $0.paragraphSpacing = paragraphSpacing
            case .alignment(let alignment):
                $0.alignment = alignment
            case .firstLineHeadIndent(let firstLineHeadIndent):
                $0.firstLineHeadIndent = firstLineHeadIndent
            case .headIndent(let headIndent):
                $0.headIndent = headIndent
            case .tailIndent(let tailIndent):
                $0.tailIndent = tailIndent
            case .lineBreakMode(let lineBreakMode):
                $0.lineBreakMode = lineBreakMode
            case .minimumLineHeight(let minimumLineHeight):
                $0.minimumLineHeight = minimumLineHeight
            case .maximumLineHeight(let maximumLineHeight):
                $0.maximumLineHeight = maximumLineHeight
            case .baseWritingDirection(let baseWritingDirection):
                $0.baseWritingDirection = baseWritingDirection
            case .lineHeightMultiple(let lineHeightMultiple):
                $0.lineHeightMultiple = lineHeightMultiple
            case .paragraphSpacingBefore(let paragraphSpacingBefore):
                $0.paragraphSpacingBefore = paragraphSpacingBefore
            case .hyphenationFactor(let hyphenationFactor):
                $0.hyphenationFactor = hyphenationFactor
                
            case .tabStops(let tabStops):
                $0.tabStops = tabStops
            case .defaultTabInterval(let defaultTabInterval):
                $0.defaultTabInterval = defaultTabInterval
                
            case .allowsDefaultTighteningForTruncation(let allowsDefaultTighteningForTruncation):
                if #available(iOS 9.0, *) {
                    $0.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
                }
            }
            return $0
        }
    }
}
