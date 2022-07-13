//
//  SymbolDetail.swift
//  ForeksCase
//
//  Created by KBM-PC on 6.07.2022.
//

import Foundation

typealias SymbolDetailItem = [String: String]

struct SymbolDetail: Decodable {
    
    enum SymbolKeys: String, CodingKey {
        case list = "l"
    }
    
    let symbolDetails: [SymbolDetailItem]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SymbolKeys.self)
        self.symbolDetails = try container.decode(Array.self, forKey: .list)
    }
}
