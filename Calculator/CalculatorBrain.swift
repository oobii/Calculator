//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by oobii on 2016-08-29.
//  Copyright © 2016 martynov. All rights reserved.
//


// This is our Model that perform calculation and we have it
// here, separatly, and not in the Controller

import Foundation

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

func oneByX(op: Double) -> Double {
    return 1/op
}

func sqrt3(op: Double) -> Double {
    return pow(op, 1/3)
}

class CalculatorBrain {
    
    private var accumulator = 0.0
    var description = ""
    private var isPartialResult = false
    private var isEquals = false
    
    // Storing aout internal program as array of Double and Strings
    private var internalProgram = [AnyObject]()
    
    func setOperand( operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
        
        description = description + " " + String(accumulator)
        
    }
    
    
    
    var operations: Dictionary<String,Operation> = [
        
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt), // sqrt
        "∛" : Operation.UnaryOperation(sqrt3), // !!! fix
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "ln" : Operation.UnaryOperation(log),
        "1/x": Operation.UnaryOperation(oneByX),
        //add unary minus/plus
        "×": Operation.BinaryOperation({ return $0 * $1 }),
        "÷": Operation.BinaryOperation({ return $0 / $1 }),
        "+": Operation.BinaryOperation({ return $0 + $1}),
        "−": Operation.BinaryOperation({ return $0 - $1 }),
        "=": Operation.Equals,
        "AC": Operation.Reset,
        
        ]
    
    // check the name for the enums () !!!!!
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Reset
    }
    
    // we want that to be nil if we did not set it
    private var pending: PendingBinaryOperationInfo?
    
    // Salting away function and the first operand
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    func performeOperation(symbol:String) {
        internalProgram.append(symbol)
        if let constant = operations[symbol] {
            switch constant {
                
            case .Constant(let value): accumulator = value
                
            case .BinaryOperation(let function):
                ExecutePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator )
                isPartialResult = true
                
            case .UnaryOperation(let function): accumulator = function(accumulator)
                
            case .Equals: ExecutePendingBinaryOperation()
            isPartialResult = false
            isEquals = true
                
            case .Reset: ExecuteReset()
                
                
            }
            if symbol != "AC" {
                
                description = description + " " + symbol
                
            } else {
                descriptionValue = " "
            }
        }
    }
    
    private func ExecutePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
        }
    }
    
    private func ExecuteReset() {
        accumulator = 0.0
        pending = nil
        isPartialResult = false
        descriptionValue = " "
        
    }
    
    typealias  PropertyList = AnyObject
    var program: PropertyList {
        
        get {
            return internalProgram
        }
        
        set {
            //clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performeOperation(operation)
                    }
                }
            }
            
        }
        
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var descriptionValue: String {
        set {
            description = " "
        }
        get {
            if isPartialResult {
                return description + "..."
            } else {
                
                return description
            }
        }
    }
}
