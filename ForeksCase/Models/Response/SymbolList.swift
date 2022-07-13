//
//  SymbolList.swift
//  ForeksCase
//
//  Created by KBM-PC on 6.07.2022.
//

import Foundation

struct PageDetail: Decodable {
    let key: String
    let name: String
}

struct SymbolListResponse: Decodable {
    let mypageDefaults: [Symbol]
    let mypage: [PageDetail]
}
