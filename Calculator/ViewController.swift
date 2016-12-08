//
//  ViewController.swift
//  Calculator
//
//  Created by martynov on 2016-08-15.
//  Copyright © 2016 martynov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display!.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    // Here we invented a new property that is calculated
    // This is the example of the computed property, not stored
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
    
        if let mathematicalSymbol = sender.currentTitle {
            brain.performeOperation(mathematicalSymbol)
            
            }
        displayValue = brain.result
        
    
    }
    
}

