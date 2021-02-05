//
//  BackendError.swift
//  KyNhongBase
//
//  Created by Kynhong on 12/10/20.
//

import Foundation

struct BackendError: Codable {
    let error: String
    let errorDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}
