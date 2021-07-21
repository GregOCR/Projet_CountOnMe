//
//  CalcTestCase.swift
//  CountOnMeTests
//
//  Created by Greg on 15/07/2021.
//  Copyright © 2021 Greg. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalcTestCase: XCTestCase {
    
    var calc: Calc!
    
    override func setUp() {
        super.setUp()
        calc = Calc()
    }
    
    func addingToExpression(_ entries: String) {
        let splitEntries = entries.split(separator: " ").map { "\($0)" }
        splitEntries.forEach( { calc.addToExpression($0) } )
    }

    // tests multiple zero entries to not reiterate when is first number of a sequence
    func testMultipleZeroEntries() {
        // When
        addingToExpression("0 0 0")
        // Then
        XCTAssert(calc.getExpression() == "0")
    }
    // tests multiple dot entries to not reiterate when already exists in a sequence
    func testMultipleDotEntries() {
        // When
        addingToExpression(". . .")
        // Then
        XCTAssert(calc.getExpression() == "0.")
    }
    // tests operand entry after a dot
    func testOperandEntryAfterDot() {
        // When
        addingToExpression("1 . +")
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+"])
    }
    // tests useless numbers and dot when are at the end of a sequence
    func testUselessNumbersAndDot() {
        // When
        addingToExpression("1 . 0 0 + 0 0 . 6 0 0 −")
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+", "0.6", "−"])
    }
    // tests consecutive operands entries to change AND replace zero entry per numbers when is at the beginning of a sequence
    func testConsecutiveOperandsEntriesAndZeroEntryBeforeNumber() {
        addingToExpression("1 . 2 − + 0 3")
        XCTAssert(calc.getExpression().elements() == ["1.2", "+", "3"])
    }
    // tests operands priorities
    func testOperandsPriorities() {
        // When
        addingToExpression("1 + 1 − 3 × 5 ÷ 8")
        calc.resolveExpression()
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+", "1", "−", "3", "×", "5", "÷", "8\r=\r0.125"])
    }
    // tests AC button
    func testACButton() {
        // When
        addingToExpression("1 + 2")
        calc.resetExpression()
        // Then
        XCTAssert(calc.getExpression() == "0")
    }
    // tests CE button when current sequence is a number
    func testCEButtonWhenCurrentSequenceIsNumber() {
        // When
        addingToExpression("1 + 2")
        calc.deleteLastSequence()
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+"])
    }
    // tests CE button when current sequence is operand
    func testCEButtonWhenCurrentSequenceIsOperand() {
        // When
        addingToExpression("1 + 2 +")
        calc.deleteLastSequence()
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+", "2"])
    }
    // tests CE button when current sequence is a number containing dot
    func testCEButtonWhenCurrentSequenceIsNumberAndDot() {
        // When
        addingToExpression("1 + 2 .")
        calc.deleteLastSequence()
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+"])
    }
    // tests restarting expression when typing number after resolvation
    func testRestartingExpressionWhenNumberEntryAfterResolvation() {
        // When
        addingToExpression("1 + 2")
        calc.resolveExpression()
        addingToExpression("1 .")
        // Then
        XCTAssert(calc.getExpression() == "1.")
    }
}
