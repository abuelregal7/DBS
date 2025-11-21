//
//  AuthEndPoint.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Alamofire

enum AuthEndPoint: Endpoint {
    
    //MARK: Cases
    case login(loginRequest: LoginRequest)
    case register(registerRequest: RegisterRequest)
    case verificationCode(verificationCodeRequest: VerificationCodeRequest)
    case logout
    case deleteAccount
    
    //MARK: Paths
    var path: String {
        switch self {
        case .login:
            return "client/auth/login"
        case .register:
            return "client/auth/sign_up"
        case .verificationCode:
            return "client/auth/login/verify"
        case .logout:
            return "client/auth/logout"
        case .deleteAccount:
            return "client/delete-account"
        }
    }
    
    //MARK: Method
    var method: HTTPMethod {
        switch self {
        case .login, .register, .verificationCode:
            return .post
        case .logout, .deleteAccount:
            return .get
        }
    }
    
    //MARK: Params
    var parameters: Parameters? {
        switch self {
        case .login(let loginRequest):
            return loginRequest.asDictionary()
        case .register(let registerRequest):
            return registerRequest.asDictionary()
        case .verificationCode(let verificationCodeRequest):
            return verificationCodeRequest.asDictionary()
        default:
            return [:]
        }
    }
    
    //MARK: Encoding
    var encoding: ParameterEncoding {
        switch self {
        case .login, .register, .verificationCode:
            return JSONEncoding.default
        case .logout, .deleteAccount:
            return URLEncoding.default
        }
    }
}
