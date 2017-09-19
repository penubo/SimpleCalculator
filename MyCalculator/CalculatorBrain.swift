//
//  CalculatorBrain.swift
//  MyCalculator
//
//  Created by Joon on 14/09/2017.
//  Copyright © 2017 Joon. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var UserIsInTheMiddleOfTyping: Bool = false
    private var accumulator: Double = 0.0
    
    private var labelText: String = "0" {
        didSet {
            if labelText.isEmpty {
                clear()
            }
            accumulator = Double(labelText) ?? 0.0
            print("accumulator: \(accumulator)")
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
        UserIsInTheMiddleOfTyping = type
    }
    
    
    func labelAppend(of digit: String) -> String {
        if UserIsInTheMiddleOfTyping == false {
            labelText = digit
            UserIsInTheMiddleOfTyping = digit != "0" ? true : false
        } else if UserIsInTheMiddleOfTyping == true {
            let currentTextInLabel = labelText
            labelText = currentTextInLabel + digit
        }
        return labelText
    }
    
    func labelDrop() -> String {
        if UserIsInTheMiddleOfTyping == true && !labelText.isEmpty {
            let lastIndexOfLabel = labelText.index(before: labelText.endIndex)
            labelText.remove(at: lastIndexOfLabel)
        }
        return labelText
    }
    
    func clear() {
        changeTypingMode(to: false)
        labelText = labelAppend(of: "0")
    }
    
    func allClear() {
        clear()
        pendingBinaryOperation = nil
    }
    
    func performOperation(_ symbol: String) {
        if let operation = operators[symbol] {
            switch operation {
            case .constant(let value):
                labelText = String(value)
            case .unaryOperator(let function):
                labelText = String(function(accumulator))
            case .binaryOperator(let function):
                pendingBinaryOperation = nil
                pendingBinaryOperation = PendingBinaryOperation(operand: accumulator, operation: function)
            case .equal:
                // I'm not going to 'pendingBinaryOperation = nil' becuase I want to calculate while changing operand like apple calculate. instead, I'm adding pendingBinaryOperation when user touch the any operator.
                if let result = pendingBinaryOperation?.performBinaryOperation(accumulator) {
                    labelText = String(result)
                    print("accumulator: \(accumulator)")
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
    
}
