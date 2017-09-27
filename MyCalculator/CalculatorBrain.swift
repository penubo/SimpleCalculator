//
//  CalculatorBrain.swift
//  MyCalculator
//
//  Created by Joon on 14/09/2017.
//  Copyright © 2017 Joon. All rights reserved.
//

import Foundation



class CalculatorBrain {
    
    
    private struct Description {
        var formula: String = ""
        var operation: String = ""
        var result: String = ""

        func displayValue() -> String {
            return formula+operation+result
        }
        mutating func clear() {
            formula = ""
            operation = ""
            result = ""
        }
    }
    
    private var description = Description()
    
    var resultIsPending: Bool = false
    private var userIsInTheMiddleOfTyping: Bool = false
    private var accumulator: Double = 0.0
    
    private var labelText: String = "0" {
        didSet {
            if labelText.isEmpty {
                clear()
            }
            if labelText.hasSuffix(".0") { labelText = String(labelText.dropLast(2)) }
            
            accumulator = Double(labelText) ?? 0.0
//            print("accumulator: \(accumulator)")
        }
    }
    
    private enum Operator {
        case constant(Double)
        case unaryOperator((Double) -> Double)
        case binaryOperator((Double, Double) -> Double)
        case equal
    }
    
    private var operators: Dictionary<String, Operator> = [
        "π" : .constant(Double.pi),
        "√" : .unaryOperator(sqrt),
        "+" : .binaryOperator(+),
        "-" : .binaryOperator(-),
        "×" : .binaryOperator(*),
        "÷" : .binaryOperator(/),
        "=" : .equal
    ]
    
    
    func changeTypingMode(to type: Bool) {
        userIsInTheMiddleOfTyping = type
    }
    func isUserInTheMiddleOfTyping() -> Bool {
        return userIsInTheMiddleOfTyping
    }
    
    
    func labelAppend(of digit: String) -> String {
        if description.result != "" {
            return labelText
        }
        if userIsInTheMiddleOfTyping == false {
            labelText = digit
            userIsInTheMiddleOfTyping = digit != "0" ? true : false
        } else if userIsInTheMiddleOfTyping == true {
            let currentTextInLabel = labelText
            labelText = currentTextInLabel + digit
        }
        
        return labelText
    }
    
    func labelDrop() -> String {
        if userIsInTheMiddleOfTyping == true && !labelText.isEmpty {
            let lastIndexOfLabel = labelText.index(before: labelText.endIndex)
            labelText.remove(at: lastIndexOfLabel)
        }
        return labelText
    }
    
    func clear() {
        let tempDouble = Double(labelText)
        changeTypingMode(to: false)
        labelText = labelAppend(of: "0")
        accumulator = tempDouble!
    }
    
    func allClear() {
        resultIsPending = true
        clear()
        description.clear()
        pendingBinaryOperation = nil
    }
    
    func performOperation(_ symbol: String) {
        
        if let operation = operators[symbol] {
            switch operation {
            case .constant(let value):
                if resultIsPending == true {
                    labelText = String(value)
                }
            case .unaryOperator(let function):
                if resultIsPending == true {
                    break
                }
                if description.result != "" {
                    description.formula = "\(symbol)(\(description.formula))"
                } else {
                    description.formula = "\(symbol)(\(description.formula + labelText))"
                }
                description.operation = " = "

                labelText = String(function(accumulator))
                description.result = labelText
                resultIsPending = false
            case .binaryOperator(let function):
                pendingBinaryOperation = nil
                pendingBinaryOperation = PendingBinaryOperation(operand: accumulator, operation: function)
                
                description.operation = " ... "
                if description.result != "" {
                    description.formula = description.formula + " \(symbol) "
                } else {
                    description.formula = description.formula + labelText + " \(symbol) "
                }
                description.result = ""
                resultIsPending = true
            case .equal:
                
                // I'm not going to 'pendingBinaryOperation = nil' becuase I want to calculate while changing operand like apple calculate. instead, I'm adding pendingBinaryOperation when user touch the any operator.
                if let result = pendingBinaryOperation?.performBinaryOperation(accumulator) {
                    resultIsPending = false
                    description.formula += String(labelText)
                    description.operation = " \(symbol) "
                    labelText = String(result)
                    description.result = labelText
//                    print("accumulator: \(accumulator)")
                    print("UserIsInTheMiddleOfTyping: \(userIsInTheMiddleOfTyping)")
                    print("ResultIsPending: \(resultIsPending)")

                }
            }
        }
    }
    
    var pendingBinaryOperation: PendingBinaryOperation?
    
    struct PendingBinaryOperation {
        var operand: Double
        var operation: (Double, Double) -> Double
        
        func performBinaryOperation(_ second: Double) -> Double {
            return operation(operand, second)
        }
    }
    
    var result: String { return labelText }
    var displayResult: String { return description.displayValue() }
    
}
