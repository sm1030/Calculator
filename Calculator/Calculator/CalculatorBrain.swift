//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Alexandre Malkov on 04/12/2016.
//  Copyright © 2016 Alexandre Malkov. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : .constant(M_PI),
        "e" : .constant(M_E),
        "±" : .unaryOperation({ -$0 }),
        "√" : .unaryOperation(sqrt),
        "cos" : .unaryOperation(cos),
        "×" : .binaryOperation({ $0 * $1}),
        "÷" : .binaryOperation({ $0 / $1}),
        "+" : .binaryOperation({ $0 + $1}),
        "-" : .binaryOperation({ $0 - $1}),
        "=" : .equals
    ]
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                accumulator = function(accumulator)
            case .binaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .equals:
                executePendingBinaryOperation()
            }
        }
        
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
