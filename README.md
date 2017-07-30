# JKAttributedString

`JKAttributedString` provides Swifty API for `NSAttributedString`.

[![Build Status](https://travis-ci.org/junmo-kim/JKAttributedString.svg?branch=master)](https://travis-ci.org/junmo-kim/JKAttributedString)

Sick of using `NSAttributedString` and `NSMutableAttributedString` on value typed Swift world?
This makes dealing with attributed string as easy as `String`.

## Features
* Value typed attributed string
* Typed attributes
* Easy concatination
* Character based range (not UTF-16 based NSRange!)
* Range converter between UTF-16 and character
* Support custom attributes

## How to Use
### Basic Usage
```swift
var aString = JKAttributedString(string: "Whatever",
                                 attributes: [.color(.gray), .font(.systemFont(ofSize: 12))])
aString.adding(attributes: [.color(.red)])  // Red "Whatever"

let bString = "Want".attributed([.font(.systemFont(ofSize: 20))])  // Size 20
// bString.adding( ... )  <- COMPILE ERROR

let cString = aString + " You " + bString
// Whatever You { color: red, size: 12 }Want{ size: 20 }

let dString = "Whenever You " + bString  // Size 20

let testString = "Doing 테스트 ".attributed([.color(.gray)])
    + "🎯 です。¶".attributed([.color(.blue)])
testString.attributes(at: testString.index(testString.startIndex, offsetBy: 9)) // Gray
testString.attributes(at: testString.index(testString.startIndex, offsetBy: 10)) // Blue
```

### Custom Attribute Type

```swift
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

let systemString = "System".attributed([SystemFontAttribute.bold(20)])
```
