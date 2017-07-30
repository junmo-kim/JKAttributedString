//
//  String+JKAttributedString.swift
//  JKAttributedString
//
//  Created by Junmo KIM on 2017. 7. 30..
//
//

import Foundation

extension String {
    
    public func attributed(_ attributes: [JKAttribute]) -> JKAttributedString {
        return self.attributed(attributes as [JKAttributeType])
    }
    
    public func attributed(_ attributes: [JKAttributeType]) -> JKAttributedString {
        return JKAttributedString(string: self, attributes: attributes.attributes)
    }
}
