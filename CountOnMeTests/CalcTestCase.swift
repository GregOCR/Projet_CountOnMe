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
    // tests multiple zero entries to not reiterate when is first number of a sequence
    func testGivenExpressionIsStarting_WhenEntriesAreZeroZeroZero_ThenExpressionIsZero() {
        // When
        calc.addNumberOrDotToExpression("0")
        calc.addNumberOrDotToExpression("0")
        calc.addNumberOrDotToExpression("0")
        // Then
        XCTAssert(calc.getExpression() == "0")
    }
    // tests multiple dot entries to not reiterate when already exists in a sequence
    func testGivenExpressionIsStarting_WhenEntriesAreDotDotDot_ThenExpressionIsZeroDot() {
        // When
        calc.addNumberOrDotToExpression(".")
        calc.addNumberOrDotToExpression(".")
        calc.addNumberOrDotToExpression(".")
        // Then
        XCTAssert(calc.getExpression() == "0.")
    }
    // tests operand entry after a dot
    func testGivenExpressionIsStarting_WhenEntriesAreOneDotPlus_ThenExpressionIsOneAndPlus() {
        // When
        calc.addNumberOrDotToExpression("1")
        calc.addNumberOrDotToExpression(".")
        calc.addOperandToExpression("+")
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+"])
    }

    // tests useless numbers and dot when are at the end of a sequence
    func testGivenExpressionIsStarting_WhenEntriesAreOneDotZeroZeroPlusZeroZeroDotSixZeroZeroZeroMinus_ThenExpressionElementsAreOneAndPlusAndZeroDotSixAndMinus() {
        // When
        calc.addNumberOrDotToExpression("1")
        calc.addNumberOrDotToExpression(".")
        calc.addNumberOrDotToExpression("0")
        calc.addNumberOrDotToExpression("0")
        calc.addOperandToExpression("+")
        calc.addNumberOrDotToExpression("0")
        calc.addNumberOrDotToExpression("0")
        calc.addNumberOrDotToExpression(".")
        calc.addNumberOrDotToExpression("6")
        calc.addNumberOrDotToExpression("0")
        calc.addNumberOrDotToExpression("0")
        calc.addOperandToExpression("−")
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+", "0.6", "−"])
    }
    // tests consecutive operands entries to change AND replace zero entry per numbers when is at the beginning of a sequence
    func testGivenExpressionIsStarting_WhenEntriesAreOneMinusPlusZeroTwoThreeEqual_ThenExpressionElementsAreOneAndPlusAndTwoAndCarriageReturnEqualCarriageReturnAndTwentyFour() {
        // When
        calc.addNumberOrDotToExpression("1")
        calc.addOperandToExpression("−")
        calc.addOperandToExpression("+")
        calc.addNumberOrDotToExpression("0")
        calc.addNumberOrDotToExpression("2")
        calc.addNumberOrDotToExpression("3")
        calc.resolveExpression()
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+", "23", "\r=\r", "24"])
    }
    // tests operands priorities
    func testGivenExpressionIsStarting_WhenEntriesAreOnePlusOneMinusThreeMultiplyFiveDiviseEightEqual_ThenExpressionElementsAreOneAndPlusAndOneAndMinusAndThreeAndMultiplyAndFiveAndDiviseAndEightAndCarriageReturnEqualCarriageReturnAndZeroDotOneHundredTwentyFive() {
        // When
        calc.addNumberOrDotToExpression("1")
        calc.addOperandToExpression("+")
        calc.addNumberOrDotToExpression("1")
        calc.addOperandToExpression("−")
        calc.addNumberOrDotToExpression("3")
        calc.addOperandToExpression("×")
        calc.addNumberOrDotToExpression("5")
        calc.addOperandToExpression("÷")
        calc.addNumberOrDotToExpression("8")
        calc.resolveExpression()
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+", "1", "−", "3", "×", "5", "÷", "8", "\r=\r", "0.125"])
    }
    // tests AC button
    func testGivenExpressionIsStarting_WhenEntriesAreOnePlusTwoAC_ThenExpressionIsZero() {
        // When
        calc.addNumberOrDotToExpression("1")
        calc.addOperandToExpression("+")
        calc.addNumberOrDotToExpression("2")
        calc.resetExpression()
        // Then
        XCTAssert(calc.getExpression() == "0")
    }
    // tests CE button when current sequence is a number
    func testGivenExpressionIsStarting_WhenEntriesAreOnePlusTwoCE_ThenExpressionElementsAreOneAndPlus() {
        // When
        calc.addNumberOrDotToExpression("1")
        calc.addOperandToExpression("+")
        calc.addNumberOrDotToExpression("2")
        calc.deleteLastSequence()
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+"])
    }
    // tests CE button when current sequence is operand
    func testGivenExpressionIsStarting_WhenEntriesAreOnePlusTwoPlusCE_ThenExpressionElementsAreOneAndPlusAndTwo() {
        // When
        calc.addNumberOrDotToExpression("1")
        calc.addOperandToExpression("+")
        calc.addNumberOrDotToExpression("2")
        calc.addOperandToExpression("+")
        calc.deleteLastSequence()
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+", "2"])
    }
    // tests CE button when current sequence is a number containing dot
    func testGivenExpressionIsStarting_WhenEntriesAreOnePlusTwoDotCE_ThenExpressionElementsAreOneAndPlus() {
        // When
        calc.addNumberOrDotToExpression("1")
        calc.addOperandToExpression("+")
        calc.addNumberOrDotToExpression("2")
        calc.addNumberOrDotToExpression(".")
        calc.deleteLastSequence()
        // Then
        XCTAssert(calc.getExpression().elements() == ["1", "+"])
    }
    // tests restarting expression when typing number after resolvation
    func testGivenExpressionIsStarting_WhenEntriesAreOnePlusTwoEqualOne_ThenExpressionIsOne() {
        // When
        calc.addNumberOrDotToExpression("1")
        calc.addOperandToExpression("+")
        calc.addNumberOrDotToExpression("2")
        calc.resolveExpression()
        calc.addNumberOrDotToExpression("1")
        // Then
        XCTAssert(calc.getExpression() == "1")
    }

}
