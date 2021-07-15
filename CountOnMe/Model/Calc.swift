//
//  Calc.swift
//  CountOnMe
//
//  Created by Greg on 06/07/2021.
//  Copyright © 2021 Greg. All rights reserved.
//

import Foundation

protocol CalcDelegate: AnyObject {
    func updateDataScreenCalculator()
}

class Calc {
        
    weak var delegate: CalcDelegate?
    
    private let operandsWithPriorities = ["÷", "×", "−", "+"]
    
    private var expression = "0" {
        didSet {
            self.sendDataScreenCalculator()
        }
    }
        
    private var expressionElements: [String] {
        return self.expression.split(separator: " ").map { "\($0)" }
    }
    
    private var currentSequence: String {
        return self.expressionElements.last!
    }
    
    public var expressionHasEnoughElements: Bool {
        return self.expressionElements.count > 2
    }
    
    public func getExpression() -> String {
        return self.expression
    }
    
    public func getExpressionElements() -> [String] {
        return self.expressionElements
    }
    
    public func getCurrentSequence() -> String {
        return self.currentSequence
    }
    
    public func addToExpression(_ entry: String) {
        if currentSequence.containsResult() {
            resetExpression()
        }
        if entryIsAllowedToBeAddedToExpression(with: entry) {
            if entry.isOperand() && currentSequence.isOperand() {
                self.expression = String(self.expression.dropLast(3))
            }
            if !entry.isDot() && currentSequence.isStringZero() {
                self.expression = String(self.expression.dropLast() + entry)
                return
            }
            self.expression.append(entry)
        }
    }
    
    public func addOperand(_ operand: String) {
        avoidZerosAndPointAtEndOfSequence()
        addToExpression(" \(operand) ")
    }
    
    public func deleteLastSequence() {
        var droplastRange = currentSequence.count
        if currentSequence.isOperand() {
            droplastRange = 3
        }
        self.expression = String(self.expression.dropLast(droplastRange))
    }
    
    public func resolveExpression() {
        avoidZerosAndPointAtEndOfSequence()

        var expressionToResolve = expressionElements // Create a local copy of expression's elements

        while expressionToResolve.count != 1 { // while expression isn't counting 1 ...
            for operandIndex in 0...operandsWithPriorities.count-1 { // calculate it in the priority of operands
                while (expressionToResolve.firstIndex(of: operandsWithPriorities[operandIndex]) != nil) {
                    let leftIndex = expressionToResolve.firstIndex(of: operandsWithPriorities[operandIndex])!-1
                    let rightIndex = expressionToResolve.firstIndex(of: operandsWithPriorities[operandIndex])!+1
                    let leftNumber = expressionToResolve[leftIndex]
                    let rightNumber = expressionToResolve[rightIndex]
                    
                    var result = Double()
                    
                    switch operandsWithPriorities[operandIndex] {
                    case "÷": result = Double(leftNumber)! / Double(rightNumber)!
                    case "×": result = Double(leftNumber)! * Double(rightNumber)!
                    case "−": result = Double(leftNumber)! - Double(rightNumber)!
                    case "+": result = Double(leftNumber)! + Double(rightNumber)!
                    default:
                        break
                    }
                    expressionToResolve.removeSubrange(leftIndex...rightIndex)
                    expressionToResolve.insert(String(result), at: leftIndex)
                }
            }
        }
        addToExpression("\r=\r\(NSNumber(value: Double(expressionToResolve.first!)!).decimalValue)")
    }
    
    public func resetExpression() {
        self.expression = "0"
    }
    
    private func avoidZerosAndPointAtEndOfSequence() {
        if currentSequence.containsDot() {
            var currentSequenceComponents = currentSequence.components(separatedBy: ".")
            var numberOfCharactersToDelete = 0
            while currentSequenceComponents[1].last == "0" { // while a zero is at the end of the sequence after the dot
                numberOfCharactersToDelete += 1 // count a character to delete
                currentSequenceComponents[1] = String(currentSequenceComponents[1].dropLast()) // delete the zero at the end of the sequence to check
            }
            if currentSequenceComponents[1].isEmpty { // if count of numbers after the dot is 0, add 1 character to delete in expression because the left dot
                numberOfCharactersToDelete += 1
            }
            self.expression = String(self.expression.dropLast(numberOfCharactersToDelete)) // delete useless typed numbers and dot in expression
        }
    }
    
    private func entryIsAllowedToBeAddedToExpression(with entry: String) -> Bool {
        var result = true
        if entry.isStringZero() && currentSequence.isStringZero() || entry.isDot() && (currentSequence.containsDot() || currentSequence.isOperand()) {
            result = false
        }
        return result
    }
    
    private func sendDataScreenCalculator() {
        self.delegate?.updateDataScreenCalculator()
    }
}
