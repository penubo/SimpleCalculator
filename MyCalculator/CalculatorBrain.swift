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
        "-" : .binaryOperator(-)
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
    
    func performOperation(_ symbol: String) {
        if let operation = operators[symbol] {
            switch operation {
            case .constant(let value):
                labelText = String(value)
            case .unaryOperator(let function):
                labelText = String(function(accumulator))
            case .binaryOperator(let function):
                break
            case .equal:
                break
            }
        }
    }
    
    var result: String { return labelText }
    
}
