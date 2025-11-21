//
//  LoginUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 20/08/2024.
//

import Foundation
import Combine

class LoginUseCase {
    
    private let repo: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(request: LoginRequest) -> AnyPublisher<LoginData, NetworkError> {
        return repo.login(body: request)
    }
}
