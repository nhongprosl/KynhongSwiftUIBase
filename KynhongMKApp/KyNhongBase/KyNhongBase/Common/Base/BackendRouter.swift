//
//  BackendRouter.swift
//  KyNhongBase
//
//  Created by Kynhong on 12/9/20.
//

import Foundation
import Alamofire

enum BackendMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}
protocol BackendRouter {
    var baseURL: String {get}
    var path: String {get}
    var method: BackendMethod {get}
    var queryParams: [String: String]? {get}
    var body: [String: Any]? {get}
    var mutipathFormDatas: MultipartFormData? {get}
    var isBasicAuth: Bool {get}
    var commonHeaders: [String: String]? {get}
    var errorKeyHandling: [ErrorKey]? {get}
    var customBody: Any? {get}
}

extension BackendRouter {
    var customBody: Any? {
        return nil
    }
}

