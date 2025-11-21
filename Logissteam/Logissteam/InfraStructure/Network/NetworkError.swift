//
//  ValidationErrors.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import Foundation

protocol AppError: Error {
    var localizedErrorDescription: String { get }
}

enum NetworkError: AppError, Equatable {
    case general(String)
    case noNetwork
    case unknown
    case nullData
    case badRequest
    case unauthorized
    case unauthorizedWith(String)
    case notFound
    case serverError
    case timeOut
    case decodingError
    case encodingError
    
    var localizedErrorDescription: String {
        switch self {
        case .general(let message):
            return message
        case .noNetwork:
            return "no_internet".localized
        case .unknown:
            return "An unknown error occurred.".localized
        case .nullData:
            return "Data is Null.".localized
        case .badRequest:
            return "The request was malformed or invalid.".localized
        case .unauthorized:
            return "The request requires authentication.".localized
        case .unauthorizedWith(let message):
            return message
        case .notFound:
            return "The requested resource could not be found.".localized
        case .serverError:
            return "An error occurred on the server.".localized
        case .timeOut:
            return "Server timeOut.".localized
        case .decodingError:
            return "An error occurred while decoding the response.".localized
        case .encodingError:
            return "An error occurred while encoding the request.".localized
        }
    }
}
