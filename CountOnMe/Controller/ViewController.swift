//
//  ViewController.swift
//  CountOnMe
//
//  Orignally created by Vincent Saluzzo. Updated by Greg on 04/07/2021.
//  Copyright © 2021 Greg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak internal var textView: UITextView!
    
    @IBOutlet internal var numberButtons: [UIButton]!
    @IBOutlet internal var operandButtons: [UIButton]!
    
    @IBOutlet weak internal var gestureCEACButton: UIButton!
    
    enum Button {
        case operands, equal
    }
    
    private var calc = Calc()
    
    private var expression = String() {
        didSet { // when expression changes
            self.textView.text = self.expression // update textView's text
            self.textView.scrollToBottom() // scroll textView's text to bottom
            updateButtonsAndTextAvailability()
        }
    }
    
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        calc.delegate = self // Calc class delegate
        
        updateDataScreenCalculator()
        
        // gestures recognizer initializations
        self.textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedScreenDisplay)))
        self.gestureCEACButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedCEACButton)))
        self.gestureCEACButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressedACCEButton)))
    }
    
    override internal func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.scrollToBottom() // security of scroll textView's text to bottom due to update bug
    }
    
    @objc internal func tappedScreenDisplay(sender: UITapGestureRecognizer) {
        if self.expression.containsResult() {
            copyExpressionInClipboard()
            expressionCopiedAlertMessage()
        }
    }
    
    @objc internal func tappedCEACButton(sender: UITapGestureRecognizer) {
        if self.expression.containsResult() {
            Vibration.For.acResetButton.perform()
            calc.resetExpression()
        } else {
            if !self.expression.elements().isLenghtOne() {
                Vibration.For.ceClearButton.perform()
                calc.deleteLastSequence()
            } else {
                Vibration.For.shakeAction.perform()
                self.textView.shake()
            }
        }
    }
    
    @objc internal func longPressedACCEButton(sender: UILongPressGestureRecognizer) {
        Vibration.For.acResetButton.perform()
        calc.resetExpression()
    }
    
    @IBAction internal func tappedNumberButton(_ sender: UIButton) {
        Vibration.For.numbersAndDotButtons.perform()
        guard let entry = sender.title(for: .normal) else {
            return
        }
        calc.addToExpression(entry)
    }
    
    @IBAction internal func tappedOperandButton(_ sender: UIButton) {
        Vibration.For.operandsButtons.perform()
        guard let entry = sender.title(for: .normal) else {
            return
        }
        calc.addToExpression(entry)
    }
    
    @IBAction internal func tappedEqualButton(_ sender: UIButton) {
        Vibration.For.equalButton.perform()
        calc.resolveExpression()
    }
    
    private func updateButtonsAndTextAvailability() {
        buttonAvailability(type: .operands, visibility: true)
        buttonAvailability(type: .equal, visibility: true)
        changeCEACbuttonTextTo("CE / AC")
        
        if self.expression.currentSequence().isFloatZero() || self.expression.containsResult() {
            buttonAvailability(type: .operands, visibility: false)
        }
        if !self.expression.hasEnoughElementsToResolve() && !self.expression.containsResult() || self.expression.currentSequence().isOperand()  {
            buttonAvailability(type: .equal, visibility: false)
        }
        if self.expression.containsResult() {
            changeCEACbuttonTextTo("AC")
        }
    }
    
    private func buttonAvailability(type: Button, visibility: Bool) {
        if type == .operands {
            self.operandButtons.forEach( { $0.isHighlighted = !visibility ; $0.isEnabled = visibility } )
        }
        if type == .equal {
            self.operandButtons.last?.isHighlighted = !visibility
            self.operandButtons.last?.isEnabled = visibility
        }
    }
    
    private func changeCEACbuttonTextTo(_ text: String) {
        self.gestureCEACButton.setTitle(text, for: .normal)
    }
    
    private func expressionCopiedAlertMessage() {
        let alert = UIAlertController(title: "Succesfull!", message: "Expression copied in clipboard", preferredStyle: .alert)
        present(alert, animated: true) {
            sleep(2)
            alert.dismiss(animated: true)
        }
    }
    
    private func copyExpressionInClipboard() {
        UIPasteboard.general.string = self.expression
    }
}

extension ViewController: CalcDelegate {
    internal func updateDataScreenCalculator() {
        self.expression = calc.getExpression()
    }
}
