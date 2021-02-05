//
//  CustomError.swift
//  KyNhongBase
//
//  Created by Kynhong on 12/10/20.
//

import Foundation

enum CustomError: LocalizedError {
    case error(with: Error)
    case backendError(error: BackendError)
    case commonError
    case noInternetError
    
    var errorDescription: String? {
        switch self {
        case .error(let error):
            if let afError = error.asAFError {
                return afError.errorDescription
            } else {
                return error.localizedDescription
            }
            
        case .backendError(let error):
            return error.errorDescription
        case .commonError:
            return "Rất tiếc, đã có sự cố xảy ra, xin vui lòng thử lại.".localized()
        case .noInternetError:
            return "Không thể kết nối đến máy chủ\nVui lòng kiểm tra lại kết nối mạng".localized()
        }
    }
    
    var backendError: BackendError? {
        switch self {
        case .backendError(let error):
            return error
        default:
            return nil
        }
    }
    
}
