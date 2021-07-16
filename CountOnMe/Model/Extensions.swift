//
//  Extensions.swift
//  CountOnMe
//
//  Created by Greg on 07/07/2021.
//  Copyright © 2021 Greg. All rights reserved.
//

import UIKit

extension UIView {
    internal func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}

extension UITextView {
    internal func scrollToBottom() {
        self.scrollRangeToVisible(NSMakeRange(self.text.count - 1, 1))
    }
}

extension String {
    internal func isStringZero() -> Bool {
        var result = false
        if self == "0" {
            result = true
        }
        return result
    }
    internal func isFloatZero() -> Bool {
        var result = false
        if Float(self) == 0 {
            result = true
        }
        return result
    }
    internal func isDot() -> Bool {
        var result = false
        if self == "." {
            result = true
        }
        return result
    }
    internal func isOperand() -> Bool {
        var result = false
        let operands = ["÷", "×", "−", "+"]
        operands.forEach {
            if self.contains($0) {
                result = true
                return
            }
        }
        return result
    }
    internal func isLenghtOne() -> Bool {
        return self.count == 1
    }
    internal func containsDot() -> Bool {
        return self.contains(".")
    }
    internal func containsResult() -> Bool {
        return self.contains("=")
    }
    internal func elements() -> [String] {
        return self.split(separator: " ").map { "\($0)" }
    }
    internal func currentSequence() -> String {
        return self.elements().last!
    }
    internal func hasEnoughElementsToResolve() -> Bool {
        return self.elements().count > 2
    }
}

extension Array where Element == String {
    internal func isLenghtOne() -> Bool {
        return self.count == 1
    }
}
