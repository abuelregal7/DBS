//
//  LogoutUseCase.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 01/09/2024.
//

import Foundation
import Combine

class LogoutUseCase {
    
    private let repo: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repo = repository
    }
    
    func execute() -> AnyPublisher<LogoutModel, NetworkError> {
        return repo.logout()
    }
}
