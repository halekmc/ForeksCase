//
//  SymbolsViewModel.swift
//  ForeksCase
//
//  Created by KBM-PC on 6.07.2022.
//

import Foundation

private enum ConstantKeys: String {
    case id = "tke"
    case time = "clo"
    case lastValue = "las"
    case percentDiff = "pdd"
    case diff = "ddi"
}

protocol SymbolsViewModelProtocol {
    func updateData(leftKey: String?, rightKey: String?, completion: (() -> ())?)
    func numberOfSymbols() -> Int
    func dataCarrierAtIndex(atIndex: Int) -> SymbolDataCarrier
    func selectedKeys() -> (String, String)
    func keyList() -> [PageDetail]
    func nameOfKey(key: String) -> String
}

class SymbolsViewModel: NSObject, SymbolsViewModelProtocol {
    
    private lazy var provider = DataProvider()
    private var options: [PageDetail] = []
    private var symbolList: [Symbol] = []
    private var leftKey = ""
    private var rightKey = ""
    private var currentData: [SymbolDataCarrier] = []
    
    func updateData(leftKey: String?, rightKey: String?, completion: (() -> ())?) {
        self.provider.fetchSymbolList { [unowned self] (result) in
            self.options.removeAll()
            self.symbolList.removeAll()
            switch (result) {
            case .success(let response):
                self.symbolList.append(contentsOf: response.mypageDefaults)
                self.options.append(contentsOf: response.mypage)
                self.leftKey = self.options[0].key
                self.rightKey = self.options[1].key
                if let leftKey = leftKey {
                    self.leftKey = leftKey
                }
                if let rightKey = rightKey {
                    self.rightKey = rightKey
                }
                let symbolKeys = self.symbolList.map{ symbol in symbol.tke}
                let optionKeys = [ConstantKeys.lastValue.rawValue, self.leftKey, self.rightKey]
                self.provider.fetchSymbolDetails(symbolIDs: symbolKeys, detailIDs: optionKeys) { (result) in
                    switch result {
                    case .success(let response):
                        self.handleNewData(newData: response)
                        completion?()
                    case .failure(let error):
                        print(error)
                        completion?()
                    }
                }
            case .failure(let error):
                print(error)
                completion?()
            }
        }
    }
    
    private func handleNewData(newData: SymbolDetail) {
        let carrierData = self.castDataCarrier(data: newData.symbolDetails)
        self.currentData.removeAll()
        self.currentData.append(contentsOf: carrierData)
    }
    
    private func castDataCarrier(data: [SymbolDetailItem]) -> [SymbolDataCarrier] {
        var carrierList: [SymbolDataCarrier] = []
        for symbol in self.symbolList {
            let id = symbol.tke
            var detail: [String: String] = [:]
            for item in data {
                if item[ConstantKeys.id.rawValue] == id {
                    detail = item
                    break
                }
            }
            let time = detail[ConstantKeys.time.rawValue] ?? "-"
            let lastValue = detail[ConstantKeys.lastValue.rawValue] ?? "0"
            let leftValue = detail[self.leftKey] ?? "0"
            let rightValue = detail[self.rightKey] ?? "0"
            var needsHighlight = false
            var riseState = SymbolRiseState.noChange
            var leftValueState = SymbolRiseState.noChange
            var rightValueState = SymbolRiseState.noChange
            for prev in self.currentData {
                if prev.symbolID == id {
                    if prev.lastValue != time {
                        if prev.time != time {
                            needsHighlight = true
                        }
                        riseState = self.compareValues(previous: prev.lastValue, next: lastValue)
                        if self.leftKey == ConstantKeys.percentDiff.rawValue || self.leftKey == ConstantKeys.diff.rawValue {
                            leftValueState = compareValues(previous: prev.leftValue, next: leftValue)
                        }
                        if self.rightKey == ConstantKeys.percentDiff.rawValue || self.rightKey == ConstantKeys.diff.rawValue {
                            rightValueState = compareValues(previous: prev.rightValue, next: rightValue)
                        }
                    }
                    break
                }
            }
            let carrier = SymbolDataCarrier(symbolID: id, symbolName: symbol.cod, time: time, lastValue: lastValue, needsHighlight: needsHighlight, riseState: riseState, leftValue: leftValue, rightValue: rightValue, leftValueState: leftValueState, rightValueState: rightValueState)
            carrierList.append(carrier)
        }
        return carrierList
    }
    
    private func compareValues(previous: String, next: String) -> SymbolRiseState {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        guard let prevNumber = formatter.number(from: previous) else { return SymbolRiseState.noChange }
        guard let  nextNumber = formatter.number(from: next) else { return SymbolRiseState.noChange }
        let comparison = prevNumber.compare(nextNumber)
        switch comparison {
        case .orderedAscending:
            return SymbolRiseState.increasing
        case .orderedDescending:
        return SymbolRiseState.decreasing
        default:
            return SymbolRiseState.noChange
        }
    }
    
    func numberOfSymbols() -> Int {
        return self.currentData.count
    }
    
    func dataCarrierAtIndex(atIndex: Int) -> SymbolDataCarrier {
        return self.currentData[atIndex]
    }
    
    func selectedKeys() -> (String, String) {
        return (self.leftKey, self.rightKey)
    }
    
    func keyList() -> [PageDetail] {
        return self.options
    }
    
    func nameOfKey(key: String) -> String {
        return self.options.first(where: {$0.key == key})?.name ?? "-"
    }
}
