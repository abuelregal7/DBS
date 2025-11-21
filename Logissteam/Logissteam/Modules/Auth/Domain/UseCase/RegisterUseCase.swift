//
//  RegisterUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation
import Combine

class RegisterUseCase {
    
    private let repo: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute(request: RegisterRequest) -> AnyPublisher<RegisterData, NetworkError> {
        return repo.register(body: request)
    }
}
