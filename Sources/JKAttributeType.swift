//
//  JKAttributeType.swift
//  JKAttributedString
//
//  Created by Junmo KIM on 2017. 7. 30..
//
//

import Foundation

public protocol JKAttributeType {
    var name: String { get }
    var value: Any { get }
}

extension Array where Element == JKAttributeType {
    var attributes: [String: Any] {
        return reduce([String: Any]()) {
            var attributes = $0
            attributes[$1.name] = $1.value
            return attributes
        }
    }
}
