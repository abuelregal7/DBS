//
//  RequestInterceptor.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import Foundation
import Alamofire

class RequestInterceptor: Alamofire.RequestInterceptor, Alamofire.RequestRetrier {
    
    private var retryCount = 0
    
    private var configRetryCount: [Alamofire.Request: Int] = [:]
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Alamofire.Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        if let requestURL = request.request?.url?.absoluteString {
            if requestURL.contains("Config") {
                configRetryCount[request, default: 0] += 1
                if configRetryCount[request, default: 0] < 9 {
                    completion(.retryWithDelay(7))
                    print("Retry Count \(configRetryCount)")
                    return
                }
            }
        }

        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        switch statusCode {
        case 401:
            completion(.doNotRetry)
        case 429:
            retryCount += 1
            if retryCount < 3 {
                completion(.retry)
            }
        default:
            break
        }
    }
}
