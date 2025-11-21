//
//  AuthEndPoints.swift
//  Refeezy
//
//  Created by Ahmed Abo Al-Regal on 04/04/2025.
//

import Foundation
import Alamofire

enum AuthEndPoints: Endpoint {
    
    //MARK: Cases
    case login(loginRequest: LoginRequest)
    case verificationCode(verificationCodeRequest: VerificationCodeRequest)
    case register(registerRequest: RegisterRequest)
    
    //MARK: Paths
    var path: String {
        switch self {
        case .login:
            return "client/auth/login"
        case .verificationCode:
            return "client/auth/login/verify"
        case .register:
            return "client/auth/sign_up"
        }
    }
    
    //MARK: Method
    var method: HTTPMethod {
        switch self {
        case .login, .verificationCode, .register:
            return .post
        }
    }
    
    //MARK: Params
    var parameters: Parameters? {
        switch self {
        case .login(let loginRequest):
            return loginRequest.asDictionary()
        case .verificationCode(let verificationCodeRequest):
            return verificationCodeRequest.asDictionary()
        case .register(let registerRequest):
            return registerRequest.asDictionary()
        }
    }
    
    //MARK: Encoding
    var encoding: ParameterEncoding {
        switch self {
        case .login, .verificationCode, .register:
            return JSONEncoding.default
        }
    }
}
