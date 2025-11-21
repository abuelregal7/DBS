//
//  NetworkManager.swift
//  Maintenance
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import Foundation
import Alamofire
import Combine

protocol NetworkLayerProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void)
    func upload<T: Decodable>(_ endpoint: Endpoint, uploadData: UploadDataModel?) -> AnyPublisher<T, NetworkError>
}

class NetworkManager: NetworkLayerProtocol {
    static let shared = NetworkManager()
    private var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.headers = HTTPHeaders.default
        let interceptor = RequestInterceptor()
        return Session(configuration: configuration, interceptor: interceptor)
    }()
    
    private init() {}
    
    /// ✅ Single function supporting both Combine & async/await
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        return Future { promise in
            Task {
                do {
                    let result: T = try await self.fetch(endpoint)
                    promise(.success(result))
                } catch let error as NetworkError {
                    promise(.failure(error))
                } catch {
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// ✅ Shared async function
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        return try await fetch(endpoint)
    }
    
    /// ✅ Private function to handle Alamofire request
    private func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        print("\nURL: \(endpoint.urlRequest?.url?.absoluteString ?? "")")
        print("\nHeaders:\n \(endpoint.urlRequest?.headers ?? [:])")
        print("\nBody:\n \(endpoint.parameters ?? [:])")
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self =  self else { return }
            session.request(endpoint)
                .validate(statusCode: 200..<500)
                .responseDecodable(of: T.self) { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case .success(let value):
                        print("\n\nResponse:\n\n \(value)\n\n**********************************************\n")
                        continuation.resume(returning: value)
                    case .failure(let error):
                        let networkError = self.handleNetworkError(error)
                        continuation.resume(throwing: networkError)
                    }
                }
        }
    }
    
    func handleNetworkError(_ error: AFError?) -> NetworkError {
        if let afError = error {
            switch afError {
            case .sessionTaskFailed:
                if let urlError = afError.underlyingError as? URLError {
                    switch urlError.code {
                    case .timedOut:
                        return .timeOut
                    default:
                        return .general(urlError.localizedDescription)
                    }
                } else {
                    return .unknown
                }
            case .responseSerializationFailed:
                if let decodingError = afError.underlyingError as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted, .keyNotFound, .typeMismatch, .valueNotFound:
                        return .decodingError
                    default:
                        return .general(decodingError.localizedDescription)
                    }
                } else {
                    return .general(afError.localizedDescription)
                }
            case .requestRetryFailed:
                return .serverError
            default:
                return .general(afError.localizedDescription)
            }
        } else {
            return .unknown
        }
    }
    
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        print("\n**********************************************\n")
        print("\nURL: \(endpoint.urlRequest?.url?.absoluteString ?? "")")
        print("\nHeaders:\n \(endpoint.urlRequest?.headers ?? [:])")
        print("\nBody:\n \(endpoint.parameters ?? [:])")
        if !(NetworkMonitor.shared.isConnected) {
            completion(.failure(.noNetwork))
        }
        session.request(endpoint)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let model):
                    print("\n\nResponse:\n\n \(model)\n\n**********************************************\n")
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(self.handleNetworkError(error)))
                }
            }
    }
    
    func upload<T: Decodable>(
        _ endpoint: Endpoint,
        uploadData: UploadDataModel? = nil
    ) -> AnyPublisher<T, NetworkError> {
        
        print("\nURL: \(endpoint.urlRequest?.url?.absoluteString ?? "")")
        print("\nHeaders:\n \(endpoint.urlRequest?.headers ?? [:])")
        print("\nBody:\n \(endpoint.parameters ?? [:])")
        print("\nuploadData:\n \(uploadData ?? UploadDataModel(fileName: "", mimeType: "", data: Data(), name: ""))")
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            self.session.upload(multipartFormData: { formData in
                // Append upload data if available
                if let data = uploadData {
                    formData.append(
                        data.data,
                        withName: data.name,
                        fileName: data.fileName,
                        mimeType: data.mimeType
                    )
                }
                
                // ✅ Directly iterate over `parameters` without unnecessary casting
                if let parameters = endpoint.parameters {
                    self.appendParameters(to: formData, parameters: parameters)
                }
                
            }, to: endpoint.urlRequest?.url?.absoluteString ?? "",
                                method: endpoint.method,
                                headers: endpoint.headers)
            .uploadProgress { progress in
                print("Upload progress: \(progress.fractionCompleted * 100)")
            }
            .validate(statusCode: 200..<500)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    print("\n\nResponse:\n\n \(value)\n\n**********************************************\n")
                    promise(.success(value))
                case .failure(let error):
                    let networkError = self.handleNetworkError(error)
                    promise(.failure(networkError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// ✅ Separate function to handle parameter appending
    private func appendParameters(to formData: MultipartFormData, parameters: Parameters) {
        for (key, value) in parameters {
            let unwrappedValue = unwrapSendable(value) // Safely unwrap any Sendable
            
            switch unwrappedValue {
            case let data as Data:
                formData.append(data, withName: key)
                
            case let string as String:
                if let data = string.data(using: .utf8) {
                    formData.append(data, withName: key)
                }
                
            case let int as Int:
                if let data = String(int).data(using: .utf8) {
                    formData.append(data, withName: key)
                }
                
            case let array as [Any]: // ✅ Fix: No direct cast from `Sendable`
                for index in array.indices { // ✅ Use `indices` instead of tuple destructuring
                    let elementKey = "\(key)[\(index)]"
                    if let data = "\(array[index])".data(using: .utf8) {
                        formData.append(data, withName: elementKey)
                    }
                }
                
            case let dictionary as [String: Any]: // ✅ Fix: No direct cast from `Sendable`
                for (dictKey, dictValue) in dictionary {
                    let elementKey = "\(key)[\(dictKey)]"
                    if let data = "\(dictValue)".data(using: .utf8) {
                        formData.append(data, withName: elementKey)
                    }
                }
                
            default:
                print("⚠️ Unsupported parameter type for key: \(key), type: \(type(of: value))")
            }
        }
    }
    
    /// Safely unwraps `any Sendable` values
    private func unwrapSendable(_ value: Any) -> Any {
        let mirror = Mirror(reflecting: value)
        
        if mirror.displayStyle == .optional, let firstChild = mirror.children.first {
            return firstChild.value // Extract optional value
        }
        
        return value
    }
    
}

extension DataRequest {
    func responseDecodableThrowing<T: Decodable>(of type: T.Type, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        let result = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Error>) in
            self.responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedValue = try decoder.decode(T.self, from: data)
                        continuation.resume(returning: decodedValue)
                    } catch {
                        continuation.resume(throwing: AFError.responseSerializationFailed(reason: .decodingFailed(error: error)))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        return result
    }
}
