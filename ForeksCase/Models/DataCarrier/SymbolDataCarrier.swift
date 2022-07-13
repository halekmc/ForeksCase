//
//  SymbolDataCarrier.swift
//  ForeksCase
//
//  Created by KBM-PC on 6.07.2022.
//

import Foundation

enum SymbolRiseState {
    case increasing
    case noChange
    case decreasing
}

struct SymbolDataCarrier {
    
    let symbolID: String
    let symbolName: String
    let time: String
    let lastValue: String
    let needsHighlight: Bool
    let riseState: SymbolRiseState
    let leftValue: String
    let rightValue: String
    let leftValueState: SymbolRiseState
    let rightValueState: SymbolRiseState
}
