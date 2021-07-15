//
//  Extensions.swift
//  CountOnMe
//
//  Created by Greg on 07/07/2021.
//  Copyright © 2021 Greg. All rights reserved.
//

import UIKit

extension UIView {
    func shake() {
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
    func scrollToBottom() {
        self.scrollRangeToVisible(NSMakeRange(self.text.count - 1, 1))
    }
}

extension String {
    func isStringZero() -> Bool {
        var result = false
        if self == "0" {
            result = true
        }
        return result
    }
    func isFloatZero() -> Bool {
        var result = false
        if Float(self) == 0 {
            result = true
        }
        return result
    }
    func isDot() -> Bool {
        var result = false
        if self == "." {
            result = true
        }
        return result
    }
    func isOperand() -> Bool {
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
    func isLenghtedOne() -> Bool {
        return self.count == 1
    }
    func containsDot() -> Bool {
        return self.contains(".")
    }
    func containsResult() -> Bool {
        return self.contains("=")
    }
}

extension Array where Element == String {
    func isLenghtedOne() -> Bool {
        return self.count == 1
    }
}
