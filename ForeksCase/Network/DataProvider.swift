//
//  DataProvider.swift
//  ForeksCase
//
//  Created by KBM-PC on 6.07.2022.
//

import Foundation
import Alamofire

enum SymbolListResult{
    case success(SymbolListResponse)
    case failure(String)
}

enum SymbolDetailResult{
    case success(SymbolDetail)
    case failure(String)
}

class DataProvider {
    func fetchSymbolList(completion: @escaping (SymbolListResult) -> Void) {
        let request = AF.request(symbolListURL)
        request.responseJSON { (result) in
            if let data = result.data {
                do {
                    let list = try JSONDecoder().decode(SymbolListResponse.self, from: data)
                    completion(.success(list))
                } catch {
                    completion(.failure("Symbol List error"))
                }
            }
        }
    }
    func fetchSymbolDetails(symbolIDs: [String], detailIDs: [String], completion: @escaping (SymbolDetailResult) -> Void) {
        let parameterURL = symbolDetailURL + "?fields=" + detailIDs.joined(separator: ",") + "&stcs=" + symbolIDs.joined(separator: "~")
        let request = AF.request(parameterURL)
        request.responseJSON { (result) in
            if let data = result.data {
                do {
                    let itemMap = try JSONDecoder().decode(SymbolDetail.self, from: data)
                    completion(.success(itemMap))
                } catch {
                    completion(.failure("Symbol detail error"))
                }
            }
        }
    }
}
