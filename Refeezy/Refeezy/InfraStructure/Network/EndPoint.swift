//
//  EndPoint.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import Foundation
import Alamofire

protocol Endpoint: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}

extension Endpoint {
    
    var baseURL: URL {
        return URL(string: Constants.baseURL)!
    }
    
    var headers: HTTPHeaders? {
        var headers = HTTPHeaders()
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["lang"] = Language.currentLanguage.languageIdentifier
        if let apitoken = UD.accessToken, apitoken != "" {
            headers["Authorization"] = "Bearer " + apitoken
        }
        return headers
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var urlRequest = try URLRequest(url: url, method: method, headers: headers)
        urlRequest = try encoding.encode(urlRequest, with: parameters)
        return urlRequest
    }
}
