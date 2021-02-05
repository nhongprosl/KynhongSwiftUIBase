//
//  BackendConnector.swift
//  KyNhongBase
//
//  Created by Kynhong on 12/9/20.
//

import Foundation
import Alamofire
import Combine

class BackendConnector {
    
    func request<T: BackendRouter, R: Codable>(target: T, responseType: R.Type) -> AnyPublisher<Data, Error> {
        return Future { promise in
            self.request(target: target).sink(receiveCompletion: { completed in
                print("completed", completed)
//                promise(.success(completed))
            }, receiveValue: { data in
                print("receiveValue", data)
                promise(.success(data))
            })
        }.eraseToAnyPublisher()
    }
    
    func request<T: BackendRouter>(target: T) -> AnyPublisher<Data, Error> {
        return Future { promise in
            let baseURL = target.baseURL
            let path = target.path
            
            var url: String = ""
            if path.hasPrefix("/") || baseURL.hasSuffix("/") {
                url = "\(baseURL)\(path)"
            } else {
                url = "\(baseURL)/\(path)"
            }
            
            if let query = target.queryParams {
                var params: [String] = []
                for key in query.keys {
                    let value = query[key]!
                    let param = "\(key)=\(value)"
                    params.append(param)
                }
                let paramsString = params.joined(separator: "&")
                url.append("?")
                url.append(paramsString)
            }
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? url
            
            var method: Alamofire.HTTPMethod = .get
            switch target.method {
            case .get:
                method = .get
            case .post:
                method = .post
            case .delete:
                method = .delete
            case .put:
                method = .put
            }
            
            var headers = self.headers(isBasic: target.isBasicAuth)
            if let commonHeaders = target.commonHeaders {
                for key in commonHeaders.keys {
                    let value = commonHeaders[key]!
                    let header = HTTPHeader(name: key, value: value)
                    headers.add(header)
                }
            }
            
            let session = DataManager.shared.getSession()
            if let arrayBody = target.customBody, var urlRequest = try? URLRequest(url: url, method: method, headers: headers) {
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: arrayBody, options: .prettyPrinted)
                session.request(urlRequest).validate(statusCode: [200]).responseData { response in
                    let requestURLString = response.request?.url?.absoluteString ?? ""
                    switch response.result {
                    case .failure(let error):
                        promise(.failure(CustomError.error(with: error)))
                    case .success(let data):
                        promise(.success(data))
                    }
                }
            } else if let formData = target.mutipathFormDatas {
                session.upload(multipartFormData: formData, to: url, method: method, headers: headers).validate(statusCode: [200]).responseData { response in
                    let requestURLString = response.request?.url?.absoluteString ?? ""
                    switch response.result {
                    case .failure(let error):
                        promise(.failure(CustomError.error(with: error)))
                    case .success(let data):
                        promise(.success(data))
                    }
                }
            } else {
                session.request(url, method: method, parameters: target.body, encoding: JSONEncoding.prettyPrinted, headers: headers).validate(statusCode: [200]).responseData { response in
                    let requestURLString = response.request?.url?.absoluteString ?? ""
                    switch response.result {
                    case .failure(let error):
                        promise(.failure(CustomError.error(with: error)))
                    case .success(let data):
                        promise(.success(data))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}

extension BackendConnector {
    fileprivate enum AuthBasic: String {
        case username = "mobile_app"
        case password = "mobile_app@123456!"
    }
    
    fileprivate func headers(isBasic: Bool) -> Alamofire.HTTPHeaders {
        var headers = HTTPHeaders()
//        headers.add(HTTPHeader(name: "lang", value: DataManager.shared.language.rawValue))
//        headers.add(HTTPHeader(name: "client-type", value: clientType))
//        headers.add(HTTPHeader(name: "client-version", value: clientVersion))
//        headers.add(HTTPHeader(name: "device-type", value: deviceType))
//        headers.add(HTTPHeader(name: "device-id", value: deviceId))
        
//        if isBasic {
//            let header = HTTPHeader.authorization(username: AuthBasic.username.rawValue, password: AuthBasic.password.rawValue)
//            headers.add(header)
//        } else if let token = DataManager.shared.token {
//            let header = HTTPHeader.authorization(bearerToken: token)
//            headers.add(header)
//        } else {
//            let header = HTTPHeader.authorization(username: AuthBasic.username.rawValue, password: AuthBasic.password.rawValue)
//            headers.add(header)
//        }
//
        return headers
    }
}

