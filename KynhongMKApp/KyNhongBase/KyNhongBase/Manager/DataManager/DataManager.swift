//
//  DataManager.swift
//  KyNhongBase
//
//  Created by Kynhong on 12/9/20.
//

import Foundation
import Alamofire

class DataManager {
    public static let shared = DataManager()
    
    private var sessionManager: Alamofire.Session!
    
    func getSession() -> Alamofire.Session {
        if self.sessionManager == nil {
            self.sessionManager = Alamofire.Session(serverTrustManager: ServerTrustManager(evaluators: self.serverTrusts()))
        }
        return self.sessionManager
    }
    
    // MARK: - Private functions
    private func serverTrusts() -> [String: ServerTrustEvaluating] {
        return [:]
    }
    
    private struct Certificates {
//        static let foxpay = Certificates.certificate(filename: "foxpay-keycert")
//
//        private static func certificate(filename: String) -> SecCertificate {
//            let filePath = Bundle.main.path(forResource: filename, ofType: "der")!
//            let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
//            let certificate = SecCertificateCreateWithData(nil, data as CFData)!
//
//            return certificate
//        }
    }
    
}
